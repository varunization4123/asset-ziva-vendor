import 'package:asset_ziva_vendor/utils/colors.dart';
import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final Widget widget;
  final VoidCallback onPressed;

  const LoginButton({super.key, required this.widget, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(backgroundColor),
        backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
      ),
      child: widget,
    );
  }
}
