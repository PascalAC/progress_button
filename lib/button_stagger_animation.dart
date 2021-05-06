import 'package:flutter/material.dart';

class ButtonStaggerAnimation extends StatelessWidget {
  // Animation fields
  final AnimationController controller;

  // Display fields
  final Color color;
  final Color progressIndicatorColor;
  final double progressIndicatorSize;
  final BorderRadius borderRadius;
  final double strokeWidth;
  final Function(AnimationController)? onPressed;
  final Widget child;
  final bool outlined;
  final double height;

  ButtonStaggerAnimation({
    Key? key,
    required this.controller,
    required this.color,
    required this.progressIndicatorColor,
    required this.progressIndicatorSize,
    required this.borderRadius,
    required this.onPressed,
    required this.strokeWidth,
    required this.child,
    required this.outlined,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: _progressAnimatedBuilder);
  }

  Widget _buttonChild() {
    if (controller.isAnimating) {
      return Container();
    } else if (controller.isCompleted) {
      return OverflowBox(
        maxWidth: progressIndicatorSize,
        maxHeight: progressIndicatorSize,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
          valueColor: AlwaysStoppedAnimation<Color>(progressIndicatorColor),
        ),
      );
    }
    return child;
  }

  AnimatedBuilder _progressAnimatedBuilder(
      BuildContext context, BoxConstraints constraints) {
    var buttonHeight = (constraints.maxHeight != double.infinity)
        ? constraints.maxHeight
        : height;

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
          child: outlined
              ? OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    primary: color,
                    shape: RoundedRectangleBorder(
                      borderRadius: borderRadiusAnimation.value,
                    ),
                  ),
                  onPressed: onPressed != null
                      ? () {
                          onPressed!(controller);
                        }
                      : null,
                  child: _buttonChild(),
                )
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: color,
                    shape: RoundedRectangleBorder(
                      borderRadius: borderRadiusAnimation.value,
                    ),
                  ),
                  onPressed: onPressed != null
                      ? () {
                          onPressed!(controller);
                        }
                      : null,
                  child: _buttonChild(),
                ),
        );
      },
    );
  }
}
