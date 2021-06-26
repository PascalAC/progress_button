import 'package:flutter/material.dart';

class ButtonStaggerAnimation extends StatelessWidget {
  // Animation fields
  final  controller;

  // Display fields
  final Color? color;
  final Color? progressIndicatorColor;
  final double? progressIndicatorSize;
  final BorderRadius? borderRadius;
  final double strokeWidth;
  final Function(AnimationController)? onPressed;
  final Widget? child;

  ButtonStaggerAnimation({
    Key? key,
    this.controller,
    this.color,
    this.progressIndicatorColor,
    this.progressIndicatorSize,
    this.borderRadius,
    this.onPressed,
    this.strokeWidth = 0.0,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: _progressAnimatedBuilder);
  }

  Widget? _buttonChild() {
    if (controller!.isAnimating) {
      return Container();
    } else if (controller!.isCompleted) {
      return OverflowBox(
        maxWidth: progressIndicatorSize,
        maxHeight: progressIndicatorSize,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
          valueColor: AlwaysStoppedAnimation<Color>(progressIndicatorColor!),
        ),
      );
    }
    return child;
  }

  AnimatedBuilder _progressAnimatedBuilder(
      BuildContext context, BoxConstraints constraints) {
    var buttonHeight = (constraints.maxHeight != double.infinity)
        ? constraints.maxHeight
        : 60.0;

    var widthAnimation = Tween<double>(
      begin: constraints.maxWidth,
      end: buttonHeight,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );

    var borderRadiusAnimation = Tween<BorderRadius>(
      begin: borderRadius,
      end: BorderRadius.all(Radius.circular(buttonHeight / 2.0)),
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ));

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return SizedBox(
          height: buttonHeight,
          width: widthAnimation.value,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: borderRadiusAnimation.value,
            ),
            color: color,
            child: _buttonChild(),
            onPressed: () {
              this.onPressed!(controller);
            },
          ),
        );
      },
    );
  }
}
