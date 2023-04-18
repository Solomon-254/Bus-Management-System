import 'package:bus_management_system/models/events_modal.dart';
import 'package:bus_management_system/models/users_model.dart';
import 'package:bus_management_system/services/bus_database_service.dart';
import 'package:bus_management_system/services/events_database_service.dart';
import 'package:bus_management_system/services/routes_database_service.dart';
import 'package:flutter/material.dart';

import '../../../models/bus_model.dart';
import '../../../models/routes_model.dart';
import '../../../services/user_database_service.dart';
import '../../buses_screens/widgets/bus_list.dart';
import 'dashboard_cards.dart';

class OverviewCardsMediumScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            StreamBuilder<List<Bus>>(
              stream: BusDatabaseService().buses,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Bus>> snapshot) {
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
              builder:
                  (BuildContext context, AsyncSnapshot<List<Users>> snapshot) {
                if (snapshot.hasData) {
                  return InfoCard(
                    title: "Users",
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
          ],
        ),
        SizedBox(
          height: _width / 64,
        ),
        Row(
          children: [
            StreamBuilder<List<Events>>(
              stream: EventsDatabaseService().events,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Events>> snapshot) {
                if (snapshot.hasData) {
                  return InfoCard(
                    title: "All Events",
                    value: snapshot.data.length.toString(),
                    topColor: Colors.red,
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
                    topColor: Colors.red,
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
