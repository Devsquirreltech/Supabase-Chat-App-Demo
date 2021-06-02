import 'package:flutter/material.dart';

class StyledButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final Color? color;
  final Color? fontColor;
  final bool status;
  final bool isLoading;
  final Widget? leading;

  const StyledButton(this.text,
      {Key? key,
      required this.onPressed,
      this.color,
      this.status = false,
      this.isLoading = false,
      this.fontColor,
      this.leading})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: status ? onPressed : null,
      child: Container(
        width: size.width * 0.85,
        height: size.shortestSide * 0.15,
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(vertical: 6.0),
        decoration: BoxDecoration(
          color: status ? color ?? Theme.of(context).primaryColor : Colors.grey,
          borderRadius: BorderRadius.circular(18.0),
        ),
        child: isLoading
            ? const CircularProgressIndicator()
            : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                leading ?? Container(),
                Text(
                    text,
                    style: TextStyle(
                        color: fontColor != null
                            ? fontColor
                            : Theme.of(context).buttonColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  ),
              ],
            ),
      ),
    );
  }
}
