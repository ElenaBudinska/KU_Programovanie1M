import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:servicesapp/models/service.dart';
import 'package:servicesapp/models/models.dart';
import 'package:servicesapp/pages/adminlogin_page.dart';
import 'package:servicesapp/pages/selectservice_page.dart';
import 'package:servicesapp/services/databaseHelper.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final databaseHelper = DatabaseHelper();

  // zoznam dostupných služieb
  final List<Service> _services = Models().getallavailableservices();

  int selectedService = 4;

  @override
  void initState() {
    // náhodne vyberie službu -> opakuje sa každé 2s
    Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        selectedService = Random().nextInt(_services.length);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
        children: [
          
        // horné odsadenie 40px
        const SizedBox(
          height: 40,
        ),

        // kontainer pre služby 3x3
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height * 0.45,
          width: MediaQuery.of(context).size.width,
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _services.length, // počet služieb
              itemBuilder: (BuildContext context, int index) {
                // vytvorenie kontaineru pre servise item
                return serviceContainer(
                    _services[index].imageURL, _services[index].name, index);
              }),
        ),

        // spodný kontainer
        Expanded(
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                
                // odsadenie 30px
                const SizedBox(
                  height: 30,
                ),

                // kontainer pre text
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: const Center(
                    child: Text(
                      'Jednoduchý a spoľahlivý spôsob starostlivosti o váš domov',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

                // odsadenie 15px
                const SizedBox(
                  height: 15,
                ),

                // kontainer pre text
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: Center(
                    child: Text(
                      'Ponúkame vám tých najlepších ľudí, ktorí vám pomôžu postarať sa o váš domov.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),

                // odsadenie 15px
                const SizedBox(
                  height: 15,
                ),

                // tlačidlo
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: MaterialButton(
                    elevation: 0,
                    color: Colors.black,
                    onPressed: () {
                      // navigácia do používateľského rozhrania 
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SelectServicePage(),
                        ),
                      );
                    },
                    height: 55,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: const Center(
                      child: Text(
                        'Začnite',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),

                // odsadenie 10px
                const SizedBox(
                  height: 10,
                ),

                // tlačidlo
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: MaterialButton(
                    elevation: 0,
                    onPressed: () async {
                      // administrátorovi sa nastaví heslo
                      await databaseHelper.createAdminPassword();

                      // navigácia do admin rozhrania
                      navigateToAdminPage();
                    },
                    height: 15,
                    child: const Center(
                      child: Text(
                        'Administrátor',
                        style: TextStyle(
                          color: Color(0xFF4AA9F7),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    ));
  }

  serviceContainer(String image, String name, int index) {
    return GestureDetector(
      onTap: () {},
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: selectedService == index ? Colors.white : Colors.grey.shade100,
          border: Border.all(
            color: selectedService == index
                ? Colors.blue.shade100
                : Colors.grey.withOpacity(0),
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(image, height: 30),
            const SizedBox(
              height: 10,
            ),
            Text(
              name,
              style: const TextStyle(fontSize: 14),
            )
          ]
        ),
      ),
    );
  }

  void navigateToAdminPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AdmiLoginPage(),
      ),
    );
  }
}
