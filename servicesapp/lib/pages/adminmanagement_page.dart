import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:servicesapp/models/request.dart';
import 'package:servicesapp/pages/start_page.dart';
import 'package:servicesapp/services/databaseHelper.dart';

class AdminManagementPage extends StatefulWidget {
  const AdminManagementPage({Key? key}) : super(key: key);

  @override
  _AdminManagementPageState createState() => _AdminManagementPageState();
}

class _AdminManagementPageState extends State<AdminManagementPage> {
  final databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      // plávajúce tlačidlo
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const StartPage(),
            ),
          );
        },
        backgroundColor: Colors.blue,
        label: const Text('Späť',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white)),
        icon: const Icon(Icons.arrow_back_ios, size: 18, color: Colors.white),
      ),
      body: Column(
        children: [

        // nadpis
        Padding(
          padding: const EdgeInsets.only(top: 30.0, bottom: 20.0),
          child: Text(
            'Zoznam požiadaviek',
            style: TextStyle(
              fontSize: 30,
              color: Colors.grey.shade900,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        Expanded(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 40),
            color: Colors.white,
            child:
               Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                // kontainer napojený na zoznam všetkých požiadaviek
                FutureBuilder(
                  future: databaseHelper.getAllServiseRequests(),
                  builder: (context, snapshot) {
                    // overovanie, či existujú nejaké dáta na zobrazenie, resp. či sa nevyskytla nejaká chyba
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Chyba: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('Nie sú dostupné žiadne dáta.'));
                    }

                    List<Request> requests = snapshot.data as List<Request>;

                    return Expanded(
                      child: ListView.builder(
                        itemCount: requests.length,
                        itemBuilder: (context, index) {

                          return Container(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey,
                                    style: BorderStyle.solid,
                                    width: 1.5,
                                ),
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(7),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      // 1. riadok = názov služby
                                      Row(
                                        children: [
                                          const Text(
                                            'Typ služby: ',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            requests[index].serviceName,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ]
                                      ),

                                      // 2. riadok = datum
                                      Row(
                                        children: [
                                          const Text(
                                            'Dátum: ',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            DateFormat('yyyy/MM/dd HH:mm').format(requests[index].dateTime),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ]
                                      ),

                                      // 3.-4. riadok = kontakty
                                      if(requests[index].phone.isNotEmpty)
                                        Row(
                                          children: [
                                            const Text(
                                              'Telefón: ',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              requests[index].phone,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ]
                                        ),
                                      
                                      if(requests[index].email.isNotEmpty)
                                        Row(
                                          children: [
                                            const SizedBox(
                                              child: Text(
                                                'Email: ',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),

                                            SizedBox(
                                              child: Text(
                                                requests[index].email,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ]
                                        ),
                                    
                                      // 5. riadok = bližšie info
                                      const SizedBox(
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 7),
                                          child: Text(
                                            'Bližšie info:',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        child: Text(
                                          requests[index].additionalInformation,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ),
                                ]),
                            ),
                          );  
                        },
                    ),
                  );
                },
              )
            ]),
          ),
        ),
      
        const SizedBox(
          height: 80,
        ),
      ]),
    );
  }
}
