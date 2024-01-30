import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:servicesapp/models/request.dart';
import 'package:servicesapp/models/room.dart';
import 'package:servicesapp/models/service.dart';
import 'package:servicesapp/pages/adminmanagement_page.dart';
import 'package:servicesapp/pages/savingRequest_page.dart';
import 'package:servicesapp/pages/start_page.dart';

class DateTimePage extends StatefulWidget {
  const DateTimePage(
      {Key? key, required this.selectedService, required this.selectedRooms})
      : super(key: key);

  final Service selectedService;
  final List<Room> selectedRooms;

  @override
  _DateAndTimeState createState() => _DateAndTimeState();
}

class _DateAndTimeState extends State<DateTimePage> {
  String _errorMessage = '';
  DateTime? _date;
  TimeOfDay? _time;

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.only(top: 30.0, right: 40.0, left: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // text
              Text(
                'Objednávka',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.grey.shade900,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // odsadenie + text
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 15.0),
                child: Text(
                  'Dátum a čas vykonania prác',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey.shade900,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // textField Dátum
              TextField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'Dátum',
                  filled: true,
                  prefixIcon: Icon(Icons.calendar_today),
                  enabledBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)),
                ),
                readOnly: true,
                onTap: () {
                  _selectDate(context);
                },
              ),

              // odsadenie 20px
              const SizedBox(
                height: 20,
              ),

              // textField Čas
              TextField(
                controller: _timeController,
                decoration: const InputDecoration(
                  labelText: 'Čas',
                  filled: true,
                  prefixIcon: Icon(Icons.access_time),
                  enabledBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)),
                ),
                readOnly: true,
                onTap: () {
                  _selectTime(context);
                },
              ),

              // text
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 15.0),
                child: Text(
                  'Kontaktné údaje',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey.shade900,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // odsadenie + text
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Mobil',
                  filled: true,
                  prefixIcon: Icon(Icons.phone),
                  enabledBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)),
                ),
              ),

              // odsadenie 20px
              const SizedBox(
                height: 20,
              ),

              // textField Email
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  filled: true,
                  prefixIcon: Icon(Icons.email_outlined),
                  enabledBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)),
                ),
              ),

              // textField Email
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: MaterialButton(
                  elevation: 0,
                  color: Colors.black,
                  onPressed: () {
                    tryToFinishRequest();
                  },
                  height: 55,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: const Center(
                    child: Text(
                      'Odoslať',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),

              // zobrazenie chybovej hlášky
              if (_errorMessage.isNotEmpty)
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  color: Colors.white,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Center(
                            child: Text(
                              _errorMessage,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ]),
                )
              else
                const SizedBox(
                  height: 45,
                )
            ],
          ),
        ),
      ]),
    );
  }

  void tryToFinishRequest() {
    // je vyplnený dátum ???
    if (_dateController.text.isEmpty) {
      setState(() {
        _errorMessage =
            'Požiadavku nie je možné odoslať.\nZadajte dátum vykonania požiadavky.';
      });
    }

    // je vyplnený mobil alebo email ???
    else if (_phoneController.text.isEmpty && _emailController.text.isEmpty) {
      setState(() {
        _errorMessage =
            'Požiadavku nie je možné odoslať.\nZadajte mobilný kontakt alebo emailový kontakt.';
      });
    }

    // spracovanie požiadavky
    else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          DateTime combinedDateTime = _date != null && _time != null
              ? DateTime(
                  _date!.year,
                  _date!.month,
                  _date!.day,
                  _time!.hour,
                  _time!.minute,
                )
              : _date ?? DateTime.now();

          Request request = Request(
              widget.selectedService.id,
              widget.selectedService.name,
              createAdditionalInformation(),
              combinedDateTime,
              _phoneController.text,
              _emailController.text,
              null);

          return SavingRequestPage(request: request,);
        }),
      );
    }
  }

  // upravenie a formátovanie izieb na string
  String createAdditionalInformation() {
    String result = '';

    List<Room> selectedRooms = widget.selectedRooms;

    for (var room in selectedRooms) {

      if (result.isEmpty) {
        result += room.name;
      } else {
        result += ' | ${room.name}';
      }

      if (room.allowMultipleRooms) {
        result += ' (${room.count}x)';
      }
    }

    return result;
  }

  // popup s dátumom
  Future<void> _selectDate(BuildContext context) async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (date != null) {      
      setState(() {
        _date = date;
        _dateController.text = DateFormat('dd/MM/yyyy').format(date);
      });
    }
  }

  // popup s časom
  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (time != null) {
      setState(() {
        _time = time;
        String formattedHour = time.hour.toString().padLeft(2, '0');
        String formattedMinute = time.minute.toString().padLeft(2, '0');
        _timeController.text = '$formattedHour:$formattedMinute';
      });
    }
  }
}
