import 'package:bus_management_system/models/user_model.dart';
import 'package:bus_management_system/services/bus_database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth =
      FirebaseAuth.instance; //Initializing firebase Authentication
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final CollectionReference userInfoCollection =
      FirebaseFirestore.instance.collection("AuthorisedUsers");
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

  //Sign in user. By doing this, an account is created automatically
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;

      // Create a document for the user in the 'AuthorisedUsers' collection
      await _db.collection('AuthorisedUsers').doc(user.uid).set({
        'email': email,
        'password': password,
        'fullName': 'Festus Munene',
        'phoneNumber': '+254797764187',
        'role': 'admin',
      });

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
        .collection('AuthorisedUsers')
        .doc(userId)
        .get();

    return snapshot.data();
  }

  //Updating the auth user data
  Future<void> updateUserData(
      String userId, Map<String, dynamic> newData) async {
    await FirebaseFirestore.instance
        .collection('AuthorisedUsers')
        .doc(userId)
        .update(newData);
  }
}
