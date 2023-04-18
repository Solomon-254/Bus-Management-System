import 'package:bus_management_system/models/routes_model.dart';
import 'package:bus_management_system/models/users_model.dart';
import 'package:bus_management_system/pages/buses_screens/widgets/bus_list.dart';
import 'package:bus_management_system/pages/dashboard_screens/widgets/dashboard_cards.dart';
import 'package:bus_management_system/services/bus_database_service.dart';
import 'package:bus_management_system/services/routes_database_service.dart';
import 'package:bus_management_system/services/user_database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../models/bus_model.dart';
import '../../../models/events_modal.dart';
import '../../../services/events_database_service.dart';

class OverviewCardsLargeScreen extends StatelessWidget {
  const OverviewCardsLargeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;

    return Row(
      children: [
        StreamBuilder<List<Bus>>(
          stream: BusDatabaseService().buses,
          builder: (BuildContext context, AsyncSnapshot<List<Bus>> snapshot) {
            if (snapshot.hasData) {
              return InfoCard(
                title: "All Buses",
                value: snapshot.data.length.toString(),
                topColor: Colors.orange,
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
        SizedBox(
          width: _width / 64,
        ),
        StreamBuilder<List<Users>>(
          stream: UserDatabaseService().users,
          builder: (BuildContext context, AsyncSnapshot<List<Users>> snapshot) {
            if (snapshot.hasData) {
              return InfoCard(
                title: "All Users",
                value: snapshot.data.length.toString(),
                topColor: Colors.lightGreen,
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
        SizedBox(
          width: _width / 64,
        ),
        StreamBuilder<List<Events>>(
          stream: EventsDatabaseService().events,
          builder:
              (BuildContext context, AsyncSnapshot<List<Events>> snapshot) {
            if (snapshot.hasData) {
              return InfoCard(
                title: "All Events",
                value: snapshot.data.length.toString(),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
        SizedBox(
          width: _width / 64,
        ),
        StreamBuilder<List<Routes>>(
          stream: RoutesDatabaseServices().routes,
          builder:
              (BuildContext context, AsyncSnapshot<List<Routes>> snapshot) {
            if (snapshot.hasData) {
              return InfoCard(
                title: "All Routes",
                value: snapshot.data.length.toString(),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return CircularProgressIndicator();
            }
          },
        ),

      ],
    );
  }
}
