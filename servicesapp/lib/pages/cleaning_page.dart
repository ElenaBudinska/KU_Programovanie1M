import 'package:flutter/material.dart';
import 'package:servicesapp/models/room.dart';
import 'package:servicesapp/models/service.dart';
import 'package:servicesapp/models/models.dart';
import 'package:servicesapp/pages/datetime_page.dart';

class CleaningPage extends StatefulWidget {
  const CleaningPage({Key? key, required this.selectedService})
      : super(key: key);

  final Service selectedService;

  @override
  _CleaningPageState createState() => _CleaningPageState();
}

class _CleaningPageState extends State<CleaningPage> {
  // všetky dostupné izby na čistenie
  final List<Room> _rooms = Models().getallavailablerooms();

  // vybrané izby na čistenie
  final List<Room> _selectedRooms = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        // plávajúce tlačidlo
        floatingActionButton: _selectedRooms.isNotEmpty
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DateTimePage(
                          selectedService: widget.selectedService,
                          selectedRooms: _selectedRooms)
                        ),
                  );
                },
                backgroundColor: Colors.blue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${_selectedRooms.length}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)
                      ),
                    const SizedBox(width: 2),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                      color: Colors.white
                    ),
                  ],
                ),
              )
            : null,
        // scrollovací kontainer
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              // nadpis
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 30.0, right: 40.0, left: 40.0),
                  child: Text(
                    'Čo všetko chcete vyčistiť?',
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
            child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _rooms.length,
                itemBuilder: (BuildContext context, int index) {
                  // vytvorenie kontaineru pre room item
                  return createRoom(_rooms[index]);
                }),
          ),
        ));
  }

  // kontrola či izba je už označená
  checkIfRoomIsSelected(int roomId) {
    bool result;

    try {
      _selectedRooms.firstWhere((room) => room.id == roomId);
      result = true;
    } catch (e) {
      result = false;
    }

    return result;
  }

  createRoom(Room room) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (!checkIfRoomIsSelected(room.id)) {
            _selectedRooms.add(room);
          } else {
            _selectedRooms.removeWhere((x) => x.id == room.id);
          }
        });
      },
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          margin: const EdgeInsets.only(bottom: 20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: checkIfRoomIsSelected(room.id)
                ? room.color.shade50.withOpacity(0.5)
                : Colors.grey.shade100,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Row(
                    children: [
                      Image.network(
                        room.imageURL,
                        width: 35,
                        height: 35,
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Text(room.name,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const Spacer(),

                  // vykreslenie kontaineru checkBox 
                  checkIfRoomIsSelected(room.id)
                    ? Container(
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          color: Colors.greenAccent.shade100.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: const Icon(Icons.check,
                          color: Colors.green, size: 20)
                        )
                    : const SizedBox()
                ],
              ),

              // vykreslenie kontaineru ak má izba nastavenú
              // možnosť zobrazovania viacerých miestností 
              (checkIfRoomIsSelected(room.id) && room.allowMultipleRooms)
                ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20.0,
                    ),
                    Text("Koľko máte ${room.inflectedName}?",
                        style: const TextStyle(fontSize: 15)),
                    const SizedBox(height: 10.0),
                    SizedBox(
                      height: 45,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 4,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                room.count = index + 1;
                              });
                            },
                            child: Container(
                              margin:
                                  const EdgeInsets.only(right: 10.0),
                              padding: const EdgeInsets.all(10.0),
                              width: 50,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(10.0),
                                color: room.count == index + 1
                                    ? room.color.withOpacity(0.5)
                                    : room.color.shade200
                                        .withOpacity(0.5),
                              ),
                              child: Center(
                                child: Text(
                                  (index + 1).toString(),
                                  style: const TextStyle(fontSize: 20, color: Colors.white),
                                )
                              ),
                            ),
                          );
                        }),
                    )
                  ],
                )
                : const SizedBox()
            ],
          )
        ),
    );
  }
}
