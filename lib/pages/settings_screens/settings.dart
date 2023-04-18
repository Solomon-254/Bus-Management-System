import 'dart:convert';
import 'package:bus_management_system/constants/style.dart';
import 'package:bus_management_system/services/auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mailer/mailer.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
import '../../constants/controller.dart';
import '../../helpers/responsivenes.dart';
import '../../widgets/custom_text.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _notificationMode = 0;
  final settingsFormKey = GlobalKey<FormState>();
  TextEditingController fullNameController;
  TextEditingController phoneNumberController;
  TextEditingController roleController;
  TextEditingController emailController;
  TextEditingController passwordController;
  String fullName;
  String emailAddress;
  String phoneNumber;
  String role;
  String password;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController();
    phoneNumberController = TextEditingController();
    roleController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

// //functionality to implement notifications sending
//1.Create an instance of the Twilio class and
// pass your account SID and authentication token as parameters to the constructor:

//sending SMS notification using twilio API
// ignore: missing_required_param
  final twilioFlutter = TwilioFlutter(
      accountSid: 'AC635ac4bd9505b3f52d9ff8ad94d73ba6',
      authToken: '39200070badd09315473933ebd6eca28',
      twilioNumber: '+15855356484');

  // Future<void> sendSmsNotification(String phoneNumber) async {
  //   try {
  //     final result = await twilioFlutter.sendSMS(
  //       toNumber: phoneNumber,
  //       messageBody:
  //           'Dear Nelson, bus with plate number KWX321-98YU is due licensing in 2 weeks.',
  //     );
  //     print(result);
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

//sending email notifications using twilio sendgrid API
  // Future<void> _sendEmail(String apiKey, String toEmail) async {
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
  //         'value':
  //             '<p>Hello from <strong>Flutter</strong>! This is an email from the SendGrid API. If you are seeing this, the cors issue has been fixed</p>'
  //       }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Settings",
          style: TextStyle(color: textColor),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: ListView(
        children: <Widget>[
          Card(
            elevation: 5,
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ListTile(
              title: const Text("Account Settings"),
              trailing: Tooltip(
                message:
                    'Note that you can only edit the full name and phone number only.',
                child: Icon(
                  Icons.edit,
                  color: iconsColor,
                ),
              ),
              onTap: () async {
                AuthService auth = AuthService();
                String uid = await auth.getCurrentUserId();
                Map<String, dynamic> userData = await auth.getUserData(uid);
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Update Profile Account"),
                      content: Form(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            TextFormField(
                              // controller: fullNameController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'This field cannot be empty';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                  labelText: 'Full Names'),
                              enabled: true,
                              initialValue: userData['fullName'] ??
                                  '', //initial value for logged in user
                              onChanged: (value) {
                                setState(() {
                                  fullNameController.text = value;
                                });
                              },
                            ),
                            TextFormField(
                              // controller: roleController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'This field cannot be empty';
                                }
                                return null;
                              },
                              decoration:
                                  const InputDecoration(labelText: 'Role'),
                              enabled: false,
                              initialValue: userData['role'] ??
                                  '', //initial value for logged in user
                              onChanged: (value) {
                                setState(() {
                                  roleController.text = value;
                                });
                              },
                            ),
                            TextFormField(
                              // controller: phoneNumberController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'This field cannot be empty';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                  labelText: 'Phone Number'),
                              enabled: true,
                              initialValue: userData['phoneNumber'] ??
                                  '', //initial value for logged in user
                              onChanged: (value) {
                                setState(() {
                                  phoneNumberController.text = value;
                                });
                              },
                            ),
                            TextFormField(
                              // controller: emailController,
                              decoration: const InputDecoration(
                                  labelText: 'Email Address'),
                              enabled: false,
                              initialValue: userData['email'] ??
                                  '', //initial value for logged in user
                              onChanged: (value) {
                                setState(() {
                                  emailController.text = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: const Text('Update'),
                          onPressed: () async {
                            // Call the updateUserData function with the updated data
                            await auth.updateUserData(uid, {
                              'fullName': fullNameController.text.trim(),
                              'phoneNumber': phoneNumberController.text.trim(),
                              'role': roleController.text.trim(),
                              'email': emailController.text.trim(),
                            });

                            Navigator.of(context).pop();
                            _showSuccessDialog();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          Card(
            elevation: 5,
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ListTile(
              key: UniqueKey(),
              title: const Text("Events and Notifications"),
              trailing: Icon(
                Icons.event,
                color: iconsColor,
              ),
              onTap: () async {
                AuthService auth = AuthService();
                String uid = await auth.getCurrentUserId();
                Map<String, dynamic> userData = await auth.getUserData(uid);
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Notification Channels"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Text(
                              "The following details will receive notifications:"),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(
                                Icons.phone,
                                color: iconsColor,
                              ),
                              SizedBox(width: 10),
                              Text("Phone number: ${userData['phoneNumber']}"),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(
                                Icons.email,
                                color: iconsColor,
                              ),
                              SizedBox(width: 10),
                              Text("Email address: ${userData['email']}"),
                            ],
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        ElevatedButton(
                          child: const Text('OK'),
                          onPressed: () async {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                  },
                );
              },
            ),
          ),
          Card(
            elevation: 5,
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ListTile(
              title: const Text("Privacy Terms"),
              trailing: Icon(
                Icons.security,
                color: iconsColor,
              ),
              onTap: () {
                // Navigate to privacy terms page
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey[300]))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.copyright),
              const SizedBox(width: 8),
              Text(DateTime.now().year.toString()),
              const SizedBox(width: 8),
              GestureDetector(
                child: Text(
                  'Algoa Bus Company',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.blue,
                  ),
                ),
                onTap: () {
                  // ignore: deprecated_member_use
                  launch('https://www.algoabus.co.za/');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).pop(true);
        });
        return AlertDialog(
          content: Text("User details Successfully Updated"),
        );
      },
    );
  }
}
