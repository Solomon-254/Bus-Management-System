import 'package:bus_management_system/constants/style.dart';
import 'package:bus_management_system/helpers/local_navigator.dart';
import 'package:flutter/material.dart';

class PanelScreen extends StatelessWidget {
  const PanelScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 16), child: localNavigator());
  }
}
