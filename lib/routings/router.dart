import 'dart:html';
import 'dart:js';

import 'package:bus_management_system/pages/buses_screens/buses.dart';
import 'package:bus_management_system/pages/buses_screens/buses_add.dart';
import 'package:bus_management_system/pages/buses_screens/widgets/download_bus_file_uploaded.dart';
import 'package:bus_management_system/pages/dashboard_screens/dashboard.dart';
import 'package:bus_management_system/pages/events_screens/events.dart';
import 'package:bus_management_system/pages/events_screens/events_add.dart';
import 'package:bus_management_system/pages/onboarding_screen/login.dart';
import 'package:bus_management_system/pages/routes/routes.dart';
import 'package:bus_management_system/pages/routes/routes_add.dart';
import 'package:bus_management_system/pages/routes/routes_list.dart';
import 'package:bus_management_system/pages/settings_screens/settings.dart';
import 'package:bus_management_system/pages/users_screens/users.dart';
import 'package:bus_management_system/pages/users_screens/users_add.dart';
import 'package:bus_management_system/routings/routes.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case DashboardViewRoute:
      return _getpageRoute(OverviewPage());

    case BusesViewRoute:
      return _getpageRoute(BusesPage());

    case UsersViewRoute:
      return _getpageRoute(UsersPage());

    case HistoryViewRoute:
      return _getpageRoute(EventsPage());

    case RoutesViewsRoutes:
      return _getpageRoute(AllRoutesManager());

    case SettingsViewRoute:
      return _getpageRoute(SettingsPage());

    case AddBusesRoute:
      return _getpageRoute(AddBusesPage());

    case AddEventsRoute:
      return _getpageRoute(AddEventsPage());

    case AddUsersRoute:
      return _getpageRoute(AddUsersPage());

    case AddRoutesRoute:
      return _getpageRoute(AddRoutesPage());

    case DownloadBusFilesRoute:
      return _getpageRoute(DownloadBusFilesPage());
  }
}

PageRoute _getpageRoute(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}
