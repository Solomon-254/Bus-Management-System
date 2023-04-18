import 'package:bus_management_system/constants/style.dart';
import 'package:bus_management_system/pages/onboarding_screen/login.dart';
import 'package:bus_management_system/routings/routes.dart';
import 'package:bus_management_system/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class InfoCardSmall extends StatelessWidget {
  final String title;
  final String value;
  final bool isActive;
  final String function;
  final Function onTap;

  const InfoCardSmall(
      {Key key,
      @required this.title,
      @required this.value,
      this.isActive = false,
      @required this.onTap,
      this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {},
        child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: isActive ? iconsColor : bgAccentColor, width: .5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: title,
                  size: 24,
                  weight: FontWeight.w300,
                  color: isActive ? iconsColor : Colors.green,
                ),
                CustomText(
                  text: value,
                  size: 24,
                  weight: FontWeight.bold,
                  color: isActive ? iconsColor : Colors.blue,
                ),
              ],
            )),
      ),
    );
  }
}
