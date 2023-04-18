import 'package:bus_management_system/constants/style.dart';
import 'package:bus_management_system/pages/events_screens/events.dart';
import 'package:bus_management_system/pages/events_screens/widgets/events_details.dart';
import 'package:bus_management_system/pages/events_screens/widgets/events_list.dart';
import 'package:bus_management_system/services/events_database_service.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddEventsDetailsPage extends StatefulWidget {
  final String busName;
  const AddEventsDetailsPage({Key key, this.busName}) : super(key: key);

  @override
  State<AddEventsDetailsPage> createState() => _AddEventsDetailsPageState();
}

class _AddEventsDetailsPageState extends State<AddEventsDetailsPage> {
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController eventVenueController = TextEditingController();
  TextEditingController eventDescriptionController = TextEditingController();
  TextEditingController companyInvolvedController = TextEditingController();
  TextEditingController personnelInvolvedController = TextEditingController();
  TextEditingController personnelContactController = TextEditingController();
  String _selectedCountryCode;

  //Dialog for success state
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).pop(true);
        });
        return AlertDialog(
          content: Text(
              "Event at ${eventVenueController.text} successfully registered"),
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
          "Add Event Details",
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
                          'Add/Edit Event Details',
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
                    controller: eventVenueController,
                    validator: (val) =>
                        val?.length == 0 ? 'Please Enter Event Venue' : null,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    child: Container(
                      child: ElevatedButton(
                        onPressed: () async {
                          String eventVenue = eventVenueController.text;
                          String eventDescription =
                              eventDescriptionController.text;
                          String companyInvolved =
                              companyInvolvedController.text;
                          String personnelInvolved =
                              personnelInvolvedController.text;
                          String personnelContact =
                              personnelContactController.text;
                          // String docID = await EventsDatabaseService()
                          //     .getEventDocumentId(widget.);

                          if (formKey.currentState.validate()) {
                            //Moves to next page
                            // await EventsDatabaseService()
                            //     .addEventsDetailsDataToFirestore(
                            //         eventVenue,
                            //         eventDescription,
                            //         companyInvolved,
                            //         personnelInvolved,
                            //         docID,
                            //         personnelContact);
                            _showSuccessDialog();
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EventsPage()));

                            setState(() {
                              _isLoading = true;
                            });

                            setState(() {
                              _isLoading = false;
                            });
                          }
                        },
                        child: _isLoading
                            ? CircularProgressIndicator()
                            : const Tooltip(
                                message:
                                    'Please note that only details of events can be edited, counter check your entires before adding this event',
                                child: Text(
                                  "Add",
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
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
