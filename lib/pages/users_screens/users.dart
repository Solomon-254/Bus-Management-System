import 'package:bus_management_system/constants/style.dart';
import 'package:bus_management_system/pages/users_screens/widgets/users_list.dart';
import 'package:bus_management_system/services/user_database_service.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:provider/provider.dart';

import '../../constants/controller.dart';
import '../../helpers/responsivenes.dart';
import '../../models/bus_model.dart';
import '../../models/users_model.dart';
import '../../services/bus_database_service.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/navigationButton.dart';

class UsersPage extends StatefulWidget {
//  final List<Users> busesList;
//   List<Users> newList;

  UsersPage({
    Key key,
    // this.busesList,
  }) : super(key: key);

  @override
  State<UsersPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<UsersPage> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Users>>.value(
      value: UserDatabaseService().users,
      initialData: [],
      child: const Scaffold(
        body: UsersList(),
      ),
    );
  }
}
