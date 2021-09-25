import 'package:chat_app/pages/ChatPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UsersSeach extends SearchDelegate {

  User? user = FirebaseAuth.instance.currentUser;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(onPressed: () => this.query = '', icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      splashColor: Colors.transparent,
      onPressed: () => this.close(context, null),
      icon: Icon(Icons.arrow_back_ios, size: 15)
    );
  }

  @override
  Widget buildResults(BuildContext context) {

    if ( this.query.isEmpty ) {
      return Container();
    }

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();

        return ListView(children: getAllUsersWhere(snapshot, this.query.trim().toLowerCase()),);

      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').orderBy("displayName").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (!snapshot.hasData)return Center(child: CircularProgressIndicator());

        return ListView(
          physics: BouncingScrollPhysics(),
          children: getAllUsers(snapshot, context)
        );
      },
    );
  }

  @override
  String get searchFieldLabel => 'Buscar Contactos...';

  @override
  TextStyle get searchFieldStyle => TextStyle(
    color: Colors.white,
    fontSize: 10.0,
  );

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
        scaffoldBackgroundColor: Color.fromRGBO(17, 24, 39, 1),
        textTheme: TextTheme(
          title: TextStyle(color: Colors.white),
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(fontSize: 17, color: Colors.white30),
        ),
        appBarTheme: AppBarTheme(
          color: Color.fromRGBO(17, 24, 39, 1),
        ));
  }



getAllUsers(AsyncSnapshot snapshot, context) {

  final List _arrayToMap = snapshot.data?.docs.where((doc) => doc["email"].toString() != user!.email ).toList();

  return _arrayToMap
      .map<Widget>((doc) => InkWell(
        splashColor: Colors.transparent,
        onTap: () => Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => ChatPage())),
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
                style:
                    TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(doc["email"],
                  style: TextStyle(
                    color: Colors.white38,
                  )),
            ),
      ))
      .toList();
}

getAllUsersWhere(AsyncSnapshot snapshot, String query) {

  final List _arrayToMap1 = snapshot.data?.docs.where((doc) => doc["displayName"].toString().toLowerCase().contains(query) ).toList();
  final List _arrayToMap = _arrayToMap1.where((doc) => doc["email"].toString() != user!.email ).toList();
  return _arrayToMap.map<Widget>((doc) => ListTile(
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
              style:
                  TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(doc["email"],
                style: TextStyle(
                  color: Colors.white38,
                )),
          ))
      .toList();
}

}