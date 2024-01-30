import 'dart:async';
import 'package:flutter/material.dart';
import 'package:servicesapp/models/request.dart';
import 'package:servicesapp/pages/start_page.dart';
import 'package:servicesapp/services/databaseHelper.dart';

class SavingRequestPage extends StatefulWidget {
  const SavingRequestPage({Key? key, required this.request}) : super(key: key);

  final Request request;

  @override
  _SavingRequestState createState() => _SavingRequestState();
}

class _SavingRequestState extends State<SavingRequestPage> {
  final databaseHelper = DatabaseHelper();  
  late Timer timer;
  // čas na presmerovanie 
  int timeToAutomaticRedirect = 5;

  @override
  void initState() {
    super.initState();

    initializePage();
  }

  Future<void> initializePage() async {

    // vloženie požiadavky do DB
    await databaseHelper.insertServiseRequest(widget.request);

    // automatické odpočítanie na presmerovanie na hlavnú stránku
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeToAutomaticRedirect <= 1) {
        timer.cancel();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const StartPage(),
          ),
        );
      } else {
        setState(() {
          timeToAutomaticRedirect--;
        });
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 40),
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [                 

                  // odsadenie + text
                  const Padding(
                    padding: EdgeInsets.only(top: 30.0),
                    child: Center(
                      child: Text(
                        'Vaša požiadavka bola odoslaná.',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // odsadenie + text
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Center(
                      child: Text(
                        'Budeme vás kontaktovať.',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // odsadenie + text
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Center(
                      child: Text(
                        'Budete premerovaný na hlavnú stránku o ${timeToAutomaticRedirect}s.',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
