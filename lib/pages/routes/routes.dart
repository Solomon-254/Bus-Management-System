import 'package:bus_management_system/models/routes_model.dart';
import 'package:bus_management_system/pages/routes/routes_list.dart';
import 'package:bus_management_system/services/routes_database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/users_model.dart';
 

class AllRoutesManager extends StatefulWidget {
  //  final List<Users> busesList;
  // List<Users> newList;
  const AllRoutesManager({ Key key }) : super(key: key);

  @override
  State<AllRoutesManager> createState() => _AllRoutesManagerState();
}

class _AllRoutesManagerState extends State<AllRoutesManager> {
  @override

 @override
  Widget build(BuildContext context) {
     return StreamProvider<List<Routes>>.value(
      value: RoutesDatabaseServices().routes,
      initialData: [],
      child: const Scaffold(
        body: RoutesPage(),
      ),
    );
  }
}