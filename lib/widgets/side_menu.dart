import 'package:bus_management_system/constants/controller.dart';
import 'package:bus_management_system/constants/style.dart';
import 'package:bus_management_system/helpers/responsivenes.dart';
import 'package:bus_management_system/pages/onboarding_screen/login.dart';
import 'package:bus_management_system/routings/routes.dart';
import 'package:bus_management_system/services/auth.dart';
import 'package:bus_management_system/widgets/custom_text.dart';
import 'package:bus_management_system/widgets/side_menu_items.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    final AuthService _auth = AuthService();
    final FirebaseFirestore _db = FirebaseFirestore.instance;

    return Container(
      color: bgAccentColor,
      child: ListView(
        children: [
          if (ResponsiveWidget.isSmallScreen(context))
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: _width / 48,
                    ),
                    const Padding(
                        padding: EdgeInsets.only(right: 12),
                        child: CircleAvatar(
                          radius: 25,
                        )),
                    Flexible(
                      child: StreamBuilder<DocumentSnapshot>(
                        stream: _db
                            .collection('RegisteredUsers')
                            .doc(_auth.currentUser.uid)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.hasData) {
                            Map<String, dynamic> data = snapshot.data.data();
                            String fullName = data['fullName'] ?? '';

                            return CustomText(
                              text: fullName,
                              color: textColor,
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: _width / 40,
                    ),
                  ],
                ),
                SizedBox(
                  width: _width / 48,
                ),
                const Divider(
                  color: Color.fromARGB(255, 228, 228, 228),
                ),
              ],
            ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: panelMenuItems
                .map(
                  (item) => SideMenuItem(
                    itemName: item.name,
                    onTap: () async {
                      if (item.route == AuthenticationViewRoute)  {
                
                      await  _auth.signOutUser();
                       // Get.offAll(() => const LoginPage());
                        Get.offAllNamed(AuthenticationViewRoute);
                             menuController
                            .changeActiveItemTo(DashboardPageDisplayName);
                      }
                      if (!menuController.isActive(item.name)) {
                        menuController.changeActiveItemTo(item.name);
                        if (ResponsiveWidget.isSmallScreen(context)) Get.back();
                        navigationController.navigateTo(item.route);

                        Navigator.pushReplacementNamed(context, item.name);
                        //Go to each respective pages as we are navigating
                      }
                    },
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
