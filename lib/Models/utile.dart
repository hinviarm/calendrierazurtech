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

    final prefs = await SharedPreferences.getInstance();
    String? encodedList = prefs.getString('maListe');
List<dynamic> listeTaches = [];
    if (encodedList != null) {
      List<dynamic> decodedList = convert.jsonDecode(encodedList);
listeTaches = List<String>.from(decodedList);
    }

  for(var ligne in listeTaches) {
    var urlStringPost = 'https://example.com/api/todo';
    var urlPost = Uri.parse(urlStringPost);
    var response = await http.post(
      urlPost,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: convert.jsonEncode(<String, dynamic>{
        'titre': ligne[0],
        'description': ligne[1],
        'heure_deb': ligne[2],
        'heure_fin': ligne[3],
        'notification': ligne[4],
        'date': ligne[5]
      }),
    );
  }
}



Future<void> saveList(List<dynamic> list) async {
  final prefs = await SharedPreferences.getInstance();
  String encodedList = convert.jsonEncode(list);
  await prefs.setString('maListe', encodedList);
}