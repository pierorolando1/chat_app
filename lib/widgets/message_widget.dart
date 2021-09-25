import 'package:chat_app/helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



class ChatMessage extends StatelessWidget {

  final String texto;
  final String fromUid;
  final String messageId;
  final AnimationController animationController;

  const ChatMessage({
    Key? key, 
    required this.texto,
    required this.messageId,
    required this.fromUid, 
    required this.animationController
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {

    //TODO final authService = Provider.of<AuthService>(context, listen: false);
    User? user = FirebaseAuth.instance.currentUser;
    
    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(parent: animationController, curve: Curves.easeOut ),
        child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onLongPress: () => showCupeModalPopup(context, this.messageId),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 02),
            child: this.fromUid == user!.uid
            ? _myMessage(context)
            : _notMyMessage(),
          ),
        ),
      ),
    );
  }

  Widget _myMessage(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.only(
          right: 10,
          bottom: 5,
          left: 50
        ),
        child: Text( this.texto, style: TextStyle( color: Colors.white ), ),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(13),
          boxShadow: [
            BoxShadow(color: Color.fromRGBO(35, 95, 245, 0.6), blurRadius: 5, offset: Offset(1, 1))
          ]
        ),
      ),
    );
  }


  Widget _notMyMessage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.only(
          left: 10,
          bottom: 5,
          right: 50
        ),
        child: Text( this.texto, style: TextStyle( color: Colors.white ), ),
        decoration: BoxDecoration(
          color: Color.fromRGBO(51, 65, 85, 1),
          borderRadius: BorderRadius.circular(13),
          boxShadow: [
            BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.4), blurRadius: 6, offset: Offset(-1, 1))
          ]
        ),
      ),
    );
  }
}