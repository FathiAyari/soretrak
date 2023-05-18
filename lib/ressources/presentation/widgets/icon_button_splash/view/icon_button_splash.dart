import 'package:flutter/material.dart';
import 'package:soretrak/ressources/dimensions/constants.dart';

class IconButtonSplash extends StatelessWidget {
  final Color splashColor;
  final Color bgColor;
  final Widget icon;
  final VoidCallback? onPressed;
  const IconButtonSplash({super.key, required this.icon, required this.splashColor, this.onPressed, required this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(10),
      child: IconButton(
          splashColor: splashColor,
          splashRadius: Constants.screenHeight * 0.03,
          onPressed: () => onPressed != null ? onPressed!() : Navigator.pop(context),
          icon: icon),
    );
  }
}
