// ignore_for_file: deprecated_member_use

import 'package:bus_management_system/constants/style.dart';
import 'package:bus_management_system/models/bus_model.dart';
import 'package:bus_management_system/models/user_model.dart';
import 'package:bus_management_system/pages/buses_screens/widgets/bus_details.dart';
import 'package:bus_management_system/pages/events_screens/widgets/view_all_bus_events.dart';
import 'package:bus_management_system/services/bus_database_service.dart';
import 'package:bus_management_system/services/events_database_service.dart';
import 'package:bus_management_system/widgets/custom_text.dart';
import 'package:bus_management_system/widgets/navigationButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BusList extends StatefulWidget {
  final List<Bus> busesList;

  const BusList({
    Key key,
    this.busesList = const <Bus>[],
  }) : super(key: key);

  @override
  State<BusList> createState() => _BusListState();
}

class _BusListState extends State<BusList> {
  TextEditingController _searchController = TextEditingController();
  //Implemetation of searching data in the datatable
  List<Bus> _filteredBuses = [];

  void _performSearch(List<Bus> busList) {
    setState(() {
      _filteredBuses = busList
          .where((bus) =>
              bus.busName
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              bus.registrationNumber
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              bus.plateNumber
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              bus.assignedDriver
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _filteredBuses = [];
  }
  // -----

//Updating entities
  void _showEditDialog(BuildContext context, int index, String docId) {
    final formKey = GlobalKey<FormState>();
    String busName;
    String licenceNumber;
    String plateNumber;
    String assignedDriver;
    bool _isLoading = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Bus"),
          content: StreamBuilder<BusUserData>(
              stream: BusDatabaseService().getUserData(docId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  BusUserData busUserData = snapshot.data;

                  return Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextFormField(
                          initialValue: busUserData.busName,
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
                          initialValue: busUserData.licenceNumber,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'This field cannot be empty';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              labelText: 'Licence Number'),
                          onChanged: (value) {
                            setState(() {
                              licenceNumber = value;
                            });
                          },
                        ),
                        TextFormField(
                          initialValue: busUserData.plateNumber,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'This field cannot be empty';
                            }
                            return null;
                          },
                          decoration:
                              const InputDecoration(labelText: 'Plate Number'),
                          onChanged: (value) {
                            setState(() {
                              plateNumber = value;
                            });
                          },
                        ),
                        TextFormField(
                          initialValue: busUserData.assignedDriver,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'This field cannot be empty';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              labelText: 'Assigned Driver'),
                          onChanged: (value) {
                            setState(() {
                              assignedDriver = value;
                            });
                          },
                        ),
                        Row(
                          children: [
                            FlatButton(
                              child: _isLoading
                                  ? const CircularProgressIndicator(
                                      strokeWidth: 1.0,
                                    )
                                  : Text(
                                      "Save",
                                      style: TextStyle(
                                          fontSize: 15, color: iconsColor),
                                    ),
                              onPressed: () async {
                                //Updating data in the firestore
                                if (formKey.currentState.validate()) {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  await BusDatabaseService(uid: docId)
                                      .updateBusData(
                                          busName ?? busUserData.busName,
                                          licenceNumber ??
                                              busUserData.licenceNumber,
                                          plateNumber ??
                                              busUserData.plateNumber,
                                          assignedDriver ??
                                              busUserData.assignedDriver);
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  Navigator.of(context).pop();
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text(
                                            "Updating Bus Completed"),
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
          title: const Text("Delete Bus"),
          content: const Text("Are you sure you want to delete this bus?"),
          actions: <Widget>[
            FlatButton(
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                await BusDatabaseService().deleteBusData(docId);
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text(
                        "Bus Deleted",
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
    final buses = Provider.of<List<Bus>>(context) ?? [];
    _performSearch(buses);

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
                  text: "All Buses Available",
                  color: Colors.black,
                  weight: FontWeight.bold,
                ),
                SizedBox(
                  width: 40,
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: NavigationButton(
                    text: 'Add Bus',
                  ),
                ),
              ],
            ),
          ),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Search',
              hintText: 'Search for a bus',
              prefixIcon: Icon(Icons.search),
              suffixIcon: _searchController.text.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _filteredBuses = null;
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
                _performSearch(buses);
              });
            },
          ),
          Expanded(
            child: DataTable2(
              columnSpacing: 10,
              horizontalMargin: 18,
              minWidth: 900,
              columns: const [
                DataColumn(
                  label: Text("Bus Name"),
                ),
                DataColumn(
                  label: Text("Reg Number"),
                ),
                DataColumn(
                  label: Text("Licence Disk"),
                ),
                DataColumn(
                  label: Text("Assigned Driver"),
                ),
                DataColumn(
                  label: Text('Edit'),
                ),
                DataColumn(
                  label: Text('Delete'),
                ),
                DataColumn(
                  label: Text('View Bus Events'),
                ),
                DataColumn(
                  label: Text('Bus Details'),
                ),
              ],
              rows: _filteredBuses.map<DataRow>((bus) {
                return DataRow(
                  key: UniqueKey(),
                  cells: [
                    DataCell(Text(bus.busName)),
                    DataCell(Text(bus.registrationNumber)),
                    DataCell(Text(bus.plateNumber)),
                    DataCell(Text(bus.assignedDriver)),
                    DataCell(
                      Tooltip(
                        message: 'Edit Bus',
                        child: IconButton(
                          onPressed: () async {
                            String docID = await BusDatabaseService()
                                .getBusDocumentId(bus.busName);
                            setState(() {
                              _showEditDialog(
                                  context, buses.indexOf(bus), docID);
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
                        message: 'Delete Bus',
                        child: IconButton(
                          onPressed: () async {
                            String docID = await BusDatabaseService()
                                .getBusDocumentId(bus.busName);
                            setState(() {
                              _showDeleteDialog(context,
                                  widget.busesList.indexOf(bus), docID);
                            });
                          },
                          icon: Icon(
                            Icons.delete,
                            color: iconsColor,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Tooltip(
                        message: 'View Bus Events',
                        child: IconButton(
                          onPressed: () async {
                            setState(() {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BusAllEventsPage(
                                            plateNumber: bus.plateNumber,
                                            busName: bus.busName,
                                          )));
                            });
                          },
                          icon: Icon(
                            Icons.remove_red_eye_outlined,
                            color: iconsColor,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Tooltip(
                        message: 'View Bus Details',
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BusDetailsPage(
                                            busName: bus.busName,
                                            workshopManager:
                                                bus.workshopManager,
                                            makeOfBus: bus.makeOfBus,
                                            serviceAgent: bus.serviceAgent,
                                            serviceIntervalInKm:
                                                bus.serviceIntervaldistaneInKm,
                                            yearOfManufacture:
                                                bus.yearOfManufacture,
                                            driversLicenceExpiryDate:
                                                bus.driversLicenceExpiryDate,
                                            licenceDiskExpiryDate:
                                                bus.licenceDiskExpiryDate,
                                            busRoadWorthinessExpiryDate:
                                                bus.busRoadWorthinessExpiryDate,
                                            assignedDriver: bus.assignedDriver,
                                            licenceDisk: bus.plateNumber,
                                            notes: bus.notes,
                                          )));
                            });
                          },
                          icon: Icon(
                            Icons.more_horiz_outlined,
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
