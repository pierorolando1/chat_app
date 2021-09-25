import 'package:chat_app/pages/LoadingPage.dart';
import 'package:chat_app/pages/LoginPage.dart';
import 'package:chat_app/widgets/button.dart';
import 'package:chat_app/widgets/custom_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  void register() async {
    print(emailController.text);
    print(passwordController.text);
    UserCredential user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text
    );
    await user.user!.updateDisplayName(nameController.text);
    await user.user!.updatePhotoURL("https://ui-avatars.com/api/?name=${nameController.text}");
    Navigator.pushReplacement(context, CupertinoPageRoute(builder: (BuildContext context) => LoadingPage()));
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text("CAUSAS", style: TextStyle(color: Color.fromRGBO(13, 245, 227, 0.8), fontSize: 25, fontWeight: FontWeight.w900),),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    CustomInput(
                        placeholder: "Email", textController: emailController,
                        keyboardType: TextInputType.emailAddress,
                    ),
                    CustomInput(
                        placeholder: "Nombre", textController: nameController,
                        keyboardType: TextInputType.emailAddress,
                    ),
                    CustomInput(
                      placeholder: "Contraseña",
                      textController: passwordController,
                      isPassword: true,
                      keyboardType: TextInputType.visiblePassword,
                    ),
                    ButtonAuth(text: "Registrar", onpress: () => register()),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        "Olvidaste tu contraseña?",
                        style: TextStyle(
                            color: Color.fromRGBO(13, 245, 227, 0.8),
                            fontWeight: FontWeight.w300,
                            fontSize: 13),
                      ),
                    )
                  ],
                ),
              ),
            ),
            InkWell(onTap: () => Navigator.push(context, CupertinoPageRoute(builder: (context) => LoginPage()),), child: Text("Ya tienes cuenta?", style: TextStyle(color: Color.fromRGBO(13, 245, 227, 0.8), fontWeight: FontWeight.w700,),))
          ],
        ),
      ),
    );
  }
}
