import 'package:flutter/material.dart';

class StyledTextField extends StatelessWidget {
  final String hintText;
  final TextAlign textAlign;
  final Function(String)? onChanged;
  final String? errorText;
  final Widget? trailing;
  final bool isObscure;

  const StyledTextField(
      {Key? key,
      required this.hintText,
      this.textAlign = TextAlign.start,
      this.onChanged,
      this.errorText, this.trailing, this.isObscure = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.85,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: TextField(
        textInputAction: TextInputAction.next,
        textAlign: textAlign,
        onChanged: onChanged,
        obscureText: isObscure,
        decoration: InputDecoration(
          suffixIcon: trailing,
          hintText: hintText,
          errorText: errorText,
          border: InputBorder.none,
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
