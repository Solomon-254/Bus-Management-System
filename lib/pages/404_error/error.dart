import 'package:bus_management_system/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class PageNotFoundPage extends StatelessWidget {
  const PageNotFoundPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/error.png',
            width: 350,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: "Page Not Found",
                size: 24,
                weight: FontWeight.bold,
              )
            ],
          )
        ],
      ),
    );
  }
}
