import 'package:bus_management_system/models/events_modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventsDatabaseService {
  //1. Create a collection called Events
  final String uid;
  EventsDatabaseService({this.uid});
  CollectionReference eventsCollection =
      FirebaseFirestore.instance.collection("Events");

  //2.Bus Name data and plate number from Firestire collection buses.
  //This has been done from the Bus Database Service

  //3. Store that data to the
  Future<void> addEventsDataToFirestore(
      String busName,
      String eventType,
      String route,
      DateTime eventDate,
      String plateNumber,
      String eventVenue,
      String eventDescription,
      String companyInvolved,
      String personnelInvolved,
      String personnelContact,
      String eventStatus) async {
    // Generate a new document reference using the doc() method
    DocumentReference docRef = eventsCollection.doc();

    // Get the ID of the new document reference
    String docId = docRef.id;

    // Create a new bus document with the generated ID and bus data
    await docRef.set({
      'busName': busName,
      'eventType': eventType,
      'route': route,
      'eventDate': eventDate,
      'plateNumber': plateNumber,
      'eventPlace': eventVenue,
      'eventDescription': eventDescription,
      'companyInvolvedInEvent': companyInvolved,
      'personnelInvolved': personnelInvolved,
      'PersonnelContact': personnelContact,
      'eventStatus': eventStatus
    });
  }
  //get document id by the bus name

  Future<String> getEventDocumentId(String busName) async {
    QuerySnapshot snapshot =
        await eventsCollection.where('busName', isEqualTo: busName).get();

    if (snapshot.docs.isNotEmpty) {
      DocumentSnapshot documentSnapshot = snapshot.docs.first;
      return documentSnapshot.id;
    } else {
      throw Exception('No Event found with busName: $busName');
    }
  }

//getting users list from a snapshot from firestore collection Users to be displayed in the datatable
  List<Events> _eventsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      return Events(
          busName: data['busName'] ?? '',
          eventType: data['eventType'] ?? '',
          route: data['route'] ?? '',
          // ignore: prefer_null_aware_operators
          eventDate:
              // ignore: prefer_null_aware_operators
              data['eventDate'] != null ? data['eventDate'].toDate() : null,
          plateNumber: data['plateNumber'] ?? '',
          companyInvolvedInEvent: data['companyInvolvedInEvent'] ?? '',
          eventDescription: data['eventDescription'] ?? '',
          eventVenue: data['eventPlace'] ?? '',
          personnelInvolvedInEvent: data['personnelInvolved'] ?? '',
          personnelInvolvedInEventContact: data['PersonnelContact'] ?? '',
          eventStatus: data['eventStatus'] ?? '');
    }).toList();
  }

  //get user stream that will be passed down a streambuilder from rebuilding
  Stream<List<Events>> get events {
    return eventsCollection.snapshots().map(_eventsListFromSnapshot);
  }

  //You can add event updating functionalities with time fromt this class

  //Deleting function for a bus based on the id
  Future<void> deleteUserData(String docId) async {
    await eventsCollection.doc(docId).delete();
  }

//Update a few fields of the event details
  Future updateEventDataDetails(
    String eventVenue,
    String eventDescription,
    String companyInvolved,
    String personnelInvolved,
    String personnelContact,
  ) async {
    try {
      print('Updating event data details...');
      await eventsCollection.doc(uid).update({
        'eventPlace': eventVenue,
        'eventDescription': eventDescription,
        'companyInvolvedInEvent': companyInvolved,
        'personnelInvolved': personnelInvolved,
        'PersonnelContact': personnelContact,
      });
      print('Event data details updated.');
    } catch (e) {
      print('Error updating event data details: $e');
    }
  }

  //Updating the route
  Future updateEventRouteDataDetails(String route) async {
    try {
      print('Updating event data details...');
      await eventsCollection.doc(uid).update({
        'route': route,
      });
      print('Route updated.');
    } catch (e) {
      print('Error updating event data details: $e');
    }
  }

  //Siwtch states/Notification state
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> updateEventDataStatus(String docId, String status) async {
    try {
      await _db.collection('Events').doc(docId).update({
        'eventStatus': status,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  //notification collections
  final CollectionReference notificationCollecion =
      FirebaseFirestore.instance.collection("Notifications");
  //adding user information to the collection using the add user widget
  Future<void> addNotificationDataToFirestore(
    String emailMessage,
    String smsmessage,
  ) async {
    // Generate a new document reference using the doc() method
    DocumentReference docRef = notificationCollecion.doc();

    // Get the ID of the new document reference
    String docId = docRef.id;

    // Create a new notification document with the generated ID and bus data
    await docRef.set({
      'EMAIL SENT': emailMessage,
      'SMS SENT': smsmessage,
      'isNotificationSeen': false
    });
  }

//notificationStatus based on a specific busname
Future<String> getEventsStatusForBus(String busName) async{
    QuerySnapshot querySnapshot = await eventsCollection
      .where('busName', isEqualTo: busName)
      .get();

  if (querySnapshot.size > 0) {
    // There is at least one document that matches the query
    DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
    return documentSnapshot.get('eventStatus');
  } else {
    // There are no documents that match the query
    return null;
  }
}


  // list of events for a given bus name
  Stream<List<Events>> getEventsForBus(String busName) {
    return eventsCollection
        .where('busName', isEqualTo: busName)
        .snapshots()
        .map(_eventsListFromSnapshot);
  }
}
