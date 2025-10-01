import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final VoidCallback press;
  final Color color, textColor;
  final double widthFactor;
  final double borderRadius;

  const RoundedButton({
    Key? key,
    required this.text,
    required this.press,
    this.color = AppColors.primary,
    this.textColor = Colors.white,
    this.widthFactor = 0.8,
    this.borderRadius = 12.0, // Slightly rounded corners based on image
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: size.width * widthFactor,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 40),
            backgroundColor: color,
          ),
          onPressed: press,
          child: Text(
            text,
            style: AppStyles.button.copyWith(color: textColor),
          ),
        ),
      ),
    );
  }
}

