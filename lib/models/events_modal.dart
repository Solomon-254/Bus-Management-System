class Events {
  String uid;
  String busName;
  String eventType;
  String route;
  DateTime eventDate;
  String plateNumber;
  String eventVenue;
  String eventDescription;
  String companyInvolvedInEvent;
  String personnelInvolvedInEvent;
  String personnelInvolvedInEventContact;
  String eventStatus;

  Events(
      {this.uid,
      this.busName,
      this.eventType,
      this.route,
      this.eventDate,
      this.plateNumber,
      this.companyInvolvedInEvent,
      this.eventDescription,
      this.personnelInvolvedInEvent,
      this.personnelInvolvedInEventContact,
      this.eventVenue,
      this.eventStatus});
}

class EventsUserData {
  String uid;
  String busName;
  String eventType;
  DateTime eventDate;
  String plateNumber;

  EventsUserData(
      {this.uid,
      this.busName,
      this.eventType,
      this.eventDate,
      this.plateNumber});
}

class EventsDetailsData {
  String uid;
  String eventPlace;
  String eventDescription;
  String companyInvolved;
  String personnelInvolved;
  String personnelContact;

  EventsDetailsData(
      {this.uid,
      this.eventPlace,
      this.eventDescription,
      this.companyInvolved,
      this.personnelInvolved,
      this.personnelContact});
}
