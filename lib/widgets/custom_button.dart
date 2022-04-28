import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final GestureTapCallback onTap;
  final double width;
  const CustomButton({
    Key? key,
    required this.buttonText,
    required this.onTap,
    this.width = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: width,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xff3e3f99),
                  Color(0xff5c60c3),
                ]),
          ),
          child: Text(
            buttonText,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
