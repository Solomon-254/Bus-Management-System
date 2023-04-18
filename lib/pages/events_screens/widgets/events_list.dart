import 'package:bus_management_system/constants/controller.dart';
import 'package:bus_management_system/models/events_modal.dart';
import 'package:bus_management_system/pages/events_screens/widgets/events_details.dart';
import 'package:bus_management_system/services/events_database_service.dart';
import 'package:bus_management_system/widgets/navigationButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/style.dart';
import '../../../models/users_model.dart';
import '../../../widgets/custom_text.dart';

class EventsList extends StatefulWidget {
  const EventsList({Key key}) : super(key: key);

  @override
  State<EventsList> createState() => _EventsListState();
}

class _EventsListState extends State<EventsList> {
  TextEditingController _searchController = TextEditingController();
  //Implemetation of searching data in the datatable
  List<Events> _filteredEvents = [];
  String busName = "";
  String plateNumber = "";
  bool eventState = false;
  bool isSwitched = false;

  void _performSearch(List<Events> usersList) {
    setState(() {
      _filteredEvents = usersList
          .where((users) =>
              users.busName
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              users.eventType
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              // users.eventDate
              //     .toLowerCase()
              //     .contains(_searchController.text.toLowerCase()) ||
              users.plateNumber
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _filteredEvents = [];
  }

  void _showDeleteDialog(BuildContext context, int index, String docId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Event"),
          content: const Text(
            "Are you sure you want to delete this event?",
            style: TextStyle(color: Colors.red),
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                await EventsDatabaseService().deleteUserData(docId);
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text(
                        "Event Deleted",
                        style: TextStyle(color: Colors.red),
                      ),
                      actions: [
                        FlatButton(
                          child: Text(
                            "OK",
                            style: TextStyle(fontSize: 12, color: iconsColor),
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
    final events = Provider.of<List<Events>>(context) ?? [];
    _performSearch(events);

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
                  text: "All Events Available",
                  color: Colors.black,
                  weight: FontWeight.bold,
                ),
                SizedBox(
                  width: 20,
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: NavigationButtonEvents(
                    text: 'Add Event',
                  ),
                ),
              ],
            ),
          ),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Search',
              hintText: 'Search for an Event',
              prefixIcon: Icon(Icons.search),
              suffixIcon: _searchController.text.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _filteredEvents = null;
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
                _performSearch(events);
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
                  label: Text("Event Type"),
                ),
                DataColumn(
                  label: Text("Event Date"),
                ),
                DataColumn(
                  label: Text("Plate Number"),
                ),
                DataColumn(
                  label: Text('Event Status'),
                ),
                DataColumn(
                  label: Text('Status Update'),
                ),
                DataColumn(
                  label: Text('Delete'),
                ),
                DataColumn(
                  label: Text('Details'),
                ),
              ],
              rows: _filteredEvents.map<DataRow>((event) {
                return DataRow(
                  key: UniqueKey(),
                  cells: [
                    DataCell(Text(event.busName)),
                    DataCell(Text(event.eventType)),
                    DataCell(Text(event.eventDate.toString())),
                    DataCell(Text(event.plateNumber)),
                    DataCell(
                      Text(
                        event.eventStatus,
                        style: TextStyle(
                          color: event.eventStatus == 'Pending'
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),
                    ),
                    DataCell(
                      Tooltip(
                        message: 'Use this switch to change the event status',
                        child: Switch(
                          value: event.eventStatus == 'Completed',
                          onChanged: (value) async {
                            String docID = await EventsDatabaseService()
                                .getEventDocumentId(event.busName);
                            setState(() {
                              if (value) {
                                event.eventStatus = 'Completed';
                                EventsDatabaseService()
                                    .updateEventDataStatus(docID, 'Completed');
                              } else {
                                event.eventStatus = 'Pending';
                                EventsDatabaseService()
                                    .updateEventDataStatus(docID, 'Pending');
                              }
                            });
                          },
                          activeColor: iconsColor,
                          inactiveThumbColor: Colors.red,
                          inactiveTrackColor: Colors.red[100],
                        ),
                      ),
                    ),
                    DataCell(
                      Tooltip(
                        message: 'Delete Event',
                        child: IconButton(
                          onPressed: () async {
                            String docID = await EventsDatabaseService()
                                .getEventDocumentId(event.busName);
                            setState(() {
                              _showDeleteDialog(
                                  context, events.indexOf(event), docID);
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
                        message: 'Event Details',
                        child: IconButton(
                          onPressed: () async {
                            String docID = await EventsDatabaseService()
                                .getEventDocumentId(event.busName);
                            print(docID);
                            print(event.eventStatus);
                            setState(() {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EventsDetailsPage(
                                            busName: event.busName,
                                            plateNumber: event.plateNumber,
                                            companyInvolvedInEvent:
                                                event.companyInvolvedInEvent,
                                            eventDate:
                                                event.eventDate.toString(),
                                            eventDescription:
                                                event.eventDescription,
                                            eventType: event.eventType,
                                            eventVenue: event.eventVenue,
                                            personnelInvolved:
                                                event.personnelInvolvedInEvent,
                                            personnelInvolvedContact: event
                                                .personnelInvolvedInEventContact,
                                            eventStatus: event.eventStatus,
                                            docId: docID,
                                            eventRoute: event.route,
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
