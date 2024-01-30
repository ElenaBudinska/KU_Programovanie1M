import 'package:flutter/material.dart';
import 'package:servicesapp/models/room.dart';
import 'package:servicesapp/models/service.dart';

class Models {

  // zoznam dostupných služieb
  List<Service> getallavailableservices() {
    return [
      Service(
          1,
          'Upratovač',
          'https://img.icons8.com/external-vitaliy-gorbachev-flat-vitaly-gorbachev/2x/external-cleaning-labour-day-vitaliy-gorbachev-flat-vitaly-gorbachev.png'),
      
      Service(
          2,
          'Inštalatér',
          'https://img.icons8.com/external-vitaliy-gorbachev-flat-vitaly-gorbachev/2x/external-plumber-labour-day-vitaliy-gorbachev-flat-vitaly-gorbachev.png'),
      
      Service(
          3,
          'Elektrikár',
          'https://img.icons8.com/external-wanicon-flat-wanicon/2x/external-multimeter-car-service-wanicon-flat-wanicon.png'),
      
      Service(
          4,
          'Maliar',
          'https://img.icons8.com/external-itim2101-flat-itim2101/2x/external-painter-male-occupation-avatar-itim2101-flat-itim2101.png'),
      
      Service(
          5,
          'Tesár',
          'https://img.icons8.com/fluency/2x/drill.png'),
      
      Service(
          6,
          'Záhradník',
          'https://img.icons8.com/external-itim2101-flat-itim2101/2x/external-gardener-male-occupation-avatar-itim2101-flat-itim2101.png'),
      
      Service(
          7,
          'Krajčírka',
          'https://img.icons8.com/fluency/2x/sewing-machine.png'),
      
      Service(
          8,
          'Chyžná',
          'https://img.icons8.com/color/2x/housekeeper-female.png'),
      
      Service(
          9,
          'Vodič',
          'https://img.icons8.com/external-sbts2018-lineal-color-sbts2018/2x/external-driver-women-profession-sbts2018-lineal-color-sbts2018.png'),
    ];
  }

  // zoznam dostupných izieb na čistenie
  List<Room> getallavailablerooms() {
    return [
      Room(
          1,
          'Obývačka',
          'https://img.icons8.com/officel/2x/living-room.png',
          Colors.red,
          false,
          ''),

      Room(
          2,
          'Spáleň',
          'https://img.icons8.com/fluency/2x/bedroom.png',
          Colors.orange,
          true,
          'spáľní'),

      Room(
          4,
          'Kúpeľňa',
          'https://img.icons8.com/color/2x/bath.png',
          Colors.blue,
          true,
          'kúpeľní'),

      Room(
          5,
          'Kuchyňa',
          'https://img.icons8.com/dusk/2x/kitchen.png',
          Colors.purple,
          false,
          ''),

      Room(
          6,
          'Pracovňa',
          'https://img.icons8.com/color/2x/office.png',
          Colors.green,
          false,
          ''),
    ];
  }
}