import 'dart:html';

import 'package:bus_management_system/constants/controller.dart';
import 'package:bus_management_system/helpers/responsivenes.dart';
import 'package:bus_management_system/pages/dashboard_screens/widgets/dashboard_viewcards_large.dart';
import 'package:bus_management_system/pages/dashboard_screens/widgets/dashboard_viewcards_medium.dart';
import 'package:bus_management_system/pages/dashboard_screens/widgets/dashboard_viewcards_small.dart';
import 'package:bus_management_system/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OverviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Obx(
            () => Row(
              children: [
                Container(
                    margin: EdgeInsets.only(
                        top: ResponsiveWidget.isSmallScreen(context) ? 56 : 6),
                    child: CustomText(
                      text: menuController.activeItem.value,
                      size: 24,
                      weight: FontWeight.bold,
                    )),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                if (ResponsiveWidget.isLargeScreen(context) ||
                    ResponsiveWidget.isMediumScreen(context))
                  if (ResponsiveWidget.isCustomSize(context))
                    OverviewCardsMediumScreen()
                  else
                    OverviewCardsLargeScreen()
                else
                  OverviewCardsSmallScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
