import 'dart:async';
import 'dart:convert';
import 'package:calendrierazurtech/Controleurs/tache.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';

class EstPasUneHeureValide implements Exception {
  String messageErreur = "Tu ne peux pas entrer un nombre négatif";
}

void verificationHeure(int n) {
  if (n < 0 || n > 24) {
    //Si il l'est, on lève l'exception depuis notre classe de gestion d'exception via notre mot-clé throw
    throw EstPasUneHeureValide();
  }
}
void verificationHeureBool(bool mauvaiseHeure) {
  if (mauvaiseHeure == true) {
    //Si il l'est, on lève l'exception depuis notre classe de gestion d'exception via notre mot-clé throw
    throw EstPasUneHeureValide();
  }
}

void postTacheEnLigne() async{

  List<Tache> listeTaches =  await recupliste();
  for(var ligne in listeTaches) {
    var urlStringPost = 'https://example.com/api/todo';
    var urlPost = Uri.parse(urlStringPost);
    var response = await http.post(
      urlPost,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: convert.jsonEncode(<String, dynamic>{
        'titre': ligne.titre,
        'description': ligne.description,
        'heure_deb': ligne.heure_deb,
        'heure_fin': ligne.heure_fin,
        'notification': ligne.notification,
        'date': ligne.date
      }),
    );
  }
}


// Sauvegarde une liste d'objets
Future<void> saveList(List<Tache> taches) async {
final SharedPreferences prefs = await SharedPreferences.getInstance();

// Convertit chaque utilisateur en JSON
List<String> jsonStringList = taches.map((user) => jsonEncode(user.toJson())).toList();

// Stocke la liste en session
await prefs.setStringList('maListe', jsonStringList);
}

// Récupère une liste d'objets
Future<List<Tache>> recupliste() async {
final SharedPreferences prefs = await SharedPreferences.getInstance();

// Récupère la liste JSON
List<String>? jsonStringList = prefs.getStringList('maListe');

if (jsonStringList == null) return []; // Retourne une liste vide si rien n'est stocké

// Convertit chaque chaîne JSON en objet Tache
return jsonStringList.map((jsonString) => Tache.fromJson(jsonDecode(jsonString))).toList();
}