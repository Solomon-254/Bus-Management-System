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
import 'package:google_fonts/google_fonts.dart';

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
  bool _showNotificationCount = false;

  void _toggleNotificationCount(bool value) {
    setState(() {
      _showNotificationCount = value;
    });
  }

  void markNotificationsAsSeen() {
    final WriteBatch batch = FirebaseFirestore.instance.batch();
    final CollectionReference notificationsCollection =
        FirebaseFirestore.instance.collection('Notifications');

    // Get all documents where isNotificationSeen is false
    final Query unseenNotificationsQuery =
        notificationsCollection.where('isNotificationSeen', isEqualTo: false);
    unseenNotificationsQuery.get().then((querySnapshot) {
      // For each document, add an update operation to the batch
      querySnapshot.docs.forEach((doc) {
        final DocumentReference docRef = notificationsCollection.doc(doc.id);
        batch.update(docRef, {'isNotificationSeen': true});
      });

      // Commit the batch of updates
      batch.commit();
    });
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 228, 228, 228),
      elevation: 2,
      leading: !ResponsiveWidget.isSmallScreen(context)
          ? Row(
              children: [
                IntrinsicWidth(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/AlgoaBuses');
                    },
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 36,
                      fit: BoxFit.contain,
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
      title: Row(children: [
        Visibility(
          visible: !ResponsiveWidget.isSmallScreen(context),
          child: Container(),
        ),
        Expanded(child: Container()),
        const SizedBox(
          width: 14,
        ),
        StreamBuilder<DocumentSnapshot>(
          stream: _db
              .collection('RegisteredUsers')
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
                size: 16,
                fontStyle: FontStyle.normal,
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
                  markNotificationsAsSeen();
                  showNotificationsList(context);
                },
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: EventsDatabaseService().notificationCollecion.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return SizedBox();
                }
                final List<QueryDocumentSnapshot> unseenNotifications = snapshot
                    .data.docs
                    .where((doc) => doc.get('isNotificationSeen') == false)
                    .toList();
                int notificationCount = unseenNotifications.length;
                return Positioned(
                  right: 0,
                  child: notificationCount > 0
                      ? Container(
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
                        )
                      : SizedBox(),
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
      ]),
    );
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
                        if (docs.isEmpty) {
                          return const Center(
                            child: Text('No Notifications on Events'),
                          );
                        }
                        List<Widget> notificationsList = [];
                        for (int i = 0; i < docs.length; i++) {
                          var doc = docs[i];
                          if (doc['SMS SENT'] != null) {
                            notificationsList.add(
                              Column(
                                children: [
                                  ListTile(
                                    leading: Text('${i + 1}.'),
                                    title: Text(doc['SMS SENT']),
                                    trailing: Tooltip(
                                        message: 'Delete Event Notification',
                                        child: IconButton(
                                            onPressed: () {
                                              doc.reference.delete();
                                            },
                                            icon: Icon(
                                              Icons.delete,
                                              color: iconsColor,
                                              size: 20,
                                            ))),
                                  ),
                                  const Divider(
                                    color: Color.fromARGB(255, 231, 230, 230),
                                    thickness: 0.5,
                                    height: 0,
                                  ),
                                ],
                              ),
                            );
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
