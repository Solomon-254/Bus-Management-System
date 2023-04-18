import 'package:bus_management_system/constants/style.dart';
import 'package:bus_management_system/routings/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuController extends GetxController {
  static MenuController instance = Get.find();

  var activeItem = DashboardPageDisplayName.obs;
  var hoverItem = "".obs;

  changeActiveItemTo(String itemName) {
    activeItem.value = itemName;
  }

  onHover(String itemName) {
    if (!isActive(itemName)) hoverItem.value = itemName;
  }

  isActive(String itemName) => activeItem.value == itemName;

  isHovering(String itemName) => hoverItem.value == itemName;

  Widget returnIconFor(String itemName) {
    switch (itemName) {
      case DashboardPageDisplayName:
        return _customIcon(Icons.home, itemName);

      case BusesPageDisplayName:
        return _customIcon(Icons.bus_alert_outlined, itemName);

      case UsersPageDisplayName:
        return _customIcon(Icons.people, itemName);

      case HistoryPageDisplayName:
        return _customIcon(Icons.event, itemName);

      case RoutesPageDisplayName:
        return _customIcon(Icons.route, itemName);

      case SettingsPageDisplayName:
        return _customIcon(Icons.settings, itemName);

      case AuthenticationDisplayName:
        return _customIcon(Icons.exit_to_app, itemName);
    }
  }

  Widget _customIcon(IconData icon, String itemName) {
    if (isActive(itemName)) {
      return Icon(
        icon,
        size: 22,
        color: iconsColor,
      );
    }
    return Icon(
      icon,
      color: isHovering(itemName) ? iconsColor : Colors.grey,
    );
  }
}
