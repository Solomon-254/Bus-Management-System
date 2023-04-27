import 'dart:math';

import 'package:bus_management_system/constants/style.dart';
import 'package:bus_management_system/layout.dart';
import 'package:bus_management_system/models/user_model.dart';
import 'package:bus_management_system/pages/onboarding_screen/registration.dart';
import 'package:bus_management_system/routings/routes.dart';
import 'package:bus_management_system/services/auth.dart';
import 'package:bus_management_system/widgets/custom_text.dart';
import 'package:bus_management_system/widgets/side_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../constants/controller.dart';
import '../../helpers/responsivenes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  bool _loading = false;
  bool _obscureText = true;

  void intiState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);
    // print(user);

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 228, 228, 228),
      body: Center(
        child: Card(
          color: Color.fromARGB(255, 197, 197, 197),
          margin: const EdgeInsets.all(24),
          elevation: 8,
          child: Form(
            key: formKey,
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: 500,
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
                      Image.asset(
                        'assets/images/logo.png',
                        height: 50,
                      ),
                      Expanded(child: Container()),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Text(
                        'Login',
                        style: GoogleFonts.roboto(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                          color: Colors.blueGrey,
                          letterSpacing: 2,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: _email,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter an email address';
                      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Email Address",
                      hintText: "Nelson@gmail.com",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(17)),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a password';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                    controller: _password,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "#123*FNezz",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(17),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(_obscureText
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        child: CustomText(
                          text: "Forgot Password?",
                          color: iconsColor,
                        ),
                        onTap: () async {
                          String email = _email
                              .text; // get the user's email from a text field or other input
                          try {
                            await FirebaseAuth.instance
                                .sendPasswordResetEmail(email: email);
                                 ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Please check you email Address $email for password resetting instructions"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            // show a success message to the user
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              // show an error message to the user indicating that the email address is not associated with any account
                            } else {
                              // show a generic error message to the user
                            }
                          } catch (e) {
                            // show a generic error message to the user
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    child: Container(
                        child: Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () async {
                          String email = _email.text;
                          String password = _password.text;
                          String error = "";

                          //  await _auth.registerUser();
                          if (formKey.currentState.validate()) {
                            setState(() => _loading = true);
                            dynamic result = await _auth
                                .signInWithEmailAndPassword(email, password);

                            if (result == null) {
                              setState(() {
                                error = "Wrong username or password";
                                _loading = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(error),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SiteLayout()));
                              Navigator.pushReplacementNamed(
                                  context, '/Dashboard');
                              print(
                                  "User successfully signed in and returned..." +
                                      result);
                            }
                          }
                        },
                        child: _loading
                            ? const CircularProgressIndicator()
                            : const Text(
                                "LOGIN",
                                style: TextStyle(fontSize: 17),
                              ),
                        style: ElevatedButton.styleFrom(
                          primary: iconsColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 153,
                            vertical: 26,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(17.0)),
                        ),
                      ),
                    )),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  RichText(
                    text: TextSpan(children: [
                      const TextSpan(text: "Not A User? "),
                      TextSpan(
                        text: "Register",
                        style: TextStyle(color: iconsColor),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const RegistrationPage()),
                            );
                          },
                      ),
                    ]),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
