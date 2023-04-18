import 'package:bus_management_system/constants/style.dart';
import 'package:bus_management_system/models/events_modal.dart';
import 'package:bus_management_system/widgets/custom_text.dart';
import 'package:bus_management_system/widgets/navigationButton.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

import '../../../services/events_database_service.dart';
import 'events_details.dart';

class BusAllEventsPage extends StatefulWidget {
  final String plateNumber;
  final String busName;
  final String notificationStatus;
  const BusAllEventsPage(
      {Key key, this.plateNumber, this.busName, this.notificationStatus})
      : super(key: key);

  @override
  State<BusAllEventsPage> createState() => _BusAllEventsPageState();
}

class _BusAllEventsPageState extends State<BusAllEventsPage> {
  List<Events> events = [];
  Stream<List<Events>> _filteredEvents;

  @override
  void initState() {
    _filteredEvents = EventsDatabaseService().getEventsForBus(widget.busName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Padding(
          padding: const EdgeInsets.all(70),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back),
                color: iconsColor,
              ),
              const SizedBox(
                width: 10,
              ),
              CustomText(
                text:
                    "Bus ${widget.busName} with Licence Disk ${widget.plateNumber} Events Available",
                color: Colors.black,
                weight: FontWeight.bold,
              ),
              const SizedBox(
                width: 20,
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<List<Events>>(
              stream: _filteredEvents,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final events = snapshot.data;
                if (events.isEmpty) {
                  return Text('No events for this bus');
                }
                return DataTable2(
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
                      label: Text('Notification Status'),
                    ),
                    DataColumn(
                      label: Text('Event Details'),
                    ),
                  ],
                  rows: events.map<DataRow>((event) {
                    return DataRow(
                      key: UniqueKey(),
                      cells: [
                        DataCell(Text(event.busName)),
                        DataCell(Text(event.eventType)),
                        DataCell(Text(event.eventDate.toString())),
                        DataCell(Text(event.plateNumber)),
                        DataCell(Text(event.eventStatus)),
                        DataCell(
                          IconButton(
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
                                              personnelInvolved: event
                                                  .personnelInvolvedInEvent,
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
                      ],
                    );
                  }).toList(),
                );
              }),
        ),
      ]),
    );
  }
}
