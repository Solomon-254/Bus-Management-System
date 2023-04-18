import 'package:bus_management_system/constants/controller.dart';
import 'package:bus_management_system/routings/router.dart';
import 'package:bus_management_system/routings/routes.dart';
import 'package:flutter/cupertino.dart';

Navigator localNavigator() => Navigator(
      key: navigationController.navigationKey,
      initialRoute: DashboardViewRoute,
      onGenerateRoute: generateRoute,
    );
