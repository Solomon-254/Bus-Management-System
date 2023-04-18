import 'package:bus_management_system/constants/controller.dart';
import 'package:bus_management_system/constants/style.dart';
import 'package:bus_management_system/layout.dart';
import 'package:bus_management_system/models/bus_model.dart';
import 'package:bus_management_system/pages/buses_screens/buses.dart';
import 'package:bus_management_system/pages/onboarding_screen/login.dart';
import 'package:bus_management_system/pages/settings_screens/settings.dart';
import 'package:bus_management_system/routings/routes.dart';
import 'package:bus_management_system/services/auth.dart';
import 'package:bus_management_system/services/bus_database_service.dart';
import 'package:bus_management_system/services/user_database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../widgets/custom_text.dart';

class AddBusesPage extends StatefulWidget {
  const AddBusesPage({Key key}) : super(key: key);

  @override
  State<AddBusesPage> createState() => _AddBusesPageState();
}

class _AddBusesPageState extends State<AddBusesPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _busNameController = TextEditingController();
  final TextEditingController _registrationController = TextEditingController();
  final TextEditingController _plateNumberController = TextEditingController();
  final TextEditingController _assignedDriverController =
      TextEditingController();
//New Additions from client
  final TextEditingController _makemodelController = TextEditingController();
  final TextEditingController _assignedWorkshopManagerController =
      TextEditingController();
  final TextEditingController _yearOfManufactureController =
      TextEditingController();
  final TextEditingController _driverLicenceNumberExpiryController =
      TextEditingController();
  final TextEditingController _roadWorthyExpiryDateController =
      TextEditingController();
  final TextEditingController _licenceDiskExpiryDateController =
      TextEditingController();
  final TextEditingController _serviceIntervalInKmController =
      TextEditingController();
  final TextEditingController _serviceAgentController = TextEditingController();
  final TextEditingController _notescontroller = TextEditingController();

  bool _isLoading = false;
  DateTime _yearofManufacture;
  DateTime _driversLicenceExpiryDate;
  DateTime _busRoadWorthyExpiryDate;
  DateTime _licenceDiskExpiryDate;
  List<String> assignedDriversNamesList = [];
  int yearsDifference;

  final FocusNode _eventDateFocusNode = FocusNode();

  String selectedDriver;
  String selectedWorkshopManager;
  String _selectedDriverLicenceExpiryDate;

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).pop(true);
        });
        return AlertDialog(
          content:
              Text("Bus ${_busNameController.text} successfully registered"),
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
          "Buses Addition",
          style: TextStyle(color: textColor),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Center(
        child: Form(
          key: formKey,
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
                            'Add Bus',
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
                    TextFormField(
                      controller: _busNameController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter Bus Name';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Bus Name",
                        hintText: "City Metro",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _registrationController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter Registration Number';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Registration Number",
                        hintText: "KWX-220-DX",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _plateNumberController,
                      validator: (val) =>
                          val?.length == 0 ? 'Enter Plate Number' : null,
                      decoration: InputDecoration(
                        labelText: "Plate Number",
                        hintText: "SAC-B436",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    FutureBuilder(
                      future: UserDatabaseService().getAssignedDrivers(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<String>> snapshot) {
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator();
                        }

                        return DropdownButtonFormField<String>(
                          value: selectedDriver,
                          decoration: InputDecoration(
                            labelText: 'Assigned Manager',
                            hintText: 'Choose a Assigned Manager',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          hint: Text('Select a driver'),
                          items: snapshot.data.map((String driverName) {
                            return DropdownMenuItem<String>(
                              value: driverName,
                              child: Text(driverName),
                            );
                          }).toList(),
                          onChanged: (String driverName) async {
                            print(
                                'Getting expiry date for driver: $driverName');
                            DateTime expiryDate = await UserDatabaseService()
                                .getDriverLicenceExpiryDate(driverName);

                            print(
                                'Expiry date for driver $driverName: $expiryDate');

                            setState(() {
                              selectedDriver = driverName;
                              _driverLicenceNumberExpiryController.text =
                                  expiryDate.toString();
                              // _selectedDriverLicenceExpiryDate =
                              //     expiryDate.toString();
                            });
                          },
                        );
                      },
                    ),
                    SizedBox(height: 15),
                    if (selectedDriver != null)
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Driver's Licence Expiry",
                          hintText: "24 Apr 2026",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        controller: _driverLicenceNumberExpiryController,
                        enabled: false,
                      ),
                    const SizedBox(
                      height: 15,
                    ),
                    FutureBuilder<List<String>>(
                      future: UserDatabaseService().getWorkshopManagers(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<String> workshopManagers = snapshot.data;

                          return DropdownButtonFormField(
                            value: selectedWorkshopManager,
                            decoration: InputDecoration(
                              labelText: 'Workshop Manager',
                              hintText: 'Choose a Workshop Manager',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            items: workshopManagers.map((manager) {
                              return DropdownMenuItem(
                                value: manager,
                                child: Text(manager),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedWorkshopManager = value;
                              });
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
                    TextFormField(
                      controller: _makemodelController,
                      validator: (val) =>
                          val?.length == 0 ? 'Enter Model/Make of Bus' : null,
                      decoration: InputDecoration(
                        labelText: "Make/Model of Bus",
                        hintText: "Nissan TX 2012",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    InkWell(
                      onTap: () {
                        FocusScope.of(context)
                            .requestFocus(_eventDateFocusNode);
                        _yearOfManufacture(context);
                      },
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please Select Bus Year of Manufacture';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Bus Year of Manufacture',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                        enabled: false,
                        controller: _yearOfManufactureController,
                        focusNode: _eventDateFocusNode,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    InkWell(
                      onTap: () {
                        FocusScope.of(context)
                            .requestFocus(_eventDateFocusNode);
                        _busRoadworthinessExpiryDate(context);
                      },
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter Bus\'s Roadworthy Expiry Date';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Roadworthy\'s Expiry Date',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                        enabled: false,
                        controller: _roadWorthyExpiryDateController,
                        focusNode: _eventDateFocusNode,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    InkWell(
                      onTap: () {
                        FocusScope.of(context)
                            .requestFocus(_eventDateFocusNode);
                        _busLicenceDiskExpiryDate(context);
                      },
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter Licence Disk Expiry Date';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Licence Disk Expiry Date',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                        enabled: false,
                        controller: _licenceDiskExpiryDateController,
                        focusNode: _eventDateFocusNode,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _serviceIntervalInKmController,
                      validator: (val) =>
                          val?.length == 0 ? 'Enter Service Interval ' : null,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                        labelText: "Service Interval in KM",
                        hintText: "5000KM",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _serviceAgentController,
                      validator: (val) =>
                          val?.length == 0 ? 'Enter Service Agent Name' : null,
                      decoration: InputDecoration(
                        labelText: "Service Agent",
                        hintText: "Nelson Bore",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _notescontroller,
                      maxLines: null,
                      decoration: InputDecoration(
                        labelText: "Notes",
                        hintText: "Lorem Ipsum dolor sit amet ",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Notes Cannot be empty';
                        }
                        return null;
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    InkWell(
                      child: Container(
                        child: StatefulBuilder(builder: (context, setState) {
                          return ElevatedButton(
                            onPressed: () async {
                             
                            

                              if (formKey.currentState.validate()) {
                                 setState(() {
                                _isLoading =
                                    true; // set isLoading to true when the button is clicked
                              });

                                String busName = _busNameController.text;
                              String registrationNumber =
                                  _registrationController.text;
                              String plateNumber = _plateNumberController.text;
                              String assignedDriver = selectedDriver;

                              String workshopManager = selectedWorkshopManager;

                              String makeOfCar = _makemodelController.text;
                              DateTime yearOfManufacture = _yearofManufacture;

                              DateTime busRoadWorthyExpiryDate =
                                  _busRoadWorthyExpiryDate;
                              DateTime licenceDiskExpiryDate = DateTime.parse(
                                  _driverLicenceNumberExpiryController.text);

                              String serviceIntervalInKm =
                                  _serviceIntervalInKmController.text + "KM";
                              String serviceAgent =
                                  _serviceAgentController.text;
                              String notes = _notescontroller.text;

                              print(licenceDiskExpiryDate.toString() +
                                  "is the date selected");

                                await BusDatabaseService()
                                    .addBusDataToFirestore(
                                        busName,
                                        registrationNumber,
                                        plateNumber,
                                        assignedDriver,
                                        workshopManager,
                                        makeOfCar,
                                        yearOfManufacture,
                                        licenceDiskExpiryDate,
                                        busRoadWorthyExpiryDate,
                                        licenceDiskExpiryDate,
                                        serviceIntervalInKm,
                                        serviceAgent,
                                        notes);
                                _showSuccessDialog();
                                setState(() {
                                  _isLoading =
                                      false; // set isLoading to false once the operation is completed
                                });

                                //Moves to next page
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BusesPage()));
                                //Adding data to Firestore collection buses

                              }
                            },
                            child: _isLoading
                                ? CircularProgressIndicator()
                                : const Text(
                                    "Save",
                                    style: const TextStyle(
                                      fontSize: 20,
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
                          );
                        }),
                      ),
                    ),
                  ]),
            ),
          ),
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
      lastDate: DateTime.now(),
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
        // Calculate difference in years
        yearsDifference = DateTime.now().year - _yearofManufacture.year;
        print('Difference in years: $yearsDifference');
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
        _driverLicenceNumberExpiryController.text =
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
        _roadWorthyExpiryDateController.text =
            "${_busRoadWorthyExpiryDate.toLocal()}".split(' ')[0];
      });
    }
  }
}

//
