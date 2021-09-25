import 'package:chat_app/pages/AllContactsPage.dart';
import 'package:chat_app/services/chat.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/pages/ContactsPage.dart';
import 'package:chat_app/pages/LoadingPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:chat_app/pages/LoginPage.dart';
import 'package:chat_app/pages/RegisterPage.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
  ));
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ( _ ) => ChatService()),
      ],
      child: FutureBuilder(
        future: _initialization,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.hasError) return Text("Algo salió mal");
    
          if(snapshot.connectionState == ConnectionState.done){
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                //13, 245, 227
                brightness: Brightness.dark,
                canvasColor: Color.fromRGBO(17, 24, 39, 1),
                primaryColor: Color.fromRGBO(35, 95, 245, 1),
                scaffoldBackgroundColor: Color.fromRGBO(24, 33, 47, 1),
                appBarTheme: AppBarTheme(
                  textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme).apply(bodyColor: Colors.white)
                ),
                textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
              ),
              initialRoute: '/',
              routes: {
                "/": ( _ ) => LoadingPage(),
                "/allcontacts": ( _ ) => AllContacts(),
                "/login": ( _ ) => LoginPage(),
                "/register": ( _ ) => RegisterPage(),
                "/contacts": ( _ ) => ContactsPage(),
              },
            );
          }
    
          return CircularProgressIndicator();
        }
      ),
    );
  }
}



