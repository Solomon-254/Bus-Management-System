import 'package:bus_management_system/constants/style.dart';
import 'package:bus_management_system/pages/events_screens/events.dart';
import 'package:bus_management_system/services/events_database_service.dart';
import 'package:bus_management_system/services/routes_database_service.dart';
import 'package:bus_management_system/services/user_database_service.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

import '../../models/bus_model.dart';
import '../../services/bus_database_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddEventsPage extends StatefulWidget {
  const AddEventsPage({Key key}) : super(key: key);

  @override
  State<AddEventsPage> createState() => _AddEventsPageState();
}

class _AddEventsPageState extends State<AddEventsPage> {
  // String _busName;
  String _eventType = 'services';

  // String _eventDate;
  // String _notificationStatus;
  DateTime _dateTime;
  final FocusNode _eventDateFocusNode = FocusNode();
  bool _isLoading = false;
  String selectedBusName;
  String licenceDiskSelected;

  final _formKey = GlobalKey<FormState>();
  final _eventDateController = TextEditingController();
  // final TextEditingController _busNameController = TextEditingController();
  final TextEditingController _eventTypeController = TextEditingController();
  final TextEditingController _notificationStatusController =
      TextEditingController();

  final busNametextController = TextEditingController();
  final plateNumbertextController = TextEditingController();
  TextEditingController eventVenueController = TextEditingController();
  TextEditingController eventDescriptionController = TextEditingController();
  TextEditingController companyInvolvedController = TextEditingController();
  TextEditingController personnelInvolvedController = TextEditingController();
  TextEditingController personnelContactController = TextEditingController();
  String _selectedCountryCode = '+27';

  final List<String> suggestions = [];

  List<String> busFilteredSuggestions = [];
  List<String> plateNumberbusFilteredSuggestions = [];

  bool eventsState = false;
  String eventStatus = 'Pending';
  Future<List<Map<String, dynamic>>> routesListFuture;
  String selectedRoute;

  @override
  void initState() {
    super.initState();
    routesListFuture = RoutesDatabaseServices().getRoutesFromFirebase();

    busNametextController.addListener(() {
      filterSuggestions(busNametextController.text);
    });

    plateNumbertextController.addListener(() {
      filterSuggestions(busNametextController.text);
    });
  }

