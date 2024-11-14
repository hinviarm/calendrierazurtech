import 'package:crypt/crypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../Models/utile.dart';

class Profil extends StatefulWidget {
  Profil({Key? key})
      : super(key: key);

  @override
  State<Profil> createState() => _MonProfil();
}

class _MonProfil extends State<Profil> {
  Duration get loginTime => Duration(milliseconds: 2250);
  bool connect = false;

  void insertion(String nom, String password) async {
    var urlStringPost = 'https://example.com/api/signup';
    var urlPost = Uri.parse(urlStringPost);
    var response = await http.post(
      urlPost,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: convert.jsonEncode(<String, String>{
        'nom': nom,
        'MDP': password,
      }),
    );
  }

  void session(String nom, String password)async{
    var urlString = 'https://example.com/api/login?nom=${nom}&MDP=${password}';
    var url = Uri.parse(urlString);
    var reponse = await http.get(url);
    if (reponse.statusCode == 200){
      connect = true;
     // TODO Connecté
    }
  }

  Future<String?> _authUser(LoginData data) {
    return Future.delayed(loginTime).then((_) {
      if (!connect) {
        return 'Identifiants ou Mot de passe incorrect';
      }
      return null;
    });
  }

  Future<String?> _signupUser(SignupData data) {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    final c1 = Crypt.sha256(data.password!);
    insertion(data.name!, data.password!);
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  void emailing(String name) async {
    //todo
  }

  Future<String> _recoverPassword(String nom) {
    debugPrint('nom: $nom');
    emailing(nom);
    return Future.delayed(loginTime).then((_) {
      return 'Bonjour';
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
            logo: 'images/azurtech.png',
            onLogin: _authUser,
            onSignup: _signupUser,
            theme: LoginTheme(
              pageColorLight: Colors.transparent,
              pageColorDark: Colors.transparent,
            ),
            onSubmitAnimationCompleted: () {
              //todo à faire si connecté
              postTacheEnLigne();

            },
            onRecoverPassword: _recoverPassword,
          );
  }
}

class User {
  final String? nom;
  final String? password;

  User({this.nom, this.password});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> user = Map<String, dynamic>();
    user["nom"] = nom;
    user["password"] = password;
    return user;
  }
}
