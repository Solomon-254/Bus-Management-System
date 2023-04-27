import 'package:bus_management_system/models/users_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDatabaseService {
  final String uid;
  UserDatabaseService({this.uid});

//Creating firestore collection for user
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("Users");

//adding user information to the collection using the add user widget
  Future<void> addUserDataToFirestore(String fullName, String emailAddress,
      String phoneNumber, String role, DateTime licenceExpiryDate) async {
    try {
      if (fullName.isEmpty ||
          emailAddress.isEmpty ||
          phoneNumber.isEmpty ||
          role.isEmpty ||
          licenceExpiryDate == null) {
        throw ArgumentError(
            "One or more input parameters are invalid or empty");
      }

      // Generate a new document reference using the doc() method
      DocumentReference docRef = usersCollection.doc();

      // Get the ID of the new document reference
      String docId = docRef.id;

      // Create a new user document with the generated ID and user data
      await docRef.set({
        'fullName': fullName,
        'emailAddress': emailAddress,
        'phoneNumber': phoneNumber,
        'role': role,
        'licenceExpiryDate': licenceExpiryDate
      });
    } catch (e) {
      print('Error adding user data to Firestore: $e');
      // Throw the error to the caller to handle it
      throw e;
    }
  }

  //get document id by the phone number
  Future<String> getUserDocumentId(String phoneNumber) async {
    QuerySnapshot snapshot = await usersCollection
        .where('phoneNumber', isEqualTo: phoneNumber)
        .get();

    if (snapshot.docs.isNotEmpty) {
      DocumentSnapshot documentSnapshot = snapshot.docs.first;
      return documentSnapshot.id;
    } else {
      throw Exception('No document found with busName: $phoneNumber');
    }
  }

  //getting users list from a snapshot from firestore collection Users to be displayed in the datatable
  List<Users> _usersListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      return Users(
        fullName: data['fullName'] ?? '',
        emailAddress: data['emailAddress'] ?? '',
        phoneNumber: data['phoneNumber'] ?? '',
        role: data['role'] ?? '',
        // ignore: prefer_null_aware_operators
        licenceExpiry: data['licenceExpiryDate'] != null
            ? data['licenceExpiryDate'].toDate()
            : null,
      );
    }).toList();
  }

  //get user stream that will be passed down a streambuilder from rebuilding
  Stream<List<Users>> get users {
    return usersCollection.snapshots().map(_usersListFromSnapshot);
  }

  //get user data from out snapshot collection
  UsersUserData _usersUserDataFromSnapshot(
      DocumentSnapshot documentSnapshot, String docId) {
    Map<String, dynamic> data = documentSnapshot.data();
    if (data == null) {
      throw Exception("Data does not exists");
    } else {
      return UsersUserData(
          uid: docId,
          fullName: data['fullName'] ?? '',
          emailAddress: data['emailAddress'] ?? '',
          phoneNumber: data['phoneNumber'] ?? '',
          role: data['role'] ?? '',
          licenceExpiry:
              // ignore: prefer_null_aware_operators
              data['licenceExpiryDate'] != null ? data['licenceExpiryDate'].toDate() : null,
          );
    }
  }

//get user data doc stream
  Stream<UsersUserData> getUserData(String docId) {
    return usersCollection.doc(docId).snapshots().map((docSnapshot) {
      return _usersUserDataFromSnapshot(docSnapshot, docId);
    });
  }

//Updating function for bus based on the docID
  Future updateUsersData(
      String fullName,
      String emailAddress,
      String phoneNumber, //Updating data based on a given docId
      String role,
      DateTime licenceExpiryDate) async {
    return await usersCollection.doc(uid).update({
      'fullName': fullName,
      'emailAddress': emailAddress,
      'phoneNumber': phoneNumber,
      'role': role,
      'licenceExpiryDate': licenceExpiryDate
    });
  }

  //Deleting function for a bus based on the id
  Future<void> deleteUserData(String docId) async {
    await usersCollection.doc(docId).delete();
  }

  //return a list of roles as Drivers
  Future<List<String>> getAssignedDrivers() async {
    QuerySnapshot querySnapshot =
        await usersCollection.where('role', isEqualTo: 'Driver').get();

    List<String> assignedDriversList = [];

    if (querySnapshot.docs.isNotEmpty) {
      querySnapshot.docs.forEach((documentSnapshot) {
        Map<String, dynamic> data = documentSnapshot.data();
        assignedDriversList.add(data['fullName']);
      });
    }

    print('Assigned drivers: $assignedDriversList');

    return assignedDriversList;
  }

//get a list of workshop managers
  Future<List<String>> getWorkshopManagers() async {
    QuerySnapshot querySnapshot = await usersCollection
        .where('role', isEqualTo: 'Workshop Manager')
        .get();

    List<String> workshopManagerList = [];

    if (querySnapshot.docs.isNotEmpty) {
      querySnapshot.docs.forEach((documentSnapshot) {
        Map<String, dynamic> data = documentSnapshot.data();
        workshopManagerList.add(data['fullName']);
      });
    }

    print('Workshop Managers: $workshopManagerList');

    return workshopManagerList;
  }

// 'return a list of licence the selected driver full name
  Future<DateTime> getDriverLicenceExpiryDate(String driverName) async {
    QuerySnapshot querySnapshot =
        await usersCollection.where('fullName', isEqualTo: driverName).get();

    if (querySnapshot.docs.isNotEmpty) {
      Map<String, dynamic> data = querySnapshot.docs.first.data();
      Timestamp expiryDate = data['licenceExpiryDate'];
      DateTime expiryDateTime =
          expiryDate.toDate(); // convert Timestamp to DateTime
      print(
          'Licence expiry date for driver $driverName: ${expiryDateTime.toString()}');
      return expiryDateTime;
    }

    print('No licence expiry date found for driver $driverName');
    return null;
  }
}