  void filterSuggestions(String query) {
    setState(() {
      busFilteredSuggestions = suggestions
          .where((suggestion) =>
              suggestion.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });

    setState(() {
      plateNumberbusFilteredSuggestions = suggestions
          .where((suggestion) =>
              suggestion.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  //loading the routes

  //Dialog for successfully addition of event to the collection
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text("Event saved successfully."),
          actions: [
            TextButton(
              child: Text("OK"),
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
          "Events Addition",
          style: TextStyle(color: textColor),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: 400,
                  ),
                  padding: const EdgeInsets.all(24),
                  child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 15,
                          ),
                          Row(
                            children: [
                              Expanded(child: Container()),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: [
                              Center(
                                child: Text(
                                  'Add Event',
                                  style: GoogleFonts.roboto(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Column(
                            children: [
                              StreamBuilder<List<Bus>>(
                                stream: BusDatabaseService().buses,
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const SizedBox.shrink();
                                  }
                                  List<String> busNames = snapshot.data
                                      .map((bus) => bus.busName)
                                      .toList();
                                  return DropdownButtonFormField<String>(
                                    value: selectedBusName,
                                    items: busNames
                                        .map((String busName) =>
                                            DropdownMenuItem<String>(
                                                value: busName,
                                                child: Text(busName)))
                                        .toList(),
                                    onChanged: (String busName) async {
                                      String licenceDisk =
                                          await BusDatabaseService()
                                              .getBusLicenceDisk(busName);
                                      setState(() {
                                        selectedBusName = busName;
                                        plateNumbertextController.text =
                                            licenceDisk;
                                        print(licenceDiskSelected);
                                      });
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Bus Name',
                                      hintText: 'City Metro',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          if (selectedBusName != null)
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: "Licence Disk",
                                hintText: "GGSK-FHFH",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              controller: plateNumbertextController,
                              enabled: false,
                            ),
                          const SizedBox(
                            height: 15,
                          ),
                          DropdownButtonFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please Select Event Type';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                labelText: 'Event Type',
                                hintText: 'Choose an event type',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            value: _eventType,
                            items: ['services', 'accidents', 'others']
                                .map((eventType) => DropdownMenuItem(
                                      value: eventType,
                                      child: Text(eventType),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _eventType = value;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
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
                                      hintText: 'Choose an event route',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  items: routesList.map((route) {
                                    return DropdownMenuItem(
                                      value: route,
                                      child: Text(route['route']),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    selectedRoute = jsonEncode(value);
                                    print(selectedRoute +
                                        "is the selected route");
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
                          const SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            onTap: () {
                              FocusScope.of(context)
                                  .requestFocus(_eventDateFocusNode);
                              _selectDate(context);
                            },
                            child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please Select Event Date';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText: 'Event Date',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              enabled: false,
                              controller: _eventDateController,
                              focusNode: _eventDateFocusNode,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: eventVenueController,
                            validator: (val) => val?.length == 0
                                ? 'Please Enter Event Venue'
                                : null,
                            decoration: InputDecoration(
                              labelText: "Event Venue",
                              hintText: "Durban",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextField(
                            controller: eventDescriptionController,
                            maxLines: null,
                            decoration: InputDecoration(
                              labelText: "Event Description",
                              hintText: "Lorem Ipsum dolor sit amet ",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: companyInvolvedController,
                            validator: (val) => val?.length == 0
                                ? 'Please enter Company Involved'
                                : null,
                            decoration: InputDecoration(
                              labelText: "Company Involved In Event",
                              hintText: "Nissan Motors",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: personnelInvolvedController,
                            validator: (val) => val?.length == 0
                                ? 'Please enter Personnel Involved Name'
                                : null,
                            decoration: InputDecoration(
                              labelText: "Personnel Involved",
                              hintText: "Nelson Bore",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: personnelContactController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter personnel phone Number';
                              }
                              return null;
                            },
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: "Personnel Contact",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              prefix: Container(
                                  child: CountryCodePicker(
                                onChanged: (code) {
                                  setState(() {
                                    _selectedCountryCode = code.dialCode;
                                  });
                                },
                                initialSelection: 'ZA',
                                favorite: ['+27', 'ZA'],
                                textStyle: TextStyle(fontSize: 16),
                                showCountryOnly: false,
                                showOnlyCountryWhenClosed: false,
                                alignLeft: false,
                              )),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  String busName = selectedBusName;
                                  String eventType = _eventType;
                                  DateTime eventDate = _dateTime;
                                  String plateNumber =
                                      plateNumbertextController.text;
                                  String eventVenue = eventVenueController.text;
                                  String eventDescription =
                                      eventDescriptionController.text;
                                  String companyInvolved =
                                      companyInvolvedController.text;
                                  String personnelInvolved =
                                      personnelInvolvedController.text;
                                  String personnelContact =
                                      _selectedCountryCode +
                                          personnelContactController.text;
                                  String route = selectedRoute;

                                  await EventsDatabaseService()
                                      .addEventsDataToFirestore(
                                          busName,
                                          eventType,
                                          route,
                                          eventDate,
                                          plateNumber,
                                          eventVenue,
                                          eventDescription,
                                          companyInvolved,
                                          personnelInvolved,
                                          personnelContact,
                                          eventStatus);
                                  String phoneNumber = '+254796779568';
                                  const apiKey =
                                      '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';
                                  final toEmail = 'soloowfestus@gmail.com';

                                  //SMS notification messages
                                  String smsMessage1 =
                                      'Dear admin, bus $busName has been involved in an $eventType on $eventDate while on $route route. \n Contact $companyInvolved to fix that ASAP. Ensure to Update the status of the event once the issue is resolved \n Algoa Bus Inc  ';
                                  String smsMessage2 =
                                      'Dear admin, bus $busName is due $eventType on $eventDate. \n Contact $companyInvolved to fix that ASAP. Ensure to Update the status of the event once the issue is resolved \n Algoa Bus Inc  ';
                                  //email notification messages
                                   String emailMessage1 =
                                      '<p>Dear admin, bus <strong>$busName</strong> has been invloved in an $eventType on $eventDate while on $route route. <br>Contact $companyInvolved to fix that ASAP. <br>Kindly Ensure to update the status of the event once the issue is resolved. <br>Algoa Bus Inc </p>';
                                  String emailMessage2 =
                                      '<p>Dear admin, bus <strong>$busName</strong> is due $eventType on $eventDate. <br>Contact $companyInvolved to fix that ASAP. <br>Ensure to Update the status of the event once the issue is resolved. <br> Algoa Bus Inc </p>' ;

                                 
                                  if (eventType == 'services') {
                                    // await sendSmsNotification(
                                    //     //send sms
                                    //     phoneNumber,
                                    //     smsMessage2,
                                    //     eventType,
                                    //     companyInvolved,
                                    //     eventDate,
                                    //     busName);
                                    //send email notification using sendgrid api
                                    // await _sendEmail(
                                    //     apiKey,
                                    //     toEmail,
                                    //     emailMessage2,
                                    //     eventType,
                                    //     companyInvolved,
                                    //     eventDate,
                                    //     busName);
                                    await EventsDatabaseService()
                                        .addNotificationDataToFirestore(
                                             emailMessage2, smsMessage2);
                                  } else if (eventType == 'accidents') {
                                    // await sendSmsNotification(
                                    //     phoneNumber,
                                    //     smsMessage1,
                                    //     eventType,
                                    //     companyInvolved,
                                    //     eventDate,
                                    //     busName);
                                    //send email for accidents
                                    // await _sendEmail(
                                    //     apiKey,
                                    //     toEmail,
                                    //     emailMessage1,
                                    //     eventType,
                                    //     companyInvolved,
                                    //     eventDate,
                                    //     busName);
                                    await EventsDatabaseService()
                                        .addNotificationDataToFirestore(
                                            emailMessage1, smsMessage1);
                                  } else {
                                    print('Other event has been choosen');
                                  }

                                  _showSuccessDialog();
                                  setState(() {
                                    _isLoading = false;
                                  });

                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EventsPage()));

                                  //for every event send a notifications using
                                  //1. TWILIO SMS API
                                  //2. TWILIO SENDGRID API

                                }
                              },
                              child: Tooltip(
                                message:
                                    'Note that you can only edit the details of an event, please ensure that the information entereed is accurate!!',
                                child: _isLoading
                                    ? const CircularProgressIndicator()
                                    : const Text(
                                        "Save",
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: iconsColor,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 150,
                                  vertical: 17,
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                              ),
                            ),
                          ),
                        ]),
                  ))),
        ),
      ),
    );
  }

 Future<void> _selectDate(BuildContext context) async {
  final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _dateTime ?? DateTime(2000),
      firstDate: DateTime(2000),
      lastDate: DateTime.now());
  if (picked != null && picked != _dateTime) {
    setState(() {
      _dateTime = picked;
      _eventDateController.text = "${_dateTime.toLocal()}".split(' ')[0];
    });
  }
}



  //send SMS for events
  // final twilioFlutter = TwilioFlutter(
  //     accountSid: 'ACcd02f43e099f0a0315585d9c8e7a9583',
  //     authToken: 'd068fa6f49937c10aeaa32a6eb8d923b',
  //     twilioNumber: '+15075688355');

  // Future<void> sendSmsNotification(
  //     String phoneNumber,
  //     String message,
  //     String eventType,
  //     String companyInvolved,
  //     DateTime eventDate,
  //     String busName) async {
  //   try {
  //     final result = await twilioFlutter.sendSMS(
  //         toNumber: phoneNumber, messageBody: message);
  //     print(result);
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  // //sending email
  // Future<void> _sendEmail(
  //     String apiKey,
  //     String toEmail,
  //     String message,
  //     String eventType,
  //     String companyInvolved,
  //     DateTime eventDate,
  //     String busName) async {
  //   final url = Uri.parse(
  //       'https://cors-anywhere.herokuapp.com/https://api.sendgrid.com/v3/mail/send'); // <-- modified URL

  //   final headers = {
  //     'Authorization': 'Bearer $apiKey',
  //     'Content-Type': 'application/json',
  //     'X-Requested-With': 'XMLHttpRequest', // <-- added header
  //   };

  //   final body = {
  //     'personalizations': [
  //       {
  //         'to': [
  //           {'email': '$toEmail'}
  //         ],
  //         'subject': 'Bus System Notification',
  //       }
  //     ],
  //     'from': {'email': 'soloowfestus@gmail.com'},
  //     'content': [
  //       {'type': 'text/html', 'value': message}
  //     ],
  //   };

  //   try {
  //     final response =
  //         await http.post(url, headers: headers, body: jsonEncode(body));
  //     if (response.statusCode == 202) {
  //       print('Email sent successfully.');
  //     } else {
  //       throw Exception(
  //           'Failed to send email. Status code: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}
