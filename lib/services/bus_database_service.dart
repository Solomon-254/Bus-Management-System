// ignore_for_file: prefer_null_aware_operators

import 'package:bus_management_system/models/bus_model.dart';
import 'package:bus_management_system/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class BusDatabaseService {
  final String uid;
  BusDatabaseService({this.uid});

  final CollectionReference busCollection =
      FirebaseFirestore.instance.collection("Buses");

  Future<void> addBusDataToFirestore(
      String busName,
      String registrationNumber,
      String plateNumber,
      String assignedDriver,
      String workshopManager,
      String makeofCar,
      DateTime yearOfManufacture,
      DateTime driversLicenceExpiryDate,
      DateTime roadWorthyExpiryDate,
      DateTime licenceDiskExpiryDate,
      String serviceIntervalInKm,
      String serviceAgent,
      String notes) async {
    // Generate a new document reference using the doc() method
    DocumentReference docRef = busCollection.doc();

    // Get the ID of the new document reference
    String docId = docRef.id;

    // Create a new bus document with the generated ID and bus data
    await docRef.set({
      'busName': busName,
      'registrationNumber': registrationNumber,
      'plateNumber': plateNumber,
      'assignedDriver': assignedDriver,
      'workshopManager': workshopManager,
      'makeOfCar': makeofCar,
      'yearOfManufacture': yearOfManufacture,
      'driverLicenceExpiryDate': driversLicenceExpiryDate,
      'busRoadWorthinessExpiryDate': roadWorthyExpiryDate,
      'licenceDiskExpiryDate': licenceDiskExpiryDate,
      'serviceIntervalDistance': serviceIntervalInKm,
      'serviceAgent': serviceAgent,
      'notes': notes
    });
  }

  Future<String> getBusDocumentId(String busName) async {
    QuerySnapshot snapshot =
        await busCollection.where('busName', isEqualTo: busName).get();

    if (snapshot.docs.isNotEmpty) {
      DocumentSnapshot documentSnapshot = snapshot.docs.first;
      return documentSnapshot.id;
    } else {
      throw Exception('No document found with busName: $busName');
    }
  }

  //bus list from snapshot
  List<Bus> _busListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      return Bus(
        busName: data['busName'] ?? '',
        registrationNumber: data['registrationNumber'] ?? '',
        plateNumber: data['plateNumber'] ?? '',
        assignedDriver: data['assignedDriver'] ?? '',
        workshopManager: data['workshopManager'] ?? '',
        makeOfBus: data['makeOfCar'] ?? '',
        serviceAgent: data['serviceAgent'] ?? '',
        serviceIntervaldistaneInKm: data['serviceIntervalDistance'] ?? '',
        yearOfManufacture: data['yearOfManufacture'] != null
            ? data['yearOfManufacture'].toDate()
            : null,
        driversLicenceExpiryDate: data['driverLicenceExpiryDate'] != null
            ? data['driverLicenceExpiryDate'].toDate()
            : null,
        licenceDiskExpiryDate: data['licenceDiskExpiryDate'] != null
            ? data['licenceDiskExpiryDate'].toDate()
            : null,
        busRoadWorthinessExpiryDate: data['busRoadWorthinessExpiryDate'] != null
            ? data['busRoadWorthinessExpiryDate'].toDate()
            : null,
        notes: data['notes'] ?? '',
      );
    }).toList();
  }

  //get bus stream
  Stream<List<Bus>> get buses {
    return busCollection.snapshots().map(_busListFromSnapshot);
  }

//get user data from out snapshot collection
  BusUserData _bususerDataFromSnapshot(
      DocumentSnapshot documentSnapshot, String docId) {
    Map<String, dynamic> data = documentSnapshot.data();
    if (data == null) {
      throw Exception("Data does not exists");
    } else {
      return BusUserData(
        uid: docId,
        busName: data['busName'],
        licenceNumber: data['registrationNumber'],
        plateNumber: data['plateNumber'],
        assignedDriver: data['assignedDriver'],
      );
    }
  }

//get user data doc stream
  Stream<BusUserData> getUserData(String docId) {
    return busCollection.doc(docId).snapshots().map((docSnapshot) {
      return _bususerDataFromSnapshot(docSnapshot, docId);
    });
  }

//Updating function for bus based on the docID
  Future updateBusData(
      String busName,
      String licenceNumber,
      String plateNumber, //Updating data based on a given docId
      String assignedDriver) async {
    return await busCollection.doc(uid).update({
      'busName': busName,
      'licenceNumber': licenceNumber,
      'plateNumber': plateNumber,
      'assignedDriver': assignedDriver
    });
  }

//update Bus Data Details function
  Future updateBusDataDetails(
      String workshopManager,
      String makeOfBus,
      String serviceAgent,
      String serviceIntervalInKm,
      DateTime yearOfManufacture,
      DateTime driversLicenceExpiryDate,
      DateTime licenceDiskExpiryDate,
      DateTime busRoadWorthinessExpiryDate,
      String notes) async {
    return await busCollection.doc(uid).update({
      'workshopManager': workshopManager,
      'makeOfCar': makeOfBus,
      'serviceAgent': serviceAgent,
      'serviceIntervalDistance': serviceIntervalInKm,
      'yearOfManufacture': yearOfManufacture,
      'driverLicenceExpiryDate': driversLicenceExpiryDate,
      'licenceDiskExpiryDate': licenceDiskExpiryDate,
      'busRoadWorthinessExpiryDate': busRoadWorthinessExpiryDate,
      'notes': notes
    });
  }

  //Deleting function for a bus based on the id
  Future<void> deleteBusData(String docId) async {
    await busCollection.doc(docId).delete();
  }

  //get a list of buses.
  Future<List<String>> getBusNames() async {
    QuerySnapshot snapshot = await busCollection.get();
    List<String> busNames = snapshot.docs
        .map((doc) => (doc.data() as Map<String, dynamic>)['busName'])
        .toList();
    print(busNames);
    return busNames;
  }

  //Checking whether busname added uis similar to what exist to prevent redundancy
   //get a list of buses.
  Future<List<String>> getBusNamesForkey() async {
    QuerySnapshot snapshot = await busCollection.get();
    List<String> busNames = snapshot.docs
        .map((doc) => (doc.data() as Map<String, dynamic>)['busName'].toString())
        .toList();
    print(busNames);
    return busNames;
  }

  //fget a list of bus licence disk based on the bus name
  Future<String> getBusLicenceDisk(String busName) async {
    try {
      QuerySnapshot querySnapshot =
          await busCollection.where('busName', isEqualTo: busName).get();

      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic> data = querySnapshot.docs.first.data();
        String licenceDisk = data['plateNumber'];
        return licenceDisk;
      } else {
        throw Exception('No data found for bus $busName');
      }
    } catch (e) {
      print('Error fetching licence disk for bus $busName: $e');
      return null;
    }
  }
}
