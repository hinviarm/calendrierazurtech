import 'dart:convert';

class Tache {
  final String titre;
  final String description;
  final int heure_deb;
  final int heure_fin;
  final DateTime date;
  final bool notification;
  const Tache({required this.titre, required this.description, required this.heure_deb, required this.heure_fin, required this.date, required this.notification});

  String myEncode(dynamic item) {
      return item.toIso8601String();
  }
  // Convertit un objet en Map (pour JSON)
  Map<String, dynamic> toJson() {
    return {
      'titre': titre,
      'description': description,
      'heure_deb': heure_deb,
      'heure_fin': heure_fin,
      'notification': notification,
      'date': json.encode(date, toEncodable: myEncode)
    };
  }

  // Crée un objet à partir d'une Map (JSON)
  factory Tache.fromJson(Map<String, dynamic> json) {
    return Tache(
          titre: json['titre'],
          description: json['description'],
          heure_deb: json['heure_deb'],
          heure_fin: json['heure_fin'],
          notification: json['notification'],
          date: DateTime.parse(json['date'].toString().split("T").first.split('"').last.trim())
      );
  }

}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
        (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}