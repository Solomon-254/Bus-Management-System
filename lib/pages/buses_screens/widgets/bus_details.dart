import 'dart:async';
import 'dart:convert';

import 'package:bus_management_system/constants/style.dart';
import 'package:bus_management_system/services/bus_database_service.dart';
import 'package:bus_management_system/services/routes_database_service.dart';
import 'package:flutter/material.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
import 'package:http/http.dart' as http;

class BusDetailsPage extends StatefulWidget {
  final String busName;
  final String workshopManager;
  final String makeOfBus;
  final String serviceAgent;
  final String serviceIntervalInKm;
  final DateTime yearOfManufacture;
  final DateTime driversLicenceExpiryDate;
  final DateTime licenceDiskExpiryDate;
  final DateTime busRoadWorthinessExpiryDate;
  final String assignedDriver;
  final String licenceDisk;
  final String notes;

  const BusDetailsPage(
      {Key key,
      this.busName,
      this.workshopManager,
      this.makeOfBus,
      this.serviceAgent,
      this.serviceIntervalInKm,
      this.yearOfManufacture,
      this.driversLicenceExpiryDate,
      this.licenceDiskExpiryDate,
      this.busRoadWorthinessExpiryDate,
      this.assignedDriver,
      this.licenceDisk,
      this.notes})
      : super(key: key);

  @override
  State<BusDetailsPage> createState() => _BusDetailsPageState();
}

class _BusDetailsPageState extends State<BusDetailsPage> {
  bool _isEditing = false;

  TextEditingController _workshopManagerController;
  TextEditingController _makeOfBusController;
  TextEditingController _serviceAgentController;
  TextEditingController _serviceIntervalInKmController;
  TextEditingController _yearOfManufactureController;
  TextEditingController _driversLicenceExpiryDateController;
  TextEditingController _licenceDiskExpiryDateController;
  TextEditingController _busRoadWorthinessExpiryDateController;
  TextEditingController busNotesController;

  DateTime _yearofManufacture;
  DateTime _driversLicenceExpiryDate;
  DateTime _busRoadWorthyExpiryDate;
  DateTime _licenceDiskExpiryDate;

  DateTime givenDate;
  DateTime currentDate;
  Duration difference;
  int differenceInYears;

  bool isLoading = false;
  bool isSmsSent = false;
  String phoneNumber =
      'Verified phone number for client recieving messages from an api ';

//TEST VARIABLES FOR SMS TWILIO IMPLEMENTATION
  final twilioFlutter = TwilioFlutter(
      accountSid: 'ACcd02f43e099f0a0315585d9c8e7a9583',
      authToken: 'd068fa6f49937c10aeaa32a6eb8d923b',
      twilioNumber: '+15075688355');

  String licencemessage1;
  String licencemessage2;

  String driverlicencemessage1;
  String driverlicencemessage2;

  String roadworthinesslicencemessage1;
  String roadworthinesslicencemessage2;

//DEPLOYMENT VAIALBLES FOR SENDING SMS
  // String customisedLicenceDiskExpiryMessage1 = '';
  // String customisedroadWorthinessExpiryMessage1 = '';
  // String customisedDriversLicenceExpiryMessage1 = '';

  // String customisedLicenceDiskExpiryMessage2 = '';
  // String customisedroadWorthinessExpiryMessage2 = '';
  // String customisedDriversLicenceExpiryMessage2 = '';

// VAIALBLES FOR SENDING EMAIL TESTING
  final apiKey =
      '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';
  final toEmail = 'soloowfestus@gmail.com';
  // final expiryDateUtc = DateTime.utc(
  //     2023, 4, 9, 9, 34, 0); // Replace with your expiry date and time in UTC

//VARIABLES FOR CLIENT PREFERENCE
  // final apiKeyLive = 'TWILIO API KEY';
  // final toClientEmail = 'Client Email Address';

//routes for list for a specific bus
  List<Map<String, dynamic>> routes = [];

  Future<void> loadRoutes() async {
    List<Map<String, dynamic>> routes =
        await RoutesDatabaseServices().getRoutesByPlateNumber(widget.busName);
    setState(() {
      this.routes = routes;
    });
  }

