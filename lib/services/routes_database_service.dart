import 'package:bus_management_system/models/routes_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoutesDatabaseServices {
  final String uid;
  RoutesDatabaseServices({this.uid});

  CollectionReference routesCollection =
      FirebaseFirestore.instance.collection("Routes");

  Future<void> addRoutesToFirebase(String busName, String startingPoint,
      String destinationPoint, double distanceInKm, double cost) async {
    // Generate a new document reference using the doc() method
    DocumentReference docRef = routesCollection.doc();

    // Get the ID of the new document reference
    String docId = docRef.id;

    // Create a new bus document with the generated ID and bus data
    await docRef.set({
      'busName': busName,
      'startingPoint': startingPoint,
      'destinationPoint': destinationPoint,
      'intervalDistancInKm': distanceInKm,
      'cost': cost,
    });
  }

  //getting users list from a snapshot from firestore collection Users to be displayed in the datatable
  List<Routes> _routesListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      return Routes(
          busName: data['busName'] ?? '',
          startingPoint: data['startingPoint'] ?? '',
          destinationPoint: data['destinationPoint'] ?? '',
          distanceInKm: data['intervalDistancInKm'] ?? '',
          cost: data['cost'] ?? '');
    }).toList();
  }

  //get user stream that will be passed down a streambuilder from rebuilding
  Stream<List<Routes>> get routes {
    return routesCollection.snapshots().map(_routesListFromSnapshot);
  }

  //get document id by the routes names
  Future<String> getRouteDocumentId(
      String startingPoint, String destinantionPoint) async {
    QuerySnapshot snapshot = await routesCollection
        .where('startingPoint', isEqualTo: startingPoint)
        .where('destinationPoint', isEqualTo: destinantionPoint)
        .get();

    if (snapshot.docs.isNotEmpty) {
      DocumentSnapshot documentSnapshot = snapshot.docs.first;
      return documentSnapshot.id;
    } else {
      throw Exception(
          'No document found with route name: $startingPoint - $destinantionPoint');
    }
  }

  //editing functionality
  Routes _routesUpdateFromSnapshot(
      DocumentSnapshot documentSnapshot, String docId) {
    Map<String, dynamic> data = documentSnapshot.data();
    if (data == null) {
      throw Exception("Data does not exists");
    } else {
      return Routes(
        uid: docId,
        busName: data['busName'],
        startingPoint: data['startingPoint'],
        destinationPoint: data['destinationPoint'],
        distanceInKm: data['intervalDistancInKm'],
        cost: data['cost'],
      );
    }
  }

//get user data doc stream
  Stream<Routes> getURouteData(String docId) {
    return routesCollection.doc(docId).snapshots().map((docSnapshot) {
      return _routesUpdateFromSnapshot(docSnapshot, docId);
    });
  }

  //Update route data
  Future updateRouteData(String busName, String startingPoint,
      String destinationPoint, double distanceInKm, double cost) async {
    return await routesCollection.doc(uid).update({
      'busName': busName,
      'startingPoint': startingPoint,
      'destinationPoint': destinationPoint,
      'distanceInKm': distanceInKm,
      'cost': cost
    });
  }

  //Deleting function for a bus based on the id
  Future<void> deleteRoute(String docId) async {
    await routesCollection.doc(docId).delete();
  }

  Future<List<Map<String, dynamic>>> getRoutesFromFirebase() async {
    // Query the routes collection and get all the documents
    QuerySnapshot querySnapshot = await routesCollection.get();

    // Extract the route data from the documents and add them to a list
    List<Map<String, dynamic>> routesList = querySnapshot.docs.map((doc) {
      return {
        'route': '${doc['startingPoint']} - ${doc['destinationPoint']}',
      };
    }).toList();

    // Return the list of route objects
    print(routesList.length);
    print(routesList);
    return routesList;
  }

  //return a list of routes based on the licence disk/plate number passed
  Future<List<Map<String, dynamic>>> getRoutesByPlateNumber(String busName) async {
  List<Map<String, dynamic>> routes = [];

  QuerySnapshot querySnapshot = await routesCollection
      .where('busName', isEqualTo: busName)
      .get();

  querySnapshot.docs.forEach((doc) {
    Map<String, dynamic> data = doc.data();
    data['id'] = doc.id;
    data['route'] = '${data['startingPoint']} - ${data['destinationPoint']}';
    routes.add(data);
  });

  return routes;
}


}
