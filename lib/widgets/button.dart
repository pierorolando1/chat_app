import 'package:flutter/material.dart';

class ButtonAuth extends StatelessWidget {
  
  final String text;
  final onpress;
  ButtonAuth({Key? key, required this.text, this.onpress}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: double.infinity,
      onPressed: onpress,
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      color: Color.fromRGBO(13, 245, 227, 1), 
      splashColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      child: Text(text,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
    );
  }
}