import 'package:bus_management_system/constants/style.dart';
import 'package:bus_management_system/pages/onboarding_screen/login.dart';
import 'package:bus_management_system/services/auth.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../layout.dart';
import '../../widgets/custom_text.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _fullnameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  String _selectedCountryCode = '+27';
  final formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  bool _loading = false;
  bool _obscureText = true;

  String _fullName = '';
  String _email = '';
  String _password = '';
  String _phone = '';

  final FirebaseAuth _fauth = FirebaseAuth.instance;
  AuthService authService = AuthService();

  //snackbar
  
  @override
  void initState() {
    super.initState();
  }

  void _showSnackbar(BuildContext context, String message, Color color) {
    // Dismiss any existing snackbar
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    // Show the new snackbar
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: color,
    ));
  }

  Future<void> registerUserWithEmailAndPassword(
      String fullName, String username, String password, String phone) async {
    try {
      // Registration successful
      bool success =
          await _auth.registerUser(fullName, username, password, phone);
      if (success) {
        _showSnackbar(
            context, "$_fullName successfully registered", Colors.green);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginPage()));
      } else {
        _showSnackbar(
            context, 'An account already exists with $_email email address. Please Login', Colors.red);
      }
    } catch (e) {
      _showSnackbar(
          context, 'Registration failed. Please try again later.', Colors.red);
    }
  }


  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<UserModel>(context);
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
                          'Registration',
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
                      controller: _fullnameController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter full Names';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _fullName = value.trim();
                      },
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Full Names",
                        hintText: "John Doe",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(17)),
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
                      onSaved: (value) {
                        _phone = value.trim();
                      },
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
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        hintText: "JohnDoe@gmail.com",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(17)),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter an email address';
                        } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _email = value.trim();
                      },
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
                        onSaved: (value) {
                        _password = value.trim();
                      },
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
                    InkWell(
                      child: Container(
                          child: Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          onPressed: () async {
                            String error = "";
                            if (formKey.currentState.validate()) {
                              setState(() => _loading = true);
                              formKey.currentState.save();
                              try {
                                await registerUserWithEmailAndPassword(
                                    _fullName,
                                    _email,
                                    _password,
                                    _selectedCountryCode + _phone);
                                // Navigate to the next screen or show a success message
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()),
                                );
                              } catch (e) {
                                // Show an error message to the user
                                print(e.toString());
                              } finally {
                                setState(() => _loading = false);
                              }
                            }
                          },
                          child: _loading
                              ? const CircularProgressIndicator()
                              : const Text(
                                  "REGISTER",
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
                        const TextSpan(text: "Already a User? "),
                        TextSpan(
                          text: "Sign In",
                          style: TextStyle(color: iconsColor),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
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
      ),
    );
  }
}
