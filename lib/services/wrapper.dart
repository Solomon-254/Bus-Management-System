import 'package:bus_management_system/layout.dart';
import 'package:bus_management_system/models/user_model.dart';
import 'package:bus_management_system/pages/onboarding_screen/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);

    if (user == null) {
      return LoginPage();
    } else {
      return SiteLayout();
    }
  }
}
