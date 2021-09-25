import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';

showCupeDialog(BuildContext context, String title) {
  CupertinoAlertDialog alert = CupertinoAlertDialog(
    title: Text(title),
    actions: [
      CupertinoDialogAction(
        child: Text('OK'),
        onPressed: () {
          print("ok");
          Navigator.pop(context);
        },
      ),
      CupertinoDialogAction(
        isDestructiveAction: true,
        child: Text('Cancel'),
        onPressed: () {
          print("cancel");
          Navigator.pop(context);
        },
      ),
    ],
  );

  return showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showCupeModalPopup(BuildContext context, String messageId) {
  
  print(messageId);
  CupertinoActionSheet _alert = CupertinoActionSheet(
    title: Text("El mensaje sera eliminado para ambos contactos"),
    actions: [
      CupertinoActionSheetAction(
        isDestructiveAction: true,
        onPressed: () async {
          await FirebaseFirestore.instance.collection("messages").doc(messageId).delete();
          Navigator.pop(context);
        },
        child: Text("Eliminar mensaje",style: TextStyle(fontSize: 16),)
      )
    ],
    cancelButton: CupertinoActionSheetAction(
      onPressed: () => Navigator.pop(context), child: Text("Cancel"),
      isDestructiveAction: true,
    ),
  );
  return showCupertinoModalPopup(context: context, builder: (BuildContext context) => _alert );
}