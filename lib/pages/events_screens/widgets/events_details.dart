import 'dart:convert';

import 'package:bus_management_system/constants/style.dart';
import 'package:bus_management_system/models/events_modal.dart';
import 'package:bus_management_system/pages/events_screens/widgets/add_events_details.dart';
import 'package:bus_management_system/services/bus_database_service.dart';
import 'package:bus_management_system/services/events_database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../services/routes_database_service.dart';

class EventsDetailsPage extends StatefulWidget {
  final String busName;
  final String plateNumber;
  final String eventType;
  final String eventDate;
  final String eventVenue;
  final String eventDescription;
  final companyInvolvedInEvent;
  final personnelInvolved;
  final String personnelInvolvedContact;
  final String eventStatus;
  final String docId;
  final String eventRoute;

  const EventsDetailsPage(
      {Key key,
      this.busName,
      this.plateNumber,
      this.eventType,
      this.eventDate,
      this.eventDescription,
      this.companyInvolvedInEvent,
      this.personnelInvolved,
      this.personnelInvolvedContact,
      this.eventVenue,
      this.eventStatus,
      this.docId,
      this.eventRoute})
      : super(key: key);

  @override
  State<EventsDetailsPage> createState() => _EventsDetailsPageState();
}

class _EventsDetailsPageState extends State<EventsDetailsPage> {
  bool isSent = false;
  bool isSwitched = false;
  TextEditingController _eventVenueController;
  TextEditingController _eventDescriptionController;
  TextEditingController _companyInvolvedInEventtController;
  TextEditingController _personnelInvolvedInEventController;
  TextEditingController _personnelInvolvedInEventContactController;
  Future<List<Map<String, dynamic>>> routesListFuture;
  String selectedRoute;
  @override
  void initState() {
    super.initState();
    setState(() {
       routesListFuture = RoutesDatabaseServices().getRoutesFromFirebase();
    });
   
    _eventVenueController = TextEditingController(text: widget.eventVenue);
    _eventDescriptionController =
        TextEditingController(text: widget.eventDescription);
    _companyInvolvedInEventtController =
        TextEditingController(text: widget.companyInvolvedInEvent);
    _personnelInvolvedInEventController =
        TextEditingController(text: widget.personnelInvolved);
    _personnelInvolvedInEventContactController =
        TextEditingController(text: widget.personnelInvolvedContact);
  }

  void showEditDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String eventVenue;
    String eventDescription;
    String companyInvolvedInEvent;
    String personnelInvolvedInEvent;
    String personnelInvolvedInEventContact;
    bool _isLoading = false;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Edit Event Details",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _eventVenueController,
                        decoration: const InputDecoration(
                          labelText: "Event Venue",
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Event Venue cannot be empty";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            eventVenue = value;
                          });
                        },
                      ),
                      TextFormField(
                        maxLines: null,
                        controller: _eventDescriptionController,
                        decoration: const InputDecoration(
                          labelText: "eventDescription",
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Event Description cannot be empty";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            eventDescription = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _companyInvolvedInEventtController,
                        decoration: const InputDecoration(
                          labelText: "Compnay Involved In Event",
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Cannot be empty";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            companyInvolvedInEvent = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _personnelInvolvedInEventController,
                        decoration: const InputDecoration(
                          labelText: "personnel Involved",
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Personnel involved cannot be empty";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            personnelInvolvedInEvent = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _personnelInvolvedInEventContactController,
                        decoration: const InputDecoration(
                          labelText: "Personnel Involved Contact",
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please contact of personnel involved";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            personnelInvolvedInEventContact = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      StatefulBuilder(
                        builder: ((context, setState) {
                          return ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                _isLoading =
                                    true; // set isLoading to true when the button is clicked
                              });

                              if (_formKey.currentState.validate()) {
                                String docID = await EventsDatabaseService()
                                    .getEventDocumentId(widget.busName);
                                // String eventVenue = _eventVenueController.text;
                                // String eventDescription =
                                //     _eventDescriptionController.text;
                                // String companyInvolvedInEvent =
                                //     _companyInvolvedInEventtController.text;
                                // String personnelInvolvedInEvent =
                                //     _personnelInvolvedInEventController.text;
                                // String personnelInvolvedInEventContact =
                                //     _personnelInvolvedInEventContactController
                                //         .text;

                                await EventsDatabaseService(uid: docID)
                                    .updateEventDataDetails(
                                        eventVenue ?? widget.eventVenue,
                                        eventDescription ?? widget.eventDate,
                                        companyInvolvedInEvent ??
                                            widget.companyInvolvedInEvent,
                                        personnelInvolvedInEvent ??
                                            widget.personnelInvolved,
                                        personnelInvolvedInEventContact ??
                                            widget.personnelInvolvedContact);
                                setState(() {
                                  _isLoading =
                                      false; // set isLoading to false once the operation is completed
                                });
                                Navigator.of(context).pop();
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text(
                                          "Updating Event Completed"),
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
                            child: _isLoading
                                ? CircularProgressIndicator()
                                : const Text('Submit'),
                          );
                        }),
                      )
                    ],
                  ),
                )),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    DateTime _completionDateTime;

// When the event is marked as completed, set the completion date and time
    if (widget.eventStatus == 'Completed') {
      _completionDateTime = DateTime.now();
      // Update the 'completedTime' field in the Events collection
      FirebaseFirestore.instance.collection('Events').doc(widget.docId).update({
        'completedTime': _completionDateTime,
      });
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: iconsColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Bus ${widget.busName} Details",
          style: TextStyle(color: textColor),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          Tooltip(
            message: 'Edit Details',
            child: IconButton(
              icon: Icon(
                Icons.edit,
                color: iconsColor,
              ),
              onPressed: () {
                // Handle edit button pressed
                setState(() {
                  showEditDialog(context);
                });
              },
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.place,
                            color: iconsColor,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Event Venue -',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          Text(widget.eventVenue),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.description,
                            color: iconsColor,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          const Text(
                            'Event Description',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            child: Text(widget.eventDescription),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppBar(
                        automaticallyImplyLeading: false,
                        backgroundColor: Colors.white,
                        elevation: 0,
                        title: Row(
                          children: [
                            Icon(
                              Icons.add_road,
                              color: iconsColor,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            const Text(
                              'Routes',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                        actions: [
                          Tooltip(
                            message: 'Edit Route',
                            child: IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: iconsColor,
                              ),
                              onPressed: () {
                                showEditRouteDialog(context);
                                // Perform edit action here
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        'Event Route',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(widget.eventRoute),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.apartment,
                            color: iconsColor,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          const Text(
                            'Company Involved In Event -',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(widget.companyInvolvedInEvent),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: iconsColor,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Personnel Involved/Assigned to Event - ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          Text(widget.personnelInvolved),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            color: iconsColor,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Contact of Personnel Asigned to Event -',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          Text(widget.personnelInvolvedContact.toString()),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.place,
                            color: iconsColor,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Event Status -',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          Text(widget.eventStatus),
                          SizedBox(
                            width: 40,
                            child: Visibility(
                              visible: true,
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: widget.eventStatus == 'Pending'
                                      ? Colors.red
                                      : Colors.green,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showEditRouteDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String route;
    bool _isLoading = false;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Edit Route",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 16),
                      FutureBuilder<List<Map<String, dynamic>>>(
                        future: routesListFuture,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<Map<String, dynamic>> routesList =
                                snapshot.data;

                            return DropdownButtonFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please Select Event Route';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText: 'Event Route',
                                  hintText: widget.eventRoute,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              items: routesList.map((route) {
                                return DropdownMenuItem(
                                  value: route,
                                  child: Text(route['route']),
                                );
                              }).toList(),
                              onChanged: (value) {
                                selectedRoute = jsonEncode(value);
                                print(selectedRoute + "is the selected route");
                                // Do something with the selected value
                              },
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      StatefulBuilder(
                        builder: ((context, setState) {
                          return ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                _isLoading =
                                    true; // set isLoading to true when the button is clicked
                              });

                              if (_formKey.currentState.validate()) {
                                String docID = await EventsDatabaseService()
                                    .getEventDocumentId(widget.busName);
                                //update the  old route
                                await EventsDatabaseService(uid: docID)
                                    .updateEventRouteDataDetails(selectedRoute);

                                setState(() {
                                  _isLoading =
                                      false; // set isLoading to false once the operation is completed
                                });
                                Navigator.of(context).pop();
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title:
                                          const Text("Editing Route Completed"),
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
                            child: _isLoading
                                ? CircularProgressIndicator()
                                : const Text('Submit'),
                          );
                        }),
                      )
                    ],
                  ),
                )),
          );
        });
  }
}
