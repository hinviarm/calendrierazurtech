class Tache {
  final String titre;
  final String description;
  final int heure_deb;
  final int heure_fin;
  final DateTime date;
  final bool notification;
  const Tache({required this.titre, required this.description, required this.heure_deb, required this.heure_fin, required this.date, required this.notification});
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
        (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}