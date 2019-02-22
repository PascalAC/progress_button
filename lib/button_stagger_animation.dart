import 'package:flutter/material.dart';

class ButtonStaggerAnimation extends StatelessWidget {
  // Animation fields
  final AnimationController controller;
  final Animation<double> widthAnimation;
  final Animation<BorderRadius> borderRadiusAnimation;

  // Display fields
  final double height;
  final double width;
  final Color color;
  final Color progressIndicatorColor;
  final double progressIndicatorSize;
  final BorderRadius borderRadius;
  final Function(AnimationController) onPressed;
  final Widget child;

  ButtonStaggerAnimation({
    Key key,
    this.controller,
    this.height,
    this.width,
    this.color,
    this.progressIndicatorColor,
    this.progressIndicatorSize,
    this.borderRadius,
    this.onPressed,
    this.child,
  })  : widthAnimation = Tween<double>(
          begin: width,
          end: height,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Curves.easeInOut,
          ),
        ),
        borderRadiusAnimation = Tween<BorderRadius>(
          begin: borderRadius,
          end: const BorderRadius.all(Radius.circular(30)),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Curves.easeInOut,
          ),
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget child) {
        return Container(
          width: widthAnimation.value,
          height: height,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: borderRadiusAnimation.value,
            ),
            color: color,
            child: buttonChild(),
            onPressed: () {
              this.onPressed(controller);
            },
          ),
        );
      },
    );
  }

  Widget buttonChild() {
    if (controller.isAnimating) {
      return Container();
    } else if (controller.isCompleted) {
      return SizedBox(
        width: progressIndicatorSize,
        height: progressIndicatorSize,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(progressIndicatorColor),
        ),
      );
    }
    return child;
  }
}
