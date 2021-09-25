import 'package:chat_app/pages/ChatPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class AllContacts extends StatefulWidget {
  const AllContacts({Key? key}) : super(key: key);

  @override
  _AllContactsState createState() => _AllContactsState();
}

class _AllContactsState extends State<AllContacts> {
  
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Agrega o busca contactos", style: TextStyle(
          fontSize: 15
        ),),
        leading: IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.black12,
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios), iconSize: 15,),
        backgroundColor: Color.fromRGBO(17, 24, 39, 1),
        shadowColor: Color.fromRGBO(17, 24, 39, 1),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').orderBy('displayName').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();

          return ListView(children: getAllUsers(snapshot));
        },
      ),
    );
  }

  getAllUsers(AsyncSnapshot snapshot) {
    List _arrayToMap =  snapshot.data?.docs.where((doc) => doc["email"].toString() != user!.email ).toList();
    return _arrayToMap
        .map<Widget>((doc) => InkWell(
          splashColor: Colors.transparent,
          onTap: () async {
            print(doc.id);
            await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
              "contacts": FieldValue.arrayUnion([{"uid": doc.id, "displayName": doc["displayName"], "email": doc["email"], "photoUrl": doc["photoUrl"]}])
            });
            Navigator.push(context, CupertinoPageRoute(
              builder: (BuildContext context) => ChatPage()
            ));
          },
          child: ListTile(
                leading: Container(
                  margin: EdgeInsets.symmetric(vertical: 3),
                  child: CircleAvatar(
                    radius: 30.0,
                    backgroundImage: NetworkImage(
                      doc["photoUrl"],
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                ),
                title: Text(
                  doc["displayName"],
                  style: TextStyle(
                      color: Colors.white70, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(doc["email"],
                    style: TextStyle(
                      color: Colors.white38,
                    )),
              ),
            )
        )
        .toList();
  }
}
