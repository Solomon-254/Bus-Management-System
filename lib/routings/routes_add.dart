import 'package:bus_management_system/pages/buses_screens/buses_add.dart';
import 'package:bus_management_system/pages/events_screens/events_add.dart';
import 'package:bus_management_system/pages/settings_screens/settings.dart';
import 'package:bus_management_system/pages/users_screens/users_add.dart';
import 'package:flutter/material.dart';

class RouteManager {
  static const AddBusPage = "/pages/buses_screens/bus_add.dart";
  static const AddEvents = "/pages/events_screens/events_add.dart";
  static const AddUserPage = "/pages/users_screens/users_add.dart";

  static Route<dynamic> generateAddRoutes(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case AddBusPage:
        return MaterialPageRoute(builder: (context) => const AddBusesPage());

      case AddEvents:
        return MaterialPageRoute(builder: (context) => const AddEventsPage());

      case AddUserPage:
        return MaterialPageRoute(builder: (context) => AddUsersPage());

      default:
        throw const FormatException("Route not found! Check your routes again");
    }
  }
}
