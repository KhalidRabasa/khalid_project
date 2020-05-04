import 'package:flutter/material.dart';

class MyGradientButton extends StatelessWidget {
  final Widget child;
  final double height;
  final Gradient gradient;
  final Function onPressed;
  final double width;
  final double radius;
  const MyGradientButton(
      {Key key,
      @required this.child,
      this.width = 150,
      this.gradient,
      this.height = 50.0,
      this.onPressed,
      this.radius = 15})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 50.0,
      decoration: BoxDecoration(
          gradient: gradient,
          boxShadow: [
            BoxShadow(
              color: Colors.grey[500],
              offset: Offset(0.0, 1.5),
              blurRadius: 1.5,
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(radius))),
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
