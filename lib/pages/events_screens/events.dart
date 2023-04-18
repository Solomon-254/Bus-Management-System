import 'package:bus_management_system/constants/style.dart';
import 'package:bus_management_system/models/events_modal.dart';
import 'package:bus_management_system/pages/events_screens/widgets/events_list.dart';
import 'package:bus_management_system/services/events_database_service.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:provider/provider.dart';

import '../../constants/controller.dart';
import '../../helpers/responsivenes.dart';
import '../../models/bus_model.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/navigationButton.dart';

class EventsPage extends StatefulWidget {
  EventsPage({
    Key key,
  }) : super(key: key);

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  @override
  Widget build(BuildContext context) {
     return StreamProvider<List<Events>>.value(
      value: EventsDatabaseService().events,
      child: const Scaffold(
        body: EventsList(),
      ),
    );
  }
}
