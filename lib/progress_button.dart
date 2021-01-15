library progress_button;

import 'package:flutter/material.dart';
import 'package:progress_indicator_button/raised_gradient_button.dart';

enum ButtonState { idle, loading, success, error }

class ProgressButtonController {
  final _ProgressButtonState _state;
  ProgressButtonController._( this._state );
  Future<void> loading() async => await _state.updateState( ButtonState.loading );
  Future<void> success([ final Duration delayBeforeIdle = const Duration( seconds: 3 ) ]) async => await _state.updateState( ButtonState.success, delayBeforeIdle );
  Future<void> error([ final Duration delayBeforeIdle = const Duration( seconds: 3 ) ]) async => await _state.updateState( ButtonState.error, delayBeforeIdle );
}

class ProgressButton extends StatefulWidget {
  /// The background color of the button.
  final Color color;
  /// The background gradient of the button.
  final Gradient gradient;
  /// The progress indicator color.
  final Color progressIndicatorColor;
  /// The size of the progress indicator.
  final double progressIndicatorSize;
  /// The border radius while NOT animating.
  final BorderRadius borderRadius;
  /// The duration of the animation.
  final Duration animationDuration;

  /// The stroke width of progress indicator.
  final double strokeWidth;
  /// Function that will be called at the on pressed event.
  ///
  /// This will grant access to its [AnimationController] so
  /// that the animation can be controlled based on the need.
  final Function(ProgressButtonController) onPressed;
  /// The child to display on the button.
  final Widget child, successChild, errorChild;

  ProgressButton({
    @required this.child,
    @required this.successChild,
    @required this.errorChild,
    @required this.onPressed,
    this.gradient,
    this.color = Colors.blue,
    this.strokeWidth = 2,
    this.progressIndicatorColor = Colors.white,
    this.progressIndicatorSize = 30,
    this.borderRadius = const BorderRadius.all(Radius.circular(0)),
    this.animationDuration = const Duration(milliseconds: 500),
  });

  @override
  _ProgressButtonState createState() => new _ProgressButtonState();
}

class _ProgressButtonState extends State<ProgressButton> with TickerProviderStateMixin {
  ProgressButtonController _controller;
  AnimationController _animationController;
  ButtonState _state = ButtonState.idle;
  @override
  void initState() {
    super.initState();
    _controller = new ProgressButtonController._( this );
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => new Center(
    child: new LayoutBuilder(builder: _progressAnimatedBuilder),
  );

  Widget _buttonChild() {
    if ( _animationController.isAnimating ) return const SizedBox();
    else if ( _animationController.isCompleted ) {
      return new OverflowBox(
        maxWidth: widget.progressIndicatorSize,
        maxHeight: widget.progressIndicatorSize,
        child: CircularProgressIndicator(
          strokeWidth: widget.strokeWidth,
          valueColor: AlwaysStoppedAnimation<Color>(widget.progressIndicatorColor),
        ),
      );
    } else {
      if ( _state == ButtonState.success )
        return widget.successChild;
      else if ( _state == ButtonState.error )
        return widget.errorChild;
      else return widget.child;
    }
  }

  AnimatedBuilder _progressAnimatedBuilder( _, final BoxConstraints constraints) {
    final buttonHeight = constraints.maxHeight != double.infinity ? constraints.maxHeight : 60.0;
    final widthAnimation = new Tween<double>(
      begin: constraints.maxWidth,
      end: buttonHeight,
    ).animate(
      new CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    final borderRadiusAnimation = new Tween<BorderRadius>(
      begin: widget.borderRadius,
      end: new BorderRadius.all( new Radius.circular( buttonHeight / 2.0 ) ),
    ).animate(
      new CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    return new AnimatedBuilder(
      animation: _animationController,
      builder: ( _, child ) => SizedBox(
        height: buttonHeight,
        width: widthAnimation.value,
        child: widget.gradient == null ? RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: borderRadiusAnimation.value,
          ),
          color: widget.color,
          child: new AnimatedSwitcher(
            duration: const Duration( milliseconds: 250, ),
            child: _buttonChild(),
          ),
          onPressed: () {
            if ( _animationController.isDismissed && _state == ButtonState.idle )
              widget.onPressed(_controller);
          },
        ) : new RaisedGradientButton(
          child: new AnimatedSwitcher(
            duration: const Duration( milliseconds: 250, ),
            child: _buttonChild(),
          ),
          gradient: widget.gradient,
          borderRadius: new BorderRadius.only(
            topLeft: borderRadiusAnimation.value.topLeft,
            topRight: borderRadiusAnimation.value.topRight,
            bottomRight: borderRadiusAnimation.value.bottomRight,
            bottomLeft: borderRadiusAnimation.value.bottomLeft,
          ),
          height: buttonHeight,
          width: widthAnimation.value,
          onPressed: () {
            if ( _animationController.isDismissed && _state == ButtonState.idle )
              widget.onPressed(_controller);
          },
        ),
      ),
    );
  }

  Future<void> updateState( final ButtonState state, [ final Duration delayBeforeIdle = const Duration( seconds: 3 ) ] ) async {
    if ( _animationController.isAnimating ) return;
    else if ( _animationController.isCompleted && ( state == ButtonState.success || state == ButtonState.error ) ) {
      await _animationController.reverse();
      if ( mounted ) {
        setState( () => _state = state );
        new Future.delayed(
          delayBeforeIdle,
          () {
            if ( mounted ) setState( () => _state = ButtonState.idle );
          },
        );
      }
    } else if ( mounted && state == ButtonState.loading ) {
      setState( () => _state = state );
      await _animationController.forward();
    }
  }

}
