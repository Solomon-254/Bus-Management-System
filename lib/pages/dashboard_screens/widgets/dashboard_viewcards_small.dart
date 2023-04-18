import 'package:bus_management_system/models/bus_model.dart';
import 'package:bus_management_system/models/routes_model.dart';
import 'package:bus_management_system/models/users_model.dart';
import 'package:bus_management_system/pages/buses_screens/buses.dart';
import 'package:bus_management_system/pages/dashboard_screens/widgets/dashboard_cards_smallscreen.dart';
import 'package:bus_management_system/services/bus_database_service.dart';
import 'package:bus_management_system/services/events_database_service.dart';
import 'package:bus_management_system/services/routes_database_service.dart';
import 'package:bus_management_system/services/user_database_service.dart';
import 'package:flutter/material.dart';

import '../../../models/events_modal.dart';
import '../../buses_screens/widgets/bus_list.dart';

class OverviewCardsSmallScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;

    return Container(
      height: 400,
      child: Column(
        children: [
          // ignore: missing_required_param
          StreamBuilder<List<Bus>>(
            stream: BusDatabaseService().buses,
            builder: (BuildContext context, AsyncSnapshot<List<Bus>> snapshot) {
              if (snapshot.hasData) {
                // ignore: missing_required_param
                return InfoCardSmall(
                  title: "All Buses",
                  value: snapshot.data.length.toString(),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),

          SizedBox(
            height: _width / 64,
          ),
          StreamBuilder<List<Users>>(
            stream: UserDatabaseService().users,
            builder:
                (BuildContext context, AsyncSnapshot<List<Users>> snapshot) {
              if (snapshot.hasData) {
                // ignore: missing_required_param
                return InfoCardSmall(
                  title: "All Users",
                  value: snapshot.data.length.toString(),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
          SizedBox(
            height: _width / 64,
          ),
          StreamBuilder<List<Events>>(
            stream: EventsDatabaseService().events,
            builder:
                (BuildContext context, AsyncSnapshot<List<Events>> snapshot) {
              if (snapshot.hasData) {
                return InfoCardSmall(
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
            height: _width / 64,
          ),

           StreamBuilder<List<Routes>>(
            stream:RoutesDatabaseServices().routes,
            builder:
                (BuildContext context, AsyncSnapshot<List<Routes>> snapshot) {
              if (snapshot.hasData) {
                return InfoCardSmall(
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
      ),
    );
  }
}
