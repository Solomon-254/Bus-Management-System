// ignore_for_file: unused_import

import 'package:bus_management_system/constants/style.dart';
import 'package:bus_management_system/helpers/responsivenes.dart';
import 'package:bus_management_system/widgets/main_content.dart';
import 'package:bus_management_system/widgets/panel.dart';
import 'package:bus_management_system/widgets/side_menu.dart';
import 'package:bus_management_system/widgets/top_nav.dart';
import 'package:flutter/material.dart';

class SiteLayout extends StatelessWidget {
  // final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      
      // key: scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: TopNavigationBar()),
      drawer: Drawer(
        child: SideMenu(),
        backgroundColor: Colors.black,
      ),
      body: ResponsiveWidget(
        largeScreen: LargeScreen(),
        smallScreen: PanelScreen(),
        customScreen: LargeScreen(),
        
      ),
      
    );
  }
}
