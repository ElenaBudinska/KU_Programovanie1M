import 'package:flutter/material.dart';
import 'package:servicesapp/pages/adminmanagement_page.dart';
import 'package:servicesapp/pages/start_page.dart';
import 'package:servicesapp/services/databaseHelper.dart';

class AdmiLoginPage extends StatefulWidget {
  const AdmiLoginPage({Key? key}) : super(key: key);

  @override
  _AdmiLoginPageState createState() => _AdmiLoginPageState();
}

class _AdmiLoginPageState extends State<AdmiLoginPage> {
  final databaseHelper = DatabaseHelper();
  bool _errorMessageVisibility = false;
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

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
        body: Column(children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 40),
              color: Colors.white,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Administrátor',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 250,
                      child: TextField(
                        controller: _emailController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Heslo',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 250,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: MaterialButton(
                          elevation: 0,
                          color: Colors.black,
                          onPressed: () async {
                            // získanie administrátorského hesla z DB
                            String adminPassword = await databaseHelper.getAdminPassword();

                            // prihlásenie sa do admin rozhrania
                            tryToLogin(adminPassword);
                          },
                          height: 55,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: const Center(
                            child: Text(
                              'Prihlásiť',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // zobrazenie chybovej hlášky
                    if (_errorMessageVisibility)
                      const SizedBox(
                        height: 25,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            'Prihlasovacie heslo nie je správne!',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      )
                    else
                      const SizedBox(
                        height: 25,
                      )
                  ]),
            ),
          ),

          // dolné odsadenie 40px
          const SizedBox(
            height: 40,
          ),
        ]));
  }

  void tryToLogin(String adminPassword) {   

    // heslo je správne
    if (_emailController.text == adminPassword) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AdminManagementPage(),
        ),
      );
    }

    // heslo nie je správne = vymazať text + hláška
    else {
      setState(() {
        _errorMessageVisibility = true;
      });
      _emailController.clear();
    }
  }
}
