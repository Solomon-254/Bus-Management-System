class Bus {
  String uid;
  String busName;
  String registrationNumber;
  String plateNumber;
  String assignedDriver;
  String workshopManager;
  String makeOfBus;
  String serviceAgent;
  String serviceIntervaldistaneInKm;
  DateTime yearOfManufacture;
  DateTime driversLicenceExpiryDate;
  DateTime licenceDiskExpiryDate;
  DateTime busRoadWorthinessExpiryDate;
  String notes;

  Bus(
      {this.uid,
      this.busName,
      this.registrationNumber,
      this.plateNumber,
      this.assignedDriver,
      this.workshopManager,
      this.makeOfBus,
      this.serviceAgent,
      this.serviceIntervaldistaneInKm,
      this.yearOfManufacture,
      this.driversLicenceExpiryDate,
      this.licenceDiskExpiryDate,
      this.busRoadWorthinessExpiryDate,
      this.notes});
}

class BusUserData {
  String uid;
  String busName;
  String licenceNumber;
  String plateNumber;
  String assignedDriver;

  BusUserData({
    this.uid,
    this.busName,
    this.licenceNumber,
    this.plateNumber,
    this.assignedDriver,
  });
}
