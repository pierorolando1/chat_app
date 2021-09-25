import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UsuariosServices {

  User? _user = FirebaseAuth.instance.currentUser;

  Future<List> getUsuarios() async {

    try {
      final DocumentSnapshot _documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(_user!.uid).get();

      if(_documentSnapshot.exists){
        final _userData = _documentSnapshot.data();  
          return(_userData as Map)['contacts'];
      } else {
        FirebaseFirestore.instance.collection('users').doc(_user!.uid).set({
          'email': _user!.email,
          'displayName': _user!.displayName,
          'photoUrl': _user!.photoURL,
          'contacts': []
        });
        return [];
      }

    } catch (e) {
      return [];
    }
  }

  Future<List> getAllUsers() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').get();
    return querySnapshot.docs;
  }

}