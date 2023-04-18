import 'package:bus_management_system/constants/style.dart';
import 'package:bus_management_system/services/events_database_service.dart';
import 'package:bus_management_system/services/routes_database_service.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/routes_model.dart';
import '../../models/users_model.dart';
import '../../services/user_database_service.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/navigationButton.dart';

class RoutesPage extends StatefulWidget {
  const RoutesPage({Key key}) : super(key: key);

  @override
  State<RoutesPage> createState() => _RoutesPageState();
}

class _RoutesPageState extends State<RoutesPage> {
  TextEditingController _searchController = TextEditingController();
  //Implemetation of searching data in the datatable
  List<Routes> _filteredRoutes = [];

  void _performSearch(List<Routes> routesList) {
    setState(() {
      _filteredRoutes = routesList
          .where((routes) =>
              routes.busName
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              routes.startingPoint
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              routes.destinationPoint
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              routes.distanceInKm
                  .toString()
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              routes.cost
                  .toString()
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _filteredRoutes = [];
  }
  // -----

//Updating entities
  void _showEditDialog(BuildContext context, int index, String docId) {
    final formKey = GlobalKey<FormState>();
    String busName;
    String startingPoint;
    String destinationPoint;
    double distanceInKm;
    double cost;
    bool _isLoading = false;
    String selectedRoute;
    Future<List<Map<String, dynamic>>> routesListFuture;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Route"),
          content: StreamBuilder<Routes>(
              stream: RoutesDatabaseServices().getURouteData(docId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Routes routes = snapshot.data;

                  return Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextFormField(
                          initialValue: routes.busName,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'This field cannot be empty';
                            }
                            return null;
                          },
                          decoration:
                              const InputDecoration(labelText: 'Bus Name'),
                          onChanged: (value) {
                            setState(() {
                              busName = value;
                            });
                          },
                        ),
                        TextFormField(
                          initialValue: routes.startingPoint,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'This field cannot be empty';
                            }
                            return null;
                          },
                          decoration:
                              const InputDecoration(labelText: 'Staring Point'),
                          onChanged: (value) {
                            setState(() {
                              startingPoint = value;
                            });
                          },
                        ),
                        TextFormField(
                          initialValue: routes.destinationPoint,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'This field cannot be empty';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              labelText: 'Destination Point'),
                          onChanged: (value) {
                            setState(() {
                              destinationPoint = value;
                            });
                          },
                        ),
                        TextFormField(
                          initialValue: routes.distanceInKm.toString(),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'This field cannot be empty';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              labelText: 'Distance Interval(KM)'),
                          onChanged: (value) {
                            setState(() {
                              distanceInKm = double.parse(value);
                            });
                          },
                        ),
                        TextFormField(
                          initialValue: routes.distanceInKm.toString(),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'This field cannot be empty';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              labelText: 'Cost Incurred(SA Rand)'),
                          onChanged: (value) {
                            setState(() {
                              cost = double.parse(value);
                            });
                          },
                        ),
                        Row(
                          children: [
                            FlatButton(
                              child: _isLoading
                                  ? const CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                    )
                                  : Text(
                                      "Update",
                                      style: TextStyle(
                                          fontSize: 15, color: iconsColor),
                                    ),
                              onPressed: () async {
                                //Updating data in the firestore
                                if (formKey.currentState.validate()) {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  await RoutesDatabaseServices(uid: docId)
                                      .updateRouteData(
                                          busName ?? routes.busName,
                                          startingPoint ?? routes.startingPoint,
                                          destinationPoint ??
                                              routes.destinationPoint,
                                          distanceInKm ?? routes.distanceInKm,
                                          cost ?? routes.cost);

                                  setState(() {
                                    _isLoading = false;
                                  });
                                  Navigator.of(context).pop();
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text(
                                            "Updating Route's Info Completed"),
                                        actions: [
                                          FlatButton(
                                            child: Text(
                                              "OK",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: iconsColor),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                            const SizedBox(
                              width: 40,
                            ),
                            FlatButton(
                              child: Text(
                                "Cancel",
                                style:
                                    TextStyle(fontSize: 15, color: iconsColor),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  print("Error: ${snapshot.error}");
                  return Text("Error: ${snapshot.error}");
                } else {
                  return const CircularProgressIndicator();
                }
              }),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, int index, String docId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Route"),
          content: const Text("Are you sure you want to delete this route?"),
          actions: <Widget>[
            FlatButton(
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                await RoutesDatabaseServices().deleteRoute(docId);
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text(
                        "Route Deleted",
                        style: TextStyle(color: Colors.red),
                      ),
                      actions: [
                        FlatButton(
                          child: Text(
                            "OK",
                            style: TextStyle(fontSize: 15, color: iconsColor),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            FlatButton(
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final routes = Provider.of<List<Routes>>(context) ?? [];
    _performSearch(routes);

    return Container(
      margin: const EdgeInsets.only(top: 60, bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 6),
            color: bgAccentColor,
            blurRadius: 12,
          ),
        ],
        border: Border.all(color: bgAccentColor, width: .5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(70),
            child: Row(
              children: const [
                SizedBox(
                  width: 10,
                ),
                CustomText(
                  text: "All Routes Available",
                  color: Colors.black,
                  weight: FontWeight.bold,
                ),
                SizedBox(
                  width: 20,
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: NavigationButtonRoutes(
                    text: 'Add Route',
                  ),
                ),
              ],
            ),
          ),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Search',
              hintText: 'Search for a Route',
              prefixIcon: Icon(Icons.search),
              suffixIcon: _searchController.text.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _filteredRoutes = null;
                        });
                      },
                      icon: const Icon(
                        Icons.clear,
                        size: 10,
                      ),
                    ),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                // do something with the new value
                _performSearch(routes);
              });
            },
          ),
          Expanded(
            child: DataTable2(
              columnSpacing: 10,
              horizontalMargin: 12,
              minWidth: 900,
              columns: const [
                DataColumn(
                  label: Text("Bus Name"),
                ),
                DataColumn(
                  label: Text("Starting Point"),
                ),
                DataColumn(
                  label: Text("Destination Point"),
                ),
                DataColumn(
                  label: Text("Interval Distance(KM)"),
                ),
                DataColumn(
                  label: Text("Cost Associations"),
                ),
                DataColumn(
                  label: Text('Edit'),
                ),
                DataColumn(
                  label: Text('Delete'),
                ),
              ],
              rows: _filteredRoutes.map<DataRow>((route) {
                return DataRow(
                  key: UniqueKey(),
                  cells: [
                    DataCell(Text(route.busName)),
                    DataCell(Text(route.startingPoint)),
                    DataCell(Text(route.destinationPoint)),
                    DataCell(Text(route.distanceInKm.toString())),
                    DataCell(Text(route.cost.toString())),
                    DataCell(
                      Tooltip(
                        message: 'Edit Route',
                        child: IconButton(
                          onPressed: () async {
                            String docID =
                                await RoutesDatabaseServices() //using the phone number to get the document ID of a user
                                    .getRouteDocumentId(route.startingPoint,
                                        route.destinationPoint);
                            setState(() {
                              _showEditDialog(
                                  context, routes.indexOf(route), docID);
                            });
                          },
                          icon: Icon(
                            Icons.edit,
                            color: iconsColor,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Tooltip(
                        message: 'Delete Route',
                        child: IconButton(
                          onPressed: () async {
                            String docID = await RoutesDatabaseServices()
                                .getRouteDocumentId(route.startingPoint,
                                    route.destinationPoint);
                            setState(() {
                              _showDeleteDialog(
                                  context, routes.indexOf(route), docID);
                            });
                          },
                          icon: Icon(
                            Icons.delete,
                            color: iconsColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
