import 'package:bus_management_system/constants/style.dart';
import 'package:bus_management_system/helpers/responsivenes.dart';
import 'package:bus_management_system/pages/onboarding_screen/login.dart';
import 'package:bus_management_system/pages/settings_screens/settings.dart';
import 'package:bus_management_system/routings/routes.dart';
import 'package:bus_management_system/services/auth.dart';
import 'package:bus_management_system/services/events_database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../layout.dart';
import 'custom_text.dart';

class TopNavigationBar extends StatefulWidget {
  const TopNavigationBar({Key key}) : super(key: key);

  @override
  State<TopNavigationBar> createState() => _TopNavigationBarState();
}

class _TopNavigationBarState extends State<TopNavigationBar> {
  final AuthService _auth = AuthService();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  int notificationCount = 0;
  bool _showNotifications = false;

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
    return AppBar(
        backgroundColor: const Color.fromARGB(255, 228, 228, 228),
        elevation: 0,
        leading: !ResponsiveWidget.isSmallScreen(context)
            ? Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            // refresh the page
                            Navigator.pushReplacementNamed(
                                context, '/AlgoaBuses');
                          },
                          child: Transform.scale(
                            scale:
                                20, // increase the scale value to enlarge the image
                            child: Image.asset(
                              'assets/images/logo.png',
                              height: 150,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
        title: Container(
            child: Row(children: [
          Visibility(
            visible: !ResponsiveWidget.isSmallScreen(context),
            child: Container(),
          ),
          Expanded(child: Container()),
          Container(
            width: 1,
            height: 16,
            color: bgAccentColor,
          ),
          Container(
            width: 1,
            height: 16,
            color: bgAccentColor,
          ),
          const SizedBox(
            width: 14,
          ),
          StreamBuilder<DocumentSnapshot>(
            stream: _db
                .collection('AuthorisedUsers')
                .doc(_auth.currentUser.uid)
                .snapshots(),
            builder: (
              BuildContext context,
              AsyncSnapshot<DocumentSnapshot> snapshot,
            ) {
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
          const SizedBox(
            width: 5,
          ),
          Container(
            width: 1,
            height: 16,
            color: bgAccentColor,
          ),
          Stack(
            children: <Widget>[
              Tooltip(
                message: 'Notifications Sent on Events',
                child: IconButton(
                  icon: Icon(
                    Icons.notifications,
                    color: iconsColor,
                  ),
                  onPressed: () {
                    showNotificationsList(context);
                  },
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream:
                    EventsDatabaseService().notificationCollecion.snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return SizedBox();
                  }
                  int notificationCount = snapshot.data.docs.length;
                  return Positioned(
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 14,
                        minHeight: 14,
                      ),
                      child: Text(
                        '$notificationCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              )
            ],
          ),
          Container(
            width: 1,
            height: 16,
            color: bgAccentColor,
          ),
        ])));
  }

  void showNotificationsList(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.topRight,
          child: AlertDialog(
            title: Text('Notifications Sent on Events'),
            content: SizedBox(
              width: 300, // set the width of the dialog
              height: 200, // set the height of the dialog
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: EventsDatabaseService()
                          .notificationCollecion
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }
                        List<DocumentSnapshot> docs = snapshot.data.docs;
                        List<Widget> notificationsList = [];
                        for (int i = 0; i < docs.length; i++) {
                          var doc = docs[i];
                          if (doc['SMS SENT'] != null) {
                            notificationsList.add(ListTile(
                              leading: Text('${i + 1}.'),
                              title: Text(doc['SMS SENT']),
                            ));
                          }
                        }
                        return ListView(
                          shrinkWrap: true,
                          children: notificationsList,
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
