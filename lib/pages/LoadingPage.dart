import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoadingPage extends StatefulWidget {
  LoadingPage({Key? key}) : super(key: key);

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, AsyncSnapshot<User?> snapshot) {
        if(snapshot.hasData){
          
          print(snapshot.data);
          Future.delayed(Duration(seconds: 1), () async {
            Navigator.pushReplacementNamed(context, '/contacts');
          });
        } else if(snapshot.data?.email == null) {
            Future.delayed(Duration(seconds: 1), () async { 
              Navigator.pushReplacementNamed(context, '/login');
            }
          );
        }

        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(color: Colors.blueGrey, strokeWidth: 1,),
          ),
        );
      }
    );
  }

}