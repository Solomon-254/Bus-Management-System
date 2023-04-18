import 'package:bus_management_system/helpers/responsivenes.dart';
import 'package:bus_management_system/widgets/horizontal_menu.dart';
import 'package:bus_management_system/widgets/vertical_menu.dart';
import 'package:flutter/material.dart';

class SideMenuItem extends StatelessWidget {
  final String itemName;
  final Function onTap;

  const SideMenuItem({Key key, @required this.itemName, @required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (ResponsiveWidget.isCustomSize(context)) {
      return VertticalMenuItem(
        itemName: itemName,
        onTap: onTap,
      );
    } else {
      return HorizontalMenuItem(
        itemName: itemName,
        onTap: onTap,
      );
    }
  }
}