  @override
  void initState() {
    super.initState();
    loadRoutes();

    givenDate = DateTime.parse(widget.yearOfManufacture.toString());
    currentDate = DateTime.now();
    difference = currentDate.difference(givenDate);
    differenceInYears = (difference.inDays / 365).floor();

    //TESTS FOR BUS AGE SMS SENDING

    // sendSmsReminder('+254796779568', widget.busName, differenceInYears,
    //     widget.serviceIntervalInKm);

    //TESTS FOR SENDING EMAILS AFTER EVERY 1MINUTE for TESTING Purposes

    // startSendingCustomEmails(apiKey, toEmail, widget.busName, differenceInYears,
    //     widget.serviceIntervalInKm, widget.licenceDisk);

    //DEPLOYMENT CODE FOR SMS SENDING AFTER EVERY 5YEARS

    //  sendSmsReminder(phoneNumber, widget.busName, differenceInYears,
    // widget.serviceIntervalInKm);

    //DEPLOYMENT CODE FOR SENDING EMAILS AFTER EVERY 5 YEARS

    //  startSendingCustomEmails(apiKey, toEmail, widget.busName, differenceInYears,
    //     widget.serviceIntervalInKm, widget.licenceDisk);

    //-------------------TESTS
    licencemessage1 =
        'Dear Admin, bus ${widget.busName} of ${widget.makeOfBus} with a licence plate of ${widget.licenceDisk} expires in exactly 2 minutes time. Please renew!! \nAlgoa Bus Inc ';
    licencemessage2 =
        'Dear Admin, bus ${widget.busName} of ${widget.makeOfBus} with a licence plate of ${widget.licenceDisk} expires in exactly 1 minute time. Please renew!! \n--Algoa Bus Inc  ';
    sendSmsNotification(
        '+254796779568',
        DateTime.utc(2023, 4, 9, 13, 44, 0), //UTC IS 3 HOURS AHEAD OF EAT
        licencemessage1,
        licencemessage2); //testing apis purposes

    driverlicencemessage1 =
        'Dear Admin, driver ${widget.assignedDriver} of bus ${widget.busName} driver\'s expires in exactly 2 minutes time. Please alert the driver to renew!! \nAlgoa Bus Inc ';
    driverlicencemessage1 =
        'Dear Admin, driver ${widget.assignedDriver} of bus ${widget.busName} driver\'s expires in exactly 1 minutes time. Please alert the driver to renew!! \nAlgoa Bus Inc ';
    sendSmsNotification('+254796779568', DateTime.utc(2023, 4, 9, 13, 44, 0),
        driverlicencemessage1, driverlicencemessage2); //testing apis purposes

    roadworthinesslicencemessage1 =
        'Dear Admin, bus ${widget.busName} of licence ${widget.licenceDisk} road worthiness licence expires in exactly 2 minutes time. Please renew!! \nAlgoa Bus Inc ';
    roadworthinesslicencemessage2 =
        'Dear Admin, bus ${widget.busName} of licence ${widget.licenceDisk} road worthiness licence expires in exactly 1 minute time. Please renew!! \nAlgoa Bus Inc ';
    sendSmsNotification(
        '+254796779568',
        DateTime.utc(2023, 4, 9, 13, 43, 0),
        roadworthinesslicencemessage1,
        roadworthinesslicencemessage2); //testing apis purposes

    //---------*******************EMAIL SENDING
    //TESTS

    DateTime expiryDate = DateTime(2023, 4, 9, 16, 50,
        0); // Replace with your actual expiry date in your timezone eg EAT
    DateTime now = DateTime.now();

    if (expiryDate.isAfter(now)) {
      _sendEmail(apiKey, toEmail, expiryDate);
    } else {
      print("Expiry has elapsed. Cannot send email.");
      //-----------------------------------------------------------------------------------Testing Completed
    }

//---------------------------------------------Customised Implementation using TWILIO SMS API

    // sendSmsNotificationforExpiry(
    //     phoneNumber,
    //     widget.licenceDiskExpiryDate, // deploying
    //     customisedLicenceDiskExpiryMessage1,
    //     customisedDriversLicenceExpiryMessage2); //SMS notification for licence disk expiry
    // print(widget.licenceDiskExpiryDate);

    // sendSmsNotificationforExpiry(
    //     phoneNumber,
    //     widget.busRoadWorthinessExpiryDate,
    //     customisedroadWorthinessExpiryMessage1,
    //     customisedroadWorthinessExpiryMessage2); //SMS notification for roadworthiness expiry
    // print(widget.busRoadWorthinessExpiryDate);

    // sendSmsNotificationforExpiry(
    //     phoneNumber,
    //     widget.driversLicenceExpiryDate,
    //     customisedDriversLicenceExpiryMessage1,
    //     customisedDriversLicenceExpiryMessage2); //SMS notification for drivers licence expiry
    // print(widget.driversLicenceExpiryDate);

    //--------------------------------------------------------------TWILIO SENDGRID FOR EMAIL SENDING API
    //*---------------------------------------- Deployment Email Sending Implimentation

//1. Licence disk Expiry
//     DateTime now = DateTime.now();
//     String message =
//         '<p>Dear <strong>Admin</strong>! Bus ${widget.busName} of make ${widget.makeOfBus}\'s licence expires in on ${widget.licenceDiskExpiryDate}. Please renew. <br> Algoa Buses Inc</p>';

//     if (widget.licenceDiskExpiryDate.isAfter(now)) {
//       _sendEmail(
//           apiKeyLive, toClientEmail, widget.licenceDiskExpiryDate, message);
//       print(widget.licenceDiskExpiryDate);
//     } else {
//       print("Expiry has elapsed. Cannot send email.");
//     }
// //2. Bus Road worthiness Expiry
//     String messageRoadWorthiness =
//         '<p>Dear <strong>Admin</strong>! Bus ${widget.busName} of make ${widget.makeOfBus}\'s roadworthiness licence expires on ${widget.busRoadWorthinessExpiryDate}. Please renew. <br> Algoa Buses Inc</p>';
//     DateTime nowRoadworthiness = DateTime.now();
//     if (widget.busRoadWorthinessExpiryDate.isAfter(nowRoadworthiness)) {
//       _sendEmail(apiKeyLive, toClientEmail, widget.busRoadWorthinessExpiryDate,
//           messageRoadWorthiness);
//       print(widget.licenceDiskExpiryDate);
//     } else {
//       print("Expiry has elapsed. Cannot send email.");
//     }

// //3. Driver's licence expiry
//     DateTime nowDriversLicence = DateTime.now();
//     String messagesDriverLicenceExpiry =
//         '<p>Dear <strong>Admin</strong>! Driver ${widget.assignedDriver} of bus ${widget.busName}\'s driving licence expires on ${widget.driversLicenceExpiryDate}. Please alert him to renew ASAP. <br> Algoa Buses Inc</p>';
//     if (widget.licenceDiskExpiryDate.isAfter(nowDriversLicence)) {
//       _sendEmail(apiKeyLive, toClientEmail, widget.driversLicenceExpiryDate,
//           messagesDriverLicenceExpiry);
//       print(widget.driversLicenceExpiryDate);
//     } else {
//       print("Expiry has elapsed. Cannot send email.");
//     }

    _workshopManagerController =
        TextEditingController(text: widget.workshopManager);
    _makeOfBusController = TextEditingController(text: widget.makeOfBus);
    _serviceAgentController = TextEditingController(text: widget.serviceAgent);
    _serviceIntervalInKmController =
        TextEditingController(text: widget.serviceIntervalInKm);
    _yearOfManufactureController =
        TextEditingController(text: widget.yearOfManufacture.toString());
    _driversLicenceExpiryDateController =
        TextEditingController(text: widget.driversLicenceExpiryDate.toString());
    _licenceDiskExpiryDateController =
        TextEditingController(text: widget.licenceDiskExpiryDate.toString());
    _busRoadWorthinessExpiryDateController = TextEditingController(
        text: widget.busRoadWorthinessExpiryDate.toString());
    busNotesController = TextEditingController(text: widget.notes);
  }

