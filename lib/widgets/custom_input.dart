import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final String placeholder;
  final TextEditingController textController;
  final TextInputType keyboardType;
  final bool isPassword;

  const CustomInput(
      {Key? key,
      required this.placeholder,
      required this.textController,
      this.keyboardType = TextInputType.text,
      this.isPassword = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5, left: 25, bottom: 5, right: 20),
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 0.08) ,
          borderRadius: BorderRadius.circular(30),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: Offset(0, 5),
              blurRadius: 5
            ),
          ],
        ),
      child: TextField(
        style: TextStyle(color: Colors.white70),
        controller: this.textController,
        autocorrect: false,
        keyboardType: this.keyboardType,
        obscureText: this.isPassword,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: Colors.white38),
            focusedBorder: InputBorder.none,
            border: InputBorder.none,
            hintText: this.placeholder
          ),
      ),
    );
  }
}
