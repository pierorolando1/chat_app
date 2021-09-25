import 'package:chat_app/pages/LoadingPage.dart';
import 'package:chat_app/pages/RegisterPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/widgets/GoogleButton.dart';
import 'package:chat_app/widgets/button.dart';
import 'package:chat_app/widgets/custom_input.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  void login() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text
    );
    Navigator.pushReplacement(context, CupertinoPageRoute(builder: (BuildContext context) => LoadingPage()));

  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              "CAUSAS",
              style: TextStyle(
                  color: Color.fromRGBO(13, 245, 227, 0.8),
                  fontSize: 25,
                  fontWeight: FontWeight.w900),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  CustomInput(
                    placeholder: "Email",
                    textController: emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  CustomInput(
                    placeholder: "Contraseña",
                    textController: passwordController,
                    isPassword: true,
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  ButtonAuth(text: "Ingresar", onpress: () => login()),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: GoogleButton(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Text(
                      "Olvidaste tu contraseña?",
                      style: TextStyle(
                          color: Color.fromRGBO(13, 245, 227, 0.8),
                          fontWeight: FontWeight.w300,
                          fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
                onTap: () => Navigator.push(context, CupertinoPageRoute(builder: (context) => RegisterPage(),),),
                child: Text(
                  "No tienes cuenta?",
                  style: TextStyle(
                    color: Color.fromRGBO(13, 245, 227, 0.8),
                    fontWeight: FontWeight.w700,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
