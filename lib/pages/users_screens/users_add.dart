import 'package:bus_management_system/constants/style.dart';
import 'package:bus_management_system/pages/users_screens/users.dart';
import 'package:bus_management_system/services/user_database_service.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AddUsersPage extends StatefulWidget {
  const AddUsersPage({Key key}) : super(key: key);
  @override
  _AddUsersPageState createState() => _AddUsersPageState();
}

class _AddUsersPageState extends State<AddUsersPage> {
  String _selectedRole;
  final _formKey = GlobalKey<FormState>();

  String _selectedCountryCode = '+27';
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final FocusNode _eventDateFocusNode = FocusNode();

  final TextEditingController _driverLicenceNumberExpiryController =
      TextEditingController();
  DateTime driversLicenceExpiryDate;
  bool _isLoading = false;

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).pop(true);
        });
        return AlertDialog(
          content: Text("User successfully registered"),
        );
      },
    );
  }

  // @override
  // void initState() {
  //   super.initState();
  // }

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
            "Users Addition",
            style: TextStyle(color: textColor),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
              child: Form(
                  key: _formKey,
                  child: Container(
                      constraints: const BoxConstraints(
                        maxWidth: 400,
                      ),
                      padding: const EdgeInsets.all(24),
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
                                    'Add User',
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
                              controller: _fullNameController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter User Full Name';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: "Full Name",
                                hintText: "Festus Solomon",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter user email address';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: "Email Address",
                                hintText: "Festus@gmail.com",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              controller: _phoneNumberController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter user phone Number';
                                }
                                return null;
                              },
                               inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly],
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                labelText: "Phone Number",
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
                            DropdownButtonFormField(
                              value: _selectedRole,
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedRole = newValue;
                                });
                              },
                              decoration: InputDecoration(
                                labelText: 'Select Role',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select a role';
                                }
                                return null;
                              },
                              items: <String>[
                                'Workshop Manager',
                                'Driver',
                                'Normal User'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            InkWell(
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(_eventDateFocusNode);
                                _driverLicenceExpiryDate(context);
                              },
                              child: TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Enter Driver\'s Licence Expiry';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    labelText: 'Driver\'s Licence Expiry Date',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                enabled: false,
                                controller:
                                    _driverLicenceNumberExpiryController,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            InkWell(
                              child: Container(
                                  child: ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    //code for adding data to the firebase
                                    setState(() {
                                      _isLoading =
                                          true; // set isLoading to true when the button is clicked
                                    });
                                    String fullName = _fullNameController.text;
                                    String emailAddress = _emailController.text;
                                    String phoneNumber = _selectedCountryCode+
                                        _phoneNumberController.text;
                                    String selectedRole = _selectedRole;
                                    DateTime licenceExpiryDate =
                                        driversLicenceExpiryDate;
                                    print(fullName);
                                    print(emailAddress);
                                    print(phoneNumber);
                                    print(selectedRole);
                                    print(licenceExpiryDate);
                                    print(_selectedCountryCode);

                                    await UserDatabaseService()
                                        .addUserDataToFirestore(
                                            fullName,
                                            emailAddress,
                                            phoneNumber,
                                            selectedRole,
                                            licenceExpiryDate);
                                    _showSuccessDialog();
                                    setState(() {
                                      _isLoading =
                                          false; // set isLoading to false once the operation is completed
                                    });
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => UsersPage()));
                                  }
                                },
                                child: _isLoading
                                    ? CircularProgressIndicator()
                                    : const Text(
                                        "Add",
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
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                ),
                              )),
                            ),
                          ])))),
        ));
  }

  //selecting drivers licence expiry date
  Future<void> _driverLicenceExpiryDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: driversLicenceExpiryDate ?? DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));

    if (picked != null && picked != driversLicenceExpiryDate) {
      setState(() {
        driversLicenceExpiryDate = picked;
        // Get the user's timezone offset from UTC
        final offset = DateTime.now().timeZoneOffset;
        // Create a new DateTime object with the user's timezone offset
        final dateTimeLocal = driversLicenceExpiryDate.add(offset);
        // Update text field with formatted date string
        _driverLicenceNumberExpiryController.text =
            "${dateTimeLocal.toLocal()}".split(' ')[0];
      });
    }
  }
}
