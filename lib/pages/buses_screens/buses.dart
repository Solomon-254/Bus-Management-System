// ignore_for_file: unused_import

import 'package:bus_management_system/constants/style.dart';
import 'package:bus_management_system/helpers/local_navigator.dart';
import 'package:bus_management_system/models/bus_model.dart';
import 'package:bus_management_system/models/user_model.dart';
import 'package:bus_management_system/pages/buses_screens/buses_add.dart';
import 'package:bus_management_system/pages/buses_screens/widgets/bus_list.dart';
import 'package:bus_management_system/pages/onboarding_screen/login.dart';
import 'package:bus_management_system/routings/router.dart';
import 'package:bus_management_system/routings/routes.dart';
import 'package:bus_management_system/services/bus_database_service.dart';
import 'package:bus_management_system/widgets/navigationButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

import '../../constants/controller.dart';
import '../../helpers/responsivenes.dart';
import '../../widgets/custom_text.dart';

class Buses {
  String busName;
  String licenceNumber;
  String plateNumber;
  String assignedDriver;
  Buses(
      this.busName, this.licenceNumber, this.plateNumber, this.assignedDriver);
}

class BusesPage extends StatefulWidget {
  final List<Buses> busesList;

  List<Buses> newList;

  BusesPage({
    this.busesList = const <Buses>[],
    Key key,
  }) : super(key: key);

  @override
  State<BusesPage> createState() => _BusesPageState();
}

class _BusesPageState extends State<BusesPage> {
  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<UserModel>(context);
    return StreamProvider<List<Bus>>.value(
      value: BusDatabaseService().buses,
      child: Scaffold(
        body: BusList(),
      ),
    );
  }
}
