import 'package:flutter/material.dart';
import 'package:servicesapp/models/service.dart';
import 'package:servicesapp/models/models.dart';
import 'package:servicesapp/pages/cleaning_page.dart';

class SelectServicePage extends StatefulWidget {
  const SelectServicePage({Key? key}) : super(key: key);

  @override
  _SelectServiceState createState() => _SelectServiceState();
}

class _SelectServiceState extends State<SelectServicePage> {  
  // zoznam dostupných služieb
  final List<Service> _services = Models().getallavailableservices();

  // vybraná služba
  int selectedService = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // plávajúce tlačidlo
      floatingActionButton: selectedService >= 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CleaningPage(
                        selectedService: _services[selectedService]),
                  ),
                );
              },
              backgroundColor: Colors.blue,
              child: const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.white),
            )
          : null,
      body:
        NestedScrollView(
        floatHeaderSlivers: false,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 30.0, bottom: 10.0, right: 40.0, left: 40.0),
                child: Text(
                  'O ktorú službu máte záujem?',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.grey.shade900,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ];
        },
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: GridView.builder(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 20.0,
                    mainAxisSpacing: 20.0,
                  ),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _services.length,
                  itemBuilder: (BuildContext context, int index) {
                    // vytvorenie kontaineru pre servise item
                    return serviceContainer(_services[index].imageURL,
                        _services[index].name, index);
                  }),
              ),
            ]),
        ),
      ),
    );
  }

  serviceContainer(String image, String name, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          // iba Upratovač (index = 0) je dostupný !!!
          if (selectedService != index && index == 0) {
            selectedService = index;
          } else {
            selectedService = -1;
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: selectedService == index
              ? Colors.blue.shade50
              : Colors.grey.shade100,
          border: Border.all(
            color: selectedService == index
                ? Colors.blue
                : Colors.blue.withOpacity(0),
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(image, height: 80),
            const SizedBox(
              height: 20,
            ),
            Text(name, style: const TextStyle(fontSize: 20))
          ]
        ),
      ),
    );
  }
}
