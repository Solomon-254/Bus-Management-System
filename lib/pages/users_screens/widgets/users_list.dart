import 'package:bus_management_system/constants/style.dart';
import 'package:bus_management_system/models/users_model.dart';
import 'package:bus_management_system/services/user_database_service.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/custom_text.dart';
import '../../../widgets/navigationButton.dart';

class UsersList extends StatefulWidget {
  //
  const UsersList({Key key}) : super(key: key);

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  TextEditingController _searchController = TextEditingController();
  //Implemetation of searching data in the datatable
  List<Users> _filteredUsers = [];
  TextEditingController _licenceExpiryController;

  void _performSearch(List<Users> usersList) {
    setState(() {
      _filteredUsers = usersList
          .where((users) =>
              users.fullName
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              users.emailAddress
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              users.phoneNumber
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              users.role
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _filteredUsers = [];
  }
  // -----

//Updating entities
  void _showEditDialog(BuildContext context, int index, String docId) {
    final formKey = GlobalKey<FormState>();
    String fullName;
    String emailAddress;
    String phoneNumber;
    String role;
    // DateTime licenceExpiryDate;
    bool _isLoading = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Bus"),
          content: StreamBuilder<UsersUserData>(
              stream: UserDatabaseService().getUserData(docId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  UsersUserData usersUserData = snapshot.data;
                  _licenceExpiryController =
                      TextEditingController(text: usersUserData.licenceExpiry.toString());
                  return Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextFormField(
                          initialValue: usersUserData.fullName,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'This field cannot be empty';
                            }
                            return null;
                          },
                          decoration:
                              const InputDecoration(labelText: 'Full Name'),
                          onChanged: (value) {
                            setState(() {
                              fullName = value;
                            });
                          },
                        ),
                        TextFormField(
                          initialValue: usersUserData.emailAddress,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'This field cannot be empty';
                            }
                            return null;
                          },
                          decoration:
                              const InputDecoration(labelText: 'Email Address'),
                          onChanged: (value) {
                            setState(() {
                              emailAddress = value;
                            });
                          },
                        ),
                        TextFormField(
                          initialValue: usersUserData.phoneNumber,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'This field cannot be empty';
                            }
                            return null;
                          },
                          decoration:
                              const InputDecoration(labelText: 'Phone Number'),
                          onChanged: (value) {
                            setState(() {
                              phoneNumber = value;
                            });
                          },
                        ),
                        DropdownButtonFormField<String>(
                          decoration:
                              const InputDecoration(labelText: 'Assigned Role'),
                          value: role ?? usersUserData.role,
                          items: const [
                            DropdownMenuItem(
                              child: Text('Driver'),
                              value: 'Driver',
                            ),
                            DropdownMenuItem(
                              child: Text('Workshop Manager'),
                              value: 'Workshop Manager',
                            ),
                            DropdownMenuItem(
                              child: Text('Other'),
                              value: 'Other',
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              role = value;
                            });
                          },
                        ),
                        TextFormField(
                          controller: _licenceExpiryController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'This field cannot be empty';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              labelText: 'Licence Expiry Date'),
                          onTap: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate:
                                  usersUserData.licenceExpiry ?? DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            if (pickedDate != null) {
                              _licenceExpiryController.text =
                                  pickedDate.toString();
                            }
                          },
                        ),
                        Row(
                          children: [
                            FlatButton(
                              child: _isLoading
                                  ? const CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                    )
                                  : Text(
                                      "Save",
                                      style: TextStyle(
                                          fontSize: 15, color: iconsColor),
                                    ),
                              onPressed: () async {
                                //Updating data in the firestore
                                if (formKey.currentState.validate()) {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  await UserDatabaseService(uid: docId)
                                      .updateUsersData(
                                          fullName ?? usersUserData.fullName,
                                          emailAddress ??
                                              usersUserData.emailAddress,
                                          phoneNumber ??
                                              usersUserData.phoneNumber,
                                          role ?? usersUserData.role,
                                          DateTime.parse(_licenceExpiryController.text) ??
                                              usersUserData.licenceExpiry);
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  Navigator.of(context).pop();
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text(
                                            "Updating User's Info Completed"),
                                        actions: [
                                          FlatButton(
                                            child: Text(
                                              "OK",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: iconsColor),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                            const SizedBox(
                              width: 40,
                            ),
                            FlatButton(
                              child: Text(
                                "Cancel",
                                style:
                                    TextStyle(fontSize: 15, color: iconsColor),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  print("Error: ${snapshot.error}");
                  return Text("Error: ${snapshot.error}");
                } else {
                  return const CircularProgressIndicator();
                }
              }),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, int index, String docId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete User"),
          content: const Text("Are you sure you want to delete this user?"),
          actions: <Widget>[
            FlatButton(
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                await UserDatabaseService().deleteUserData(docId);
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text(
                        "User Deleted",
                        style: TextStyle(color: Colors.red),
                      ),
                      actions: [
                        FlatButton(
                          child: Text(
                            "OK",
                            style: TextStyle(fontSize: 15, color: iconsColor),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            FlatButton(
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final users = Provider.of<List<Users>>(context) ?? [];
    _performSearch(users);

    return Container(
      margin: const EdgeInsets.only(top: 60, bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 6),
            color: bgAccentColor,
            blurRadius: 12,
          ),
        ],
        border: Border.all(color: bgAccentColor, width: .5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(70),
            child: Row(
              children: const [
                SizedBox(
                  width: 10,
                ),
                CustomText(
                  text: "All Users Available",
                  color: Colors.black,
                  weight: FontWeight.bold,
                ),
                SizedBox(
                  width: 40,
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: NavigationButtonUsers(
                    text: 'Add User',
                  ),
                ),
              ],
            ),
          ),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Search',
              hintText: 'Search for a User',
              prefixIcon: Icon(Icons.search),
              suffixIcon: _searchController.text.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _filteredUsers = null;
                        });
                      },
                      icon: const Icon(
                        Icons.clear,
                        size: 10,
                      ),
                    ),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                // do something with the new value
                _performSearch(users);
              });
            },
          ),
          Expanded(
            child: DataTable2(
              columnSpacing: 10,
              horizontalMargin: 12,
              minWidth: 900,
              columns: const [
                DataColumn(
                  label: Text("Full Name"),
                ),
                DataColumn(
                  label: Text("Email Address"),
                ),
                DataColumn(
                  label: Text("Phone Number"),
                ),
                DataColumn(
                  label: Text("Role Assigned"),
                ),
                DataColumn(
                  label: Text("Licence Expiry"),
                ),
                DataColumn(
                  label: Text('Edit'),
                ),
                DataColumn(
                  label: Text('Delete'),
                ),
              ],
              rows: _filteredUsers.map<DataRow>((user) {
                return DataRow(
                  key: UniqueKey(),
                  cells: [
                    DataCell(Text(user.fullName)),
                    DataCell(Text(user.emailAddress)),
                    DataCell(Text(user.phoneNumber)),
                    DataCell(Text(user.role)),
                    DataCell(Text(user.licenceExpiry.toString())),
                    DataCell(
                      IconButton(
                        onPressed: () async {
                          String docID =
                              await UserDatabaseService() //using the phone number to get the document ID of a user
                                  .getUserDocumentId(user.phoneNumber);
                          setState(() {
                            _showEditDialog(
                                context, users.indexOf(user), docID);
                          });
                        },
                        icon: Icon(
                          Icons.edit,
                          color: iconsColor,
                        ),
                      ),
                    ),
                    DataCell(
                      IconButton(
                        onPressed: () async {
                          String docID = await UserDatabaseService()
                              .getUserDocumentId(user.phoneNumber);
                          setState(() {
                            _showDeleteDialog(
                                context, users.indexOf(user), docID);
                          });
                        },
                        icon: Icon(
                          Icons.delete,
                          color: iconsColor,
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
