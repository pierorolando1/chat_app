import 'package:chat_app/widgets/message_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/services/chat.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {

  List<ChatMessage> _messages = [];
  TextEditingController _messageController = TextEditingController();
  final _focusNode = new FocusNode();

  @override
  Widget build(BuildContext context) {
    final usuarioPara = Provider.of<ChatService>(context);
    return Scaffold(
      appBar: AppBar( 
        centerTitle: true,
        title: Text( (usuarioPara.usuarioParaNombre == null) ? "No name" : usuarioPara.usuarioParaNombre.toString(), style: TextStyle(
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
        stream: FirebaseFirestore.instance.collection('messages').orderBy("date") .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if(snapshot.hasData){
            if(snapshot.data?.docs.length > 0){
              final List _lista = snapshot.data?.docs.where((m) => ( m["fromUid"] == FirebaseAuth.instance.currentUser!.uid && m["toUid"] == Provider.of<ChatService>(context,listen: false).usuarioParaUid) || (m["fromUid"] == Provider.of<ChatService>(context,listen: false).usuarioParaUid && m["toUid"] == FirebaseAuth.instance.currentUser!.uid)  ).toList();

              final _listaChatMessage = _lista.map<ChatMessage>((e) => ChatMessage(
                messageId: e.id,
                  texto: e["texto"],
                  fromUid: e["fromUid"],
                  animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 0))..forward()
                )
              ).toList();

              _messages = _listaChatMessage;

            }
          }

          return Container(
            child: Column(
              children: [
                Flexible(
                  child: ListView(
                    padding: EdgeInsets.only(top: 8),
                    physics: BouncingScrollPhysics(),
                    children: _messages.map((e) => e).toList()
                      /*ChatMessage(texto: "Hola", fromUid: "", animationController: new AnimationController(
                        vsync: this, duration: Duration(milliseconds: 0))
                        ..forward()),*/
                  )
                ),
                Divider(height: 1, color: Colors.transparent,),
                Container(
                  child: _inputChat(),
                )
              ],
            ),
          );
        }
      ),
    );
  }


  Widget _inputChat() {
    return SafeArea(
      child: Container(
      padding: EdgeInsets.only(left: 16),
      margin: EdgeInsets.only(bottom: 12, top: 8, left: 10, right: 10), //(horizontal: 10.0, vertical: 12),
      decoration: BoxDecoration(
        color: Color.fromRGBO(17, 24, 39, 1),
        borderRadius: BorderRadius.circular(20)
      ),
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextField(
              controller: _messageController,
              onSubmitted: _handleSubmited,
              onChanged: (texto) {},
              style: TextStyle(color: Colors.white70),
              decoration: InputDecoration.collapsed(hintText: 'Enviar mensaje', hintStyle: TextStyle(color: Colors.white30)),
              focusNode: _focusNode,
            )
          ),

          // Botón de enviar
          Container(
            child: CupertinoButton(
              child: Text('Enviar'),
              onPressed: _handleSend,
            )
          )
        ],
      ),
    ));
  }

  _handleSend()async{
    String _texto = _messageController.text;

    if (_texto.length == 0) return;
    
    final _message = await FirebaseFirestore.instance.collection("messages").add({
      "texto": _texto, 
      "fromUid": FirebaseAuth.instance.currentUser!.uid, 
      "toUid": Provider.of<ChatService>(context,listen: false).usuarioParaUid,
      "date": DateTime.now().toUtc()
    });
    _messageController.clear();
    _focusNode.requestFocus();
    final newMessage = new ChatMessage(
      messageId: _message.id,
      fromUid: FirebaseAuth.instance.currentUser!.uid,
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 200)),
      texto: _texto,
    );

    //_messages.insert(0, newMessage);
    newMessage.animationController.forward();
    setState(() {});


  }

  _handleSubmited(String texto)async{
    if (texto.length == 0) return;
    
    _focusNode.requestFocus();

    final _message = await FirebaseFirestore.instance.collection("messages").add({ 
      "texto": texto, 
      "fromUid": FirebaseAuth.instance.currentUser!.uid, 
      "toUid": Provider.of<ChatService>(context,listen: false).usuarioParaUid, 
      "date": DateTime.now().toUtc()
    });

    final newMessage = new ChatMessage(
      messageId: _message.id,
       fromUid: FirebaseAuth.instance.currentUser!.uid,
       animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 200)),
       texto: texto,  
    );

    //_messages.insert(0, newMessage);
    _messageController.clear();
    newMessage.animationController.forward();
        setState(() {
        });

  }

}
