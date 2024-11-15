import 'package:calendrierazurtech/Models/utile.dart';
import 'package:calendrierazurtech/Vues/profil.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:switcher_button/switcher_button.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../Controleurs/tache.dart';
import 'dart:convert' as convert;

class Calendrier extends StatefulWidget {
  const Calendrier({super.key});

  @override
  State<Calendrier> createState() => _MonCalendrier();
}

class _MonCalendrier extends State<Calendrier> {

  late final ValueNotifier<List<Tache>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  Map<DateTime, List<Tache>> events = {};
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  bool mauvaiseHeure = false;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    //loadPreviousEvents();
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

//*GET EVENTS PER DAY
  List<Tache> _getEventsForDay(DateTime day) {
      return events[day] ??
      listeToutesTaches.where((list) => ( list.date.year == day.year && list.date.month == day.month && list.date.day == day.day)).toList();
  }

  List<Tache> listeToutesTaches = [];
  
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });
      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                child: Text(
                  textAlign: TextAlign.center,
                  DateFormat('MMMM yyyy').format(_selectedDay!),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TableCalendar(
                headerStyle: HeaderStyle(
                    formatButtonDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(),
                        color: Theme.of(context).colorScheme.tertiaryContainer),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onInverseSurface)),
                firstDay: DateTime.utc(2000, 12, 31),
                lastDay: DateTime.utc(2030, 01, 01),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                rangeStartDay: _rangeStart,
                rangeEndDay: _rangeEnd,
                calendarFormat: _calendarFormat,
                rangeSelectionMode: _rangeSelectionMode,
                eventLoader: _getEventsForDay,
                startingDayOfWeek: StartingDayOfWeek.monday,
                calendarStyle: CalendarStyle(
                  markerDecoration: BoxDecoration(
                      border: Border.all(
                          color:
                          Theme.of(context).colorScheme.secondaryContainer),
                      color: Theme.of(context).colorScheme.primary),
                  selectedDecoration: BoxDecoration(
                      image: const DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('images/ok.png')),
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.onTertiaryContainer),
                  todayDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.onTertiaryContainer),
                  // Use `CalendarStyle` to customize the UI
                  outsideDaysVisible: false,
                ),
                onDaySelected: _onDaySelected,
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
                // Ici, vous pouvez personnaliser l'apparence et le comportement du calendrier selon vos besoins
              ),
              const SizedBox(height: 10.0),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onInverseSurface),
                child: ValueListenableBuilder(
                  builder: (context, value, _) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: value
                          .map((e) => Card(
                          color: Colors.white,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 14),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4)),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [

                                    SizedBox(
                                      child: Column(
                                        children: [
                                          SizedBox(
                                              child: Column(
                                                  children: [
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.all(8.0),
                                                  child:
                                                    Column(
                                                          children: [
                                                        Text(
                                                          "Titre: "+e.titre
                                                        ),
                                                        Text(
                                                           "Description: " +e.description
                                                        ),
                                                        Text(
                                                          "Heure de début: "+e.heure_deb.toString()
                                                        ),
                                                        Text(
                                                          "Heure de fin: "+e.heure_fin.toString()
                                                        ),
                                                        Text(
                                                          "Date: " +DateFormat('dd/MM/yyyy').format(e.date).toString()
                                                        ),
                                                        Text(
                                                          "Notification: "+e.notification.toString()
                                                        ),
                                                      ],
                                                    ),

                                                )
                                              ])),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )))
                          .toList(),
                    );

                  },
                  valueListenable: _selectedEvents,
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async{
            // todo: Show dialog to user to input event
            try {
              await showDialog(
                  context: context, builder: (_) => _dialogWidget(context));
              verificationHeureBool(mauvaiseHeure);
            } catch (e){
mauvaiseHeure = false;
              Alert(
                context: context,
                type: AlertType.error,
                title: "Désolé !",
                desc:
                "Vous n'avez pas entré une heure valide. Elle doit être comprise entre 0 et 24",
                buttons: [
                  DialogButton(
                    child: Text(
                      "Fermer",
                      style: TextStyle(
                          color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () => Navigator.pop(context),
                    width: 120,
                  )
                ],
              ).show();
            }
          },
          label: const Text('Ajout de tache'),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }
  final _titreController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _heure_debController = TextEditingController();
  final _heure_finController = TextEditingController();
  late bool recupereNotification = false;
  void clearController() {
    _titreController.clear();
    _descriptionController.clear();
    _heure_debController.clear();
    _heure_finController.clear();
  }
  AlertDialog _dialogWidget(BuildContext context) {
    return AlertDialog.adaptive(
      scrollable: true,
      title: const Text('Ajout de Tache'),
      content: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            TextField(
              controller: _titreController,
              decoration: const InputDecoration(helperText: 'Titre'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(helperText: 'Description'),
            ),
            TextField(
              controller: _heure_debController,
              decoration: const InputDecoration(helperText: 'heure de début'),
            ),
            TextField(
              controller: _heure_finController,
              decoration: const InputDecoration(helperText: 'heure de fin'),
            ),
        Column(
          children: [
            SwitcherButton(
              value: false,
              onChange: (value) {
                recupereNotification = value;
              },),
              Text("Notification"),
        ],
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
            onPressed: () async {
              try {
                int deb = int.parse(_heure_debController.text)!;
                int fin = int.parse(_heure_finController.text)!;
                verificationHeure(deb);
                verificationHeure(fin);
                events.addAll({
                  _selectedDay!: [
                    ..._selectedEvents.value,
                    Tache(
                        titre: _titreController.text,
                        description: _descriptionController.text,
                        heure_deb: deb,
                        heure_fin: fin,
                        date: _selectedDay!,
                        notification: recupereNotification)
                  ]
                });
                //Enregistrement en session des taches
                listeToutesTaches.add(Tache(
                    titre: _titreController.text,
                    description: _descriptionController.text,
                    heure_deb: deb,
                    heure_fin: fin,
                    date: _selectedDay!,
                    notification: recupereNotification));
                saveList(listeToutesTaches);
              }catch(e){
                Navigator.pop(context);
                mauvaiseHeure = true;
                return;
              }
              _selectedEvents.value = _getEventsForDay(_selectedDay!);
              clearController();
              Navigator.of(context).pop();
            },
            child: const Text('Enregistrer'))
      ],
    );
  }
}