import 'package:bus_management_system/constants/controller.dart';
import 'package:bus_management_system/constants/style.dart';
import 'package:bus_management_system/controllers/navigation_controller.dart';
import 'package:bus_management_system/helpers/local_navigator.dart';
import 'package:bus_management_system/pages/buses_screens/buses_add.dart';
import 'package:bus_management_system/pages/settings_screens/settings.dart';
import 'package:bus_management_system/routings/routes.dart';
import 'package:bus_management_system/routings/routes_add.dart';
import 'package:bus_management_system/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

class NavigationButton extends StatelessWidget {
  final String text;
  final Color color;
  final Icon iconData;
  final Function function;
  const NavigationButton(
      {Key key, this.text, this.color, this.iconData, this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: iconsColor,
      child: ElevatedButton(
          onPressed: () {
            navigationController.navigateTo(AddBusesRoute);
          },
          child: Text(text)),
    );
  }
}

class NavigationButtonEvents extends StatelessWidget {
  final String text;
  final Color color;
  final Icon iconData;
  final Function function;
  const NavigationButtonEvents(
      {Key key, this.text, this.color, this.iconData, this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: iconsColor,
      child: ElevatedButton(
          onPressed: () {
            navigationController.navigateTo(AddEventsRoute);
          },
          child: Text(text)),
    );
  }
}

class NavigationButtonUsers extends StatelessWidget {
  final String text;
  final Color color;
  final Icon iconData;
  final Function function;
  const NavigationButtonUsers(
      {Key key, this.text, this.color, this.iconData, this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: iconsColor,
      child: ElevatedButton(
          onPressed: () {
            navigationController.navigateTo(AddUsersRoute);
          },
          child: Text(text)),
    );
  }
}

class NavigationButtonRoutes extends StatelessWidget {
  final String text;
  final Color color;
  final Icon iconData;
  final Function function;
  const NavigationButtonRoutes(
      {Key key, this.text, this.color, this.iconData, this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: iconsColor,
      child: Tooltip(
        message: 'Add Route',
        child: ElevatedButton(
            onPressed: () {
              navigationController.navigateTo(AddRoutesRoute);
            },
            child: Text(text)),
      ),
    );
  }
}