  //dialog
  void showEditDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final FocusNode _yearOfManufactureDateFocusNode = FocusNode();
    final FocusNode _driversLicenceexpiryDateFocusNode = FocusNode();
    final FocusNode _licenceDiskExpiryFocusNode = FocusNode();
    final FocusNode _roadworthinessExpiryDateFocusNode = FocusNode();
    String workshopManager;
    String makeOfBus;
    String serviceAgent;
    String serviceIntervaldistaneInKm;
    DateTime yearOfManufacture;
    DateTime driversLicenceExpiryDate;
    DateTime licenceDiskExpiryDate;
    DateTime busRoadWorthinessExpiryDate;
    String notes;
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
                        "Edit Bus Details",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _workshopManagerController,
                        decoration: const InputDecoration(
                          labelText: "Workshop Manager",
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter Workshop Manager";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            workshopManager = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _makeOfBusController,
                        decoration: const InputDecoration(
                          labelText: "Make of Bus",
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter Make of Bus";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            makeOfBus = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _serviceAgentController,
                        decoration: const InputDecoration(
                          labelText: "Service Agent",
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter Service Agent";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            serviceAgent = value;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: busNotesController,
                        maxLines: null,
                        decoration: const InputDecoration(
                          labelText: "Notes",
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Notes cannot be empty";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            notes = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _serviceIntervalInKmController,
                        decoration: const InputDecoration(
                          labelText: "Service Interval in Distance(KM)",
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter Service Interval in Distance";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            serviceIntervaldistaneInKm = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _yearOfManufactureController,
                        focusNode: _yearOfManufactureDateFocusNode,
                        decoration: const InputDecoration(
                          labelText: "Year of Manufacture",
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter Year of Manufacture";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _yearOfManufactureController.text = value;
                          });
                        },
                        onTap: () {
                          FocusScope.of(context)
                              .requestFocus(_yearOfManufactureDateFocusNode);
                          _yearOfManufacture(context);

                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _driversLicenceExpiryDateController,
                        focusNode: _driversLicenceexpiryDateFocusNode,
                        decoration: const InputDecoration(
                          labelText: "Driver's License Expiry Date",
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter Driver's License Expiry Date";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _driversLicenceExpiryDateController.text = value;
                          });
                        },
                        onTap: () {
                          FocusScope.of(context)
                              .requestFocus(_driversLicenceexpiryDateFocusNode);
                          _driverLicenceExpiryDate(context);
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        focusNode: _licenceDiskExpiryFocusNode,
                        controller: _licenceDiskExpiryDateController,
                        decoration: const InputDecoration(
                          labelText: " License Disk Expiry Date",
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter License Disk Expiry Date";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _licenceDiskExpiryDateController.text = value;
                          });
                        },
                        onTap: () {
                          FocusScope.of(context)
                              .requestFocus(_licenceDiskExpiryFocusNode);
                          _busLicenceDiskExpiryDate(context);
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        focusNode: _roadworthinessExpiryDateFocusNode,
                        controller: _busRoadWorthinessExpiryDateController,
                        decoration: const InputDecoration(
                          labelText: "Bus Roadworthiness Expiry Date",
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter Bus Roadworthiness Expiry Date";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _busRoadWorthinessExpiryDateController.text = value;
                          });
                        },
                        onTap: () {
                          FocusScope.of(context)
                              .requestFocus(_roadworthinessExpiryDateFocusNode);
                          _busRoadworthinessExpiryDate(context);
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
                                print(_yearOfManufactureController.text);
                                print(_driversLicenceExpiryDateController.text);
                                print(_licenceDiskExpiryDateController.text);
                                print(_busRoadWorthinessExpiryDateController
                                    .text);
                                String docID = await BusDatabaseService()
                                    .getBusDocumentId(widget.busName);
                                DateTime yearofManufacture = DateTime.parse(
                                    _yearOfManufactureController.text);
                                DateTime driversLicenceExpiryDate =
                                    DateTime.parse(
                                        _driversLicenceExpiryDateController
                                            .text);

                                DateTime busRoadWorthyExpiryDate =
                                    DateTime.parse(
                                        _busRoadWorthinessExpiryDateController
                                            .text);

                                DateTime licenceDiskExpiryDate = DateTime.parse(
                                    _licenceDiskExpiryDateController.text);
                                String busNotes = busNotesController.text;

                                await BusDatabaseService(uid: docID)
                                    .updateBusDataDetails(
                                        workshopManager ??
                                            widget.workshopManager,
                                        makeOfBus ?? widget.makeOfBus,
                                        serviceAgent ?? widget.serviceAgent,
                                        serviceIntervaldistaneInKm ??
                                            widget.serviceIntervalInKm,
                                        yearofManufacture ??
                                            widget.yearOfManufacture,
                                        driversLicenceExpiryDate ??
                                            widget.driversLicenceExpiryDate,
                                        licenceDiskExpiryDate ??
                                            widget.licenceDiskExpiryDate,
                                        busRoadWorthyExpiryDate ??
                                            widget.busRoadWorthinessExpiryDate,
                                        busNotes);
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
                                          const Text("Updating Bus Completed"),
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
            message: 'Upload Documents and Images',
            child: IconButton(
              icon: Icon(
                Icons.file_upload,
                color: iconsColor,
              ),
              onPressed: () {
                // Handle upload button pressed
              },
            ),
          ),
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
                            Icons.person,
                            color: iconsColor,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Workshop Manager -',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(widget.workshopManager),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.merge_type,
                            color: iconsColor,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Make of Bus - ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          Text(widget.makeOfBus),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.support_agent,
                            color: iconsColor,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Service Agent -',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          Text(widget.serviceAgent),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.social_distance,
                            color: iconsColor,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Service Interval in Distance - ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          Text(widget.serviceIntervalInKm),
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
                            Icons.calendar_today,
                            color: iconsColor,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          const Text(
                            'Year of Manufacture -',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(widget.yearOfManufacture.toString()),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.date_range,
                            color: iconsColor,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Driver\'s License Expiry Date - ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          Text(widget.driversLicenceExpiryDate.toString()),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_month_rounded,
                            color: iconsColor,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'License Disk Expiry Date -',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          Text(widget.licenceDiskExpiryDate.toString()),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: iconsColor,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Bus Roadworthiness Expiry Date - ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          Text(widget.busRoadWorthinessExpiryDate.toString()),
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
                            Icons.add_road,
                            color: iconsColor,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          const Text(
                            'Routes',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        '${widget.busName} Routes',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      if (routes.isEmpty) // Show message if no routes found
                        Text(
                            'No routes found for ${widget.busName} with plate number ${widget.licenceDisk}.')
                      else // Show list of routes
                        ...routes.map((route) => Text('${route['route']}')),
                      Container(
                        child: Row(
                          children: [
                            Text(
                              'Download ${widget.busName} Images and Documents',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Tooltip(
                              message:
                                  'Download ${widget.busName} images and documents',
                              child: IconButton(
                                icon: Icon(
                                  Icons.download,
                                  color: iconsColor,
                                ),
                                onPressed: () {
                                  // Handle upload button pressed
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
//--------------------
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
                            Icons.note,
                            color: iconsColor,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          const Text(
                            'Notes',
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
                            child: Text(widget.notes),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),

//-----

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.notifications,
                              color: iconsColor,
                            ),
                            const Text(
                              'Notifications Status(green-sent | grey-pending)',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              color: iconsColor,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              'Age of Bus - $differenceInYears Years',
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.document_scanner_outlined,
                              color: iconsColor,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              'Bus ${widget.busName} Licence Disk Expiry -',
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            SizedBox(
                              width: 40,
                              child: Visibility(
                                visible: true,
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        isSmsSent ? Colors.green : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.edit_road_outlined,
                              color: iconsColor,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              'Bus ${widget.busName} Road Worthiness Expiry -',
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            SizedBox(
                              width: 40,
                              child: Visibility(
                                visible: true,
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        isSmsSent ? Colors.green : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.edit_road_outlined,
                              color: iconsColor,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              'Driver ${widget.assignedDriver} \' Licence Expiry - ',
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            SizedBox(
                              width: 40,
                              child: Visibility(
                                visible: true,
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        isSmsSent ? Colors.green : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //function for a years only datatime picker
  Future<void> _yearOfManufacture(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1960),
      firstDate: DateTime(1960),
      lastDate: DateTime(DateTime.now().year),
    );

    if (picked != null && picked != _yearofManufacture) {
      setState(() {
        _yearofManufacture = picked;
        // Get the user's timezone offset from UTC
        final offset = DateTime.now().timeZoneOffset;
        // Create a new DateTime object with the user's timezone offset
        final dateTimeLocal = _yearofManufacture.add(offset);
        // Update text field with formatted date string
        _yearOfManufactureController.text =
            "${dateTimeLocal.toLocal()}".split(' ')[0];
      });
    }
  }

  //selecting drivers licence expiry date
  Future<void> _driverLicenceExpiryDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _driversLicenceExpiryDate ?? DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));

    if (picked != null && picked != _driversLicenceExpiryDate) {
      setState(() {
        _driversLicenceExpiryDate = picked;
        // Get the user's timezone offset from UTC
        final offset = DateTime.now().timeZoneOffset;
        // Create a new DateTime object with the user's timezone offset
        final dateTimeLocal = _driversLicenceExpiryDate.add(offset);
        // Update text field with formatted date string
        _driversLicenceExpiryDateController.text =
            "${dateTimeLocal.toLocal()}".split(' ')[0];
      });
    }
  }

  //licence disc of bus expiry date
  Future<void> _busLicenceDiskExpiryDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _licenceDiskExpiryDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      locale: Localizations.localeOf(context),
    );
    if (picked != null && picked != _licenceDiskExpiryDate) {
      setState(() {
        _licenceDiskExpiryDate = picked;
        _licenceDiskExpiryDateController.text =
            "${_licenceDiskExpiryDate.toLocal()}".split(' ')[0];
      });
    }
  }

  //Bus roadworthuness on the road expiry date
  Future<void> _busRoadworthinessExpiryDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _busRoadWorthyExpiryDate ?? DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null && picked != _busRoadWorthyExpiryDate) {
      setState(() {
        _busRoadWorthyExpiryDate = picked;
        _busRoadWorthinessExpiryDateController.text =
            "${_busRoadWorthyExpiryDate.toLocal()}".split(' ')[0];
      });
    }
  }

//Twilio sending SMS for expiry
//Sending sms notification for 2 weeks and one month before expiry
  // Future<void> sendSmsNotificationforExpiry(String phoneNumber,
  //     DateTime expiryDate, String message1, message2) async {
  //   final expiryTimestamp = expiryDate.millisecondsSinceEpoch;
  //   final now = DateTime.now().millisecondsSinceEpoch;
  //   final timeDiff = expiryTimestamp - now;

  //   if (timeDiff <= 0) {
  //     print('Expiry date has already passed.');
  //     return;
  //   }

  //   final twoWeeksBefore = Duration(
  //       milliseconds: expiryTimestamp - Duration(days: 14).inMilliseconds);
  //   final oneMonthBefore = Duration(
  //       milliseconds: expiryTimestamp - Duration(days: 30).inMilliseconds);

  //   Timer(twoWeeksBefore, () async {
  //     try {
  //       final result = await twilioFlutter.sendSMS(
  //           toNumber: phoneNumber, messageBody: message1
  //           // 'Dear Admin, bus ${widget.busName} of service agent  ${widget.serviceAgent}  expires in 2 weeks time. Please renew!! ',
  //           );
  //       print(result);
  //       setState(() {
  //         isSmsSentforDiskExpiry = true;
  //         isSmsSentforRoadWorthinessExpiry = true;
  //         isSmsSentDriverLicenceExpiry = true;
  //       });
  //     } catch (e) {
  //       print(e.toString());
  //     }
  //   });

  //   Timer(oneMonthBefore, () async {
  //     try {
  //       final result = await twilioFlutter.sendSMS(
  //           toNumber: phoneNumber, messageBody: message2
  //           // 'Dear Admin, bus ${widget.busName} of service agent  ${widget.serviceAgent}  expires in 1 month time. Please renew!! ',
  //           );

  //       print(result);
  //       setState(() {
  //         isSmsSentforDiskExpiry = true;
  //         isSmsSentforRoadWorthinessExpiry = true;
  //         isSmsSentDriverLicenceExpiry = true;
  //       });
  //     } catch (e) {
  //       print(e.toString());
  //     }
  //   });
  // }

  //*************************************************************************************** */
  // Here below is for testing puroses, sending sms in 2 and 1 minute ebfore deadline.

  Future<void> sendSmsNotification(String phoneNumber, DateTime expiryDate,
      String message1, String message2) async {
    final expiryTimestamp = expiryDate.millisecondsSinceEpoch;
    final now = DateTime.now().millisecondsSinceEpoch;
    final timeDiff = expiryTimestamp - now;

    if (timeDiff <= 0) {
      print('Expiry date has already passed.Cannot send SMS.');
      return;
    }

    final twoMinutesBefore = Duration(milliseconds: timeDiff - 2 * 60 * 1000);
    final oneMinuteBefore = Duration(milliseconds: timeDiff - 1 * 60 * 1000);

    Timer(twoMinutesBefore, () async {
      try {
        final result = await twilioFlutter.sendSMS(
            toNumber: phoneNumber, messageBody: message1
            // 'Dear Admin, bus ${widget.busName} of service agent  ${widget.serviceAgent}  expires in exactly 2 minutes time. Please renew!! ',
            );
        print(result);
        setState(() {
          isSmsSent = true;
        });
      } catch (e) {
        print(e.toString());
      }
    });

    Timer(oneMinuteBefore, () async {
      try {
        final result = await twilioFlutter.sendSMS(
            toNumber: phoneNumber, messageBody: message2
            // 'Dear Admin, bus ${widget.busName} of service agent  ${widget.serviceAgent}  expires in exactly 1 minutes time. Please renew!!. Please renew!! ',
            );

        print(result);
        setState(() {
          isSmsSent = true;
        });
      } catch (e) {
        print(e.toString());
      }
    });
  }

  //Sending email for purposes of testing

  Future<void> _sendEmail(
      String apiKey, String toEmail, DateTime expiryDate) async {
    if (expiryDate.isBefore(DateTime.now())) {
      print('Expiry date has passed. Email not sent.');
      return;
    }

    final url = Uri.parse(
        'https://cors-anywhere.herokuapp.com/https://api.sendgrid.com/v3/mail/send'); // <-- modified URL

    final headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
      'X-Requested-With': 'XMLHttpRequest', // <-- added header
    };

    final body = {
      'personalizations': [
        {
          'to': [
            {'email': '$toEmail'}
          ],
          'subject': 'Bus System Notification',
        }
      ],
      'from': {'email': 'soloowfestus@gmail.com'},
      'content': [
        {
          'type': 'text/html',
          'value':
              '<p>Dear <strong>Admin</strong>! Bus ${widget.busName} of make ${widget.makeOfBus}\'s licence expires in 2 weeks time on ${widget.licenceDiskExpiryDate}. Please renew. <br> Algoa Buses Inc</p>'
        }
      ],
    };

    final expiryTime = expiryDate.subtract(Duration(minutes: 2));
    final reminder1Time = expiryDate.subtract(Duration(minutes: 1));

    try {
      // Send email 2 minutes before expiry

      await Future.delayed(expiryTime.difference(DateTime.now()), () async {
        if (expiryDate.isBefore(DateTime.now())) {
          print('Expiry date has passed. Email not sent.');
          return;
        }

        final response =
            await http.post(url, headers: headers, body: jsonEncode(body));
        if (response.statusCode == 202) {
          print('Email sent 2 minutes before expiry.');
        } else {
          throw Exception(
              'Failed to send email. Status code: ${response.statusCode}');
        }
      });

      // Send email 1 minute before expiry

      await Future.delayed(reminder1Time.difference(DateTime.now()), () async {
        if (expiryDate.isBefore(DateTime.now())) {
          print('Expiry date has passed. Email not sent.');
          setState(() {
            isSmsSent = true;
          });
          return;
        }

        final response =
            await http.post(url, headers: headers, body: jsonEncode(body));
        if (response.statusCode == 202) {
          print('Email sent 1 minute before expiry.');
          setState(() {
            isSmsSent = true;
          });
        } else {
          throw Exception(
              'Failed to send email. Status code: ${response.statusCode}');
        }
      });
    } catch (e) {
      print(e);
    }
  }

  // Actual Implementations of sending an email based on cliets needs

  // Future<void> _sendEmail(String apiKey, String toEmail, DateTime expiryDate,
  //     String message) async {
  //   if (expiryDate.isBefore(DateTime.now())) {
  //     print('Expiry date has passed. Email not sent.');
  //     return;
  //   }

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
  //       {
  //         'type': 'text/html',
  //         'value': message
  //         // '<p>Dear <strong>Admin</strong>! Bus ${widget.busName} of make ${widget.makeOfBus}\'s licence expires in 2 weeks time on ${widget.licenceDiskExpiryDate}. Please renew. <br> Algoa Buses Inc</p>'
  //       }
  //     ],
  //   };

  //   final expiryTime = expiryDate.subtract(Duration(days: 30));
  //   final reminder1Time = expiryDate.subtract(Duration(days: 14));

  //   try {
  //     // Send email 1 month before expiry
  //     await Future.delayed(expiryTime.difference(DateTime.now()), () async {
  //       if (expiryDate.isBefore(DateTime.now())) {
  //         print('Expiry date has passed. Email not sent.');
  //         return;
  //       }

  //       final response =
  //           await http.post(url, headers: headers, body: jsonEncode(body));
  //       if (response.statusCode == 202) {
  //         print('Email sent 1 month before expiry.');
  //       } else {
  //         throw Exception(
  //             'Failed to send email. Status code: ${response.statusCode}');
  //       }
  //     });

  //     // Send email 2 weeks before expiry
  //     await Future.delayed(reminder1Time.difference(DateTime.now()), () async {
  //       if (expiryDate.isBefore(DateTime.now())) {
  //         print('Expiry date has passed. Email not sent.');
  //         return;
  //       }

  //       final response =
  //           await http.post(url, headers: headers, body: jsonEncode(body));
  //       if (response.statusCode == 202) {
  //         print('Email sent 2 weeks before expiry.');
  //         setState(() {
  //           isEmailSentDriverLicenceExpiry = true;
  //           isEmailSentforDiskExpiry = true;
  //           isEmailSentforRoadWorthinessExpiry = true;
  //         });
  //       } else {
  //         throw Exception(
  //             'Failed to send email. Status code: ${response.statusCode}');
  //       }
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }

//**------------------------------------------------------------------- */

  //sending sms notification based on expiry of bus after every 1 minute for testing purposes.

  Future<void> sendSmsReminder(String phoneNumber, String busName, int age,
      String serviceInterval) async {
    final String message =
        'Dear Admin, Bus $busName has an age of $age Years. Please ensure that the bus undergoes service after every $serviceInterval. Thank you. \nAlgoa Bus Inc';
    Timer.periodic(Duration(minutes: 1), (timer) async {
      try {
        final result = await twilioFlutter.sendSMS(
            toNumber: phoneNumber, messageBody: message);
        print('SMS sent: $result');
      } catch (e) {
        print('Error sending SMS: $e');
      }
    });
  }

  //Deployment code for sending message after evry 5 years regarding the age of the bus

//   Future<void> sendSmsReminderForEvery5Years(String phoneNumber, String busName, int age, String serviceInterval) async {
//   final message = 'Dear Admin, Bus $busName has an age of $age years. Please ensure that the bus undergoes service after every $serviceInterval. Thank you. \nAlgoa Bus Inc';

//   Timer.periodic(Duration(seconds: 5 * 365 * 24 * 60 * 60), (timer) async {
//     try {
//       final result = await twilioFlutter.sendSMS(toNumber: phoneNumber, messageBody: message);
//       print('SMS sent: $result');
//     } catch (e) {
//       print('Error sending SMS: $e');
//     }
//   });
// }

//sending emails afre every 1 minute on bus age for testing purposes

  void sendCustomEmail(String apiKey, String toEmail, String busName, int age,
      String serviceIntervalInKm, String licenceDisk) async {
    final url = Uri.parse(
        'https://cors-anywhere.herokuapp.com/https://api.sendgrid.com/v3/mail/send');

    final headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
    };

    final body = {
      'personalizations': [
        {
          'to': [
            {'email': '$toEmail'}
          ],
          'subject': 'Bus System Notification',
        }
      ],
      'from': {'email': 'soloowfestus@gmail.com'},
      'content': [
        {
          'type': 'text/html',
          'value':
              '<p>Dear <strong>Admin,</strong><br> Bus $busName of licence disk number $licenceDisk. has an age of <strong>$age</strong> years. Please ensure that it undergoes service after every $serviceIntervalInKm KM. Thank you.<br> Algoa Buses Inc</p>'
        }
      ],
    };

    try {
      final response =
          await http.post(url, headers: headers, body: jsonEncode(body));
      if (response.statusCode == 202) {
        print('Email sent.');
      } else {
        throw Exception(
            'Failed to send email. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
  }

  void startSendingCustomEmails(String apiKey, String toEmail, String busName,
      int age, String serviceIntervalInKm, String licenceDisk) {
    Timer.periodic(Duration(minutes: 1), (timer) {
      sendCustomEmail(
          apiKey, toEmail, busName, age, serviceIntervalInKm, licenceDisk);
    });
  }

//SENDING EMAIL AFTER EVERY 5 YEARS FOR DEPLOYING.

  // void startSendingCustomEmailsEvery5Years(String apiKey, String toEmail, String busName,
  //     int age, String serviceIntervalInKm, String licenceDisk) {
  //   Timer.periodic(Duration(days: 1825), (timer) { // 1825 days = 5 years

  //       sendCustomEmail(
  //           apiKey, toEmail, busName, age, serviceIntervalInKm, licenceDisk);
  //   });
}
