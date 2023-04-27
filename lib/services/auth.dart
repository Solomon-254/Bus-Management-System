import 'package:bus_management_system/models/user_model.dart';
import 'package:bus_management_system/services/bus_database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth =
      FirebaseAuth.instance; //Initializing firebase Authentication
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String uid;
  // Get the current user
  User get currentUser => _auth.currentUser;

  UserModel _userFromFirebaseUser(User user) {
    return user != null ? UserModel(uid: user.uid) : null;
  }

  //auth changes user stream
  Stream<UserModel> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  //registering authorised users.
 Future<bool> registerUser(
  String fullName, String username, String password, String phone) async {
  try {
    // Create the user account with email and password
    UserCredential userCredential =
        await _auth.createUserWithEmailAndPassword(
      email: username,
      password: password,
    );

    // Add the user data to the "Users" collection
    await FirebaseFirestore.instance
        .collection("RegisteredUsers")
        .doc(userCredential.user.uid)
        .set({
      "fullName": fullName,
      "username": username,
      "role": "admin",
      "phone": phone,
      // hardcoded "role" field with value "admin"
    });

    print("User account created with email and password");
    return true; // registration successful
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    } else {
      print(e.toString());
    }
    return false; // registration failed
  } catch (e) {
    print(e.toString());
    return false; // registration failed
  }
}


  //checks if email is similar or exists
  

  final CollectionReference userInfoCollection =
      FirebaseFirestore.instance.collection("RegisteredUsers");

  //Sign in user. By doing this, an account is created automatically
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      print("User successfully logged in");
      return _userFromFirebaseUser(user).toString();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //uid of the logged in user
  Future<String> getCurrentUserId() async {
    final user = await _auth.currentUser;
    return user?.uid;
  }

//getting the user data of the logged in user
  Future<Map<String, dynamic>> getUserData(String userId) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('RegisteredUsers')
        .doc(userId)
        .get();

    return snapshot.data();
  }

  //Updating the auth user data
  Future<void> updateUserData(
      String userId, Map<String, dynamic> newData) async {
    await FirebaseFirestore.instance
        .collection('RegisteredUsers')
        .doc(userId)
        .update(newData);
  }

  //method to sign out
  Future signOutUser() async {
    try {
      print("User being signed out...###");
      return await _auth.signOut();
    } catch (e) {
      print("Error is.." + e.toString());
      return null;
    }
  }
}
