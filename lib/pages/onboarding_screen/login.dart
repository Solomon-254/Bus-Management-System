import 'dart:math';

import 'package:bus_management_system/constants/style.dart';
import 'package:bus_management_system/layout.dart';
import 'package:bus_management_system/models/user_model.dart';
import 'package:bus_management_system/routings/routes.dart';
import 'package:bus_management_system/services/auth.dart';
import 'package:bus_management_system/widgets/custom_text.dart';
import 'package:bus_management_system/widgets/side_menu.dart';

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
                        return 'Please enter Email Address';
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
                    validator: (val) =>
                        val?.length == 0 ? 'Enter Password' : null,
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
                      CustomText(
                        text: "Forgot Password?",
                        color: iconsColor,
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
                    const TextSpan(text: "Not A User? Contact Admin  "),
                    TextSpan(
                      text: "Request Credentials",
                      style: TextStyle(color: iconsColor),
                    ),
                  ]))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
