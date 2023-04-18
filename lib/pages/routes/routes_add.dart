import 'package:bus_management_system/constants/style.dart';
import 'package:bus_management_system/pages/routes/routes.dart';
import 'package:bus_management_system/pages/routes/routes_list.dart';
import 'package:bus_management_system/services/routes_database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/bus_model.dart';
import '../../services/bus_database_service.dart';

class AddRoutesPage extends StatefulWidget {
  const AddRoutesPage({Key key}) : super(key: key);

  @override
  State<AddRoutesPage> createState() => _AddRoutesPageState();
}

class _AddRoutesPageState extends State<AddRoutesPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController intervalDistanceInKmController =
      TextEditingController();
  final busNametextController = TextEditingController();
  TextEditingController stratingPointController = TextEditingController();
  TextEditingController routeCostController = TextEditingController();
  TextEditingController destinationPointController = TextEditingController();

  final List<String> suggestions = [];
  String selectedBusName;

  List<String> busFilteredSuggestions = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    busNametextController.addListener(() {
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
  }

  //Dialog for successfully addition of event to the collection
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text("User saved successfully."),
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
          "Routes Addition",
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
                                  'Add Route',
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
                                      setState(() {
                                        selectedBusName = busName;

                                        ;
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
                          TextFormField(
                            controller: stratingPointController,
                            validator: (val) => val?.length == 0
                                ? 'Please Enter Starting Venue'
                                : null,
                            decoration: InputDecoration(
                              labelText: "Starting Point",
                              hintText: "Durban",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: destinationPointController,
                            validator: (val) => val?.length == 0
                                ? 'Please enter Destination Point'
                                : null,
                            decoration: InputDecoration(
                              labelText: "Destination Point",
                              hintText: "Soweto",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: intervalDistanceInKmController,
                            validator: (val) => val?.length == 0
                                ? 'Enter Distance Interval  '
                                : null,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              labelText: "Distance Interval in KM",
                              hintText: "60000KM",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: routeCostController,
                            validator: (val) =>
                                val?.length == 0 ? 'Enter Route Cost  ' : null,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              labelText: "Route Cost",
                              hintText: "57800 SA Rand",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    isLoading =
                                        true; // set isLoading to true when the button is clicked
                                  });
                                  String busName = selectedBusName;
                                  String startingPoint =
                                      stratingPointController.text;
                                  String destinationPoint =
                                      destinationPointController.text;
                                  double distanceInKm = double.parse(
                                      intervalDistanceInKmController.text);

                                  double cost =
                                      double.parse(routeCostController.text);

                                  await RoutesDatabaseServices()
                                      .addRoutesToFirebase(
                                          busName,
                                          startingPoint,
                                          destinationPoint,
                                          distanceInKm,
                                          cost);

                                  _showSuccessDialog();
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AllRoutesManager()));
                                  setState(() {
                                    isLoading =
                                        false; // set isLoading to false once the operation is completed
                                  });
                                }
                              },
                              child: isLoading
                                  ? const CircularProgressIndicator()
                                  : const Text(
                                      "Save",
                                      style: TextStyle(
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
                            ),
                          ),
                        ]),
                  ))),
        ),
      ),
    );
  }
}
