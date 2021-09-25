// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario {
    Usuario({
        required this.contacts,
        required this.displayName,
        required this.email,
        required this.photoUrl,
    });

    List<dynamic> contacts;
    String displayName;
    String email;
    String photoUrl;

    factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        contacts: List<dynamic>.from(json["contacts"].map((x) => x)),
        displayName: json["displayName"],
        email: json["email"],
        photoUrl: json["photoUrl"],
    );

    Map<String, dynamic> toJson() => {
        "contacts": List<dynamic>.from(contacts.map((x) => x)),
        "displayName": displayName,
        "email": email,
        "photoUrl": photoUrl,
    };
}
