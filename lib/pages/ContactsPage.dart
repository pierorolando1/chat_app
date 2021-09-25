import 'package:chat_app/helpers.dart';
import 'package:chat_app/pages/AllContactsPage.dart';
import 'package:chat_app/pages/ChatPage.dart';
import 'package:chat_app/pages/LoginPage.dart';
import 'package:chat_app/services/chat.dart';
import 'package:chat_app/widgets/search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/services/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  User? user = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  List<dynamic> contactos = [];

  @override
  void initState() {
    if(this.mounted){
      this._loadUsers();
    }

    super.initState();
  }
  
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 15, right: 5),
        child: InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () { 
            Navigator.of(context).push(
            CupertinoPageRoute(  
              builder: (context) => AllContacts(),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Color.fromRGBO(35, 95, 245, .5),
                  blurRadius: 9,
                ),
              ],
            ),
            child: Container(
              width: 55,
              height: 55,
              child: Icon(Icons.people_alt_outlined),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(100)
              ),
            ),
          ),
        ),
      ),
      endDrawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: CupertinoContextMenu(
                  actions: [
                    CupertinoContextMenuAction(isDestructiveAction: true, onPressed: () => Navigator.pop(context), child: Text("Eliminar foto",style: TextStyle(fontSize: 17),)),
                    CupertinoContextMenuAction(onPressed: () => Navigator.pop(context), child: Text("Cambiar foto",style: TextStyle(fontSize: 17)))
                  ],
                  child: ClipOval(
                    child: Image.network("${ user?.photoURL }",
                    errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                      return Icon(Icons.emoji_people);
                    },
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text("${user!.displayName}", 
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w900
                  ),
                ),
              ),
              CupertinoButton(
                color: Colors.red,
                child: Text("Cerrar sesion"),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(context, CupertinoPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
                }
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        actions: [
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                splashColor: Colors.transparent,
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
                icon: Icon(CupertinoIcons.bars)
              );
            }
          )
        ],
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "Causas",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
        ),
        elevation: 0,
      ),
      body: SmartRefresher(
        onRefresh: _loadUsers,
        controller: _refreshController,
        header: WaterDropMaterialHeader(),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: (contactos.length > 0) ? searchBarWithUsers() : [SearchContactsBar(), Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Center(child: Text("No contacts", textAlign: TextAlign.center, style: TextStyle(color: Colors.white70),),),
          )]
            /*
            (contactos.length > 0) ?
              ...contactos.map( (e) => SearchContactsBar(), ).toList(),
            : Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text("No contacts", textAlign: TextAlign.center, style: TextStyle(color: Colors.white70),),
            ),*/
        ),
      ),
    );
  }

  Widget userCard(User? _user) {
    return ListTile(
      leading: Container(
        margin: EdgeInsets.symmetric(vertical: 3),
        child: CircleAvatar(
          radius: 30.0,
          backgroundImage: NetworkImage(
            '${_user!.photoURL}',
          ),
          backgroundColor: Colors.transparent,
        ),
      ),
      title: Text(
        "${_user.displayName}",
        style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
      ),
      subtitle: Text("${user!.email}",
          style: TextStyle(
            color: Colors.white38,
          )),
    );
  }

  _loadUsers() async {
    if(this.mounted){

      contactos = await UsuariosServices().getUsuarios();
      await Future.delayed(Duration(milliseconds: 500));
      setState(() {});
      _refreshController.refreshCompleted();
    }
  }

  List<Widget> searchBarWithUsers(){
    return [SearchContactsBar(),
            ...this.contactos.map((doc) => InkWell(
          splashColor: Colors.transparent,
          onTap: () {
            Provider.of<ChatService>(context, listen: false).usuarioParaUid = doc["uid"];
            Provider.of<ChatService>(context, listen: false).usuarioParaNombre = doc["displayName"];
            Navigator.push(context, CupertinoPageRoute(
              builder: (BuildContext context) => ChatPage()
            ));
          },
          onLongPress: () => showCupeDialog(context, "Deseas eliminar este contacto?"),
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
            ), ).toList()];
  }

}
