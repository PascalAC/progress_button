import 'package:flutter/material.dart';

class RaisedGradientButton extends StatelessWidget {
		final Widget child;
		final Gradient gradient;
		final double width;
		final double height;
		final BorderRadius borderRadius;
		final List<BoxShadow> boxShadows;
		final Function onPressed;
		
		const RaisedGradientButton({
				Key key,
				@required this.child,
				this.gradient,
				this.width = double.infinity,
				this.height = 60,
				this.borderRadius,
				this.boxShadows,
				this.onPressed,
		}) : super(key: key);
		
		@override
		Widget build(BuildContext context) {
				return Container(
						width: width,
						height: height,
						decoration: BoxDecoration(
								gradient: gradient,
								borderRadius: borderRadius,
								boxShadow: boxShadows,
						),
						child: Material(
								color: Colors.transparent,
								child: InkWell(
										onTap: onPressed,
										child: Center(
												child: child,
										)),
						),
				);
		}
}