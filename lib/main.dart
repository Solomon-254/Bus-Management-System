import 'package:bus_management_system/pages/routes/routes_add.dart';
import 'package:bus_management_system/pages/routes/routes_list.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:bus_management_system/models/user_model.dart';
import 'package:bus_management_system/pages/buses_screens/buses_add.dart';
import 'package:bus_management_system/pages/dashboard_screens/dashboard.dart';
import 'package:bus_management_system/pages/events_screens/events_add.dart';
import 'package:bus_management_system/pages/events_screens/widgets/add_events_details.dart';
import 'package:bus_management_system/pages/events_screens/widgets/events_details.dart';
import 'package:bus_management_system/pages/events_screens/widgets/view_all_bus_events.dart';
import 'package:bus_management_system/pages/settings_screens/settings.dart';
import 'package:bus_management_system/pages/users_screens/users_add.dart';
import 'package:bus_management_system/routings/routes_add.dart';
import 'package:bus_management_system/services/auth.dart';
import 'package:bus_management_system/services/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:bus_management_system/controllers/menuController.dart';
import 'package:bus_management_system/controllers/navigation_controller.dart';
import 'package:bus_management_system/layout.dart';
import 'package:bus_management_system/pages/404_error/error.dart';
import 'package:bus_management_system/pages/onboarding_screen/login.dart';
import 'package:bus_management_system/routings/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() async {
  HttpOverrides.global = MyHttpOverrides(); // <-- added code to the main file
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: "AIzaSyC-g7IQlFAXUs_e2lPyj8hLLTQmHPd99nU",
    projectId: "bus-management-system-17ede",
    messagingSenderId: "45566987001",
    appId: "1:45566987001:web:02e93be59c52976763f028",
  ));
  Get.put(MenuController());
  Get.put(NavigationController());

  runApp(const MyApp());
}

//Setting up and configuring the proxy server ti my project to avoid CORS problem whne using Sendgrid API
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel>.value(
      value: AuthService().user,
      child: GetMaterialApp(
        initialRoute: AuthenticationViewRoute,
        unknownRoute: GetPage(
            name: "/not-found",
            page: () => const PageNotFoundPage(),
            transition: Transition.fadeIn),
        getPages: [
          GetPage(name: RootRoute, page: () => const Wrapper()),
          GetPage(name: AuthenticationViewRoute, page: () => const LoginPage()),
          GetPage(name: AddBusesRoute, page: () => const AddBusesPage()),
          GetPage(name: RootRoute, page: () => const AddEventsPage()),
          GetPage(name: RootRoute, page: () => const SettingsPage()),
          GetPage(name: AddUsersRoute, page: () => const AddUsersPage()),
          GetPage(name: RootRoute, page: () => const EventsDetailsPage()),
          GetPage(name: RootRoute, page: () => const AddEventsDetailsPage()),
          GetPage(name: RootRoute, page: () => const BusAllEventsPage()),
          GetPage(name: DashboardViewRoute, page: () => SiteLayout()),
          GetPage(name: RootRoute, page: () => const RoutesPage()),
          GetPage(name: RootRoute, page: () => const AddRoutesPage())
        ],
        debugShowCheckedModeBanner: false,
        title: 'Algoa Bus',
        theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            textTheme: GoogleFonts.mulishTextTheme(Theme.of(context).textTheme)
                .apply(bodyColor: Colors.black),
            pageTransitionsTheme: const PageTransitionsTheme(builders: {
              TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
              TargetPlatform.android: FadeUpwardsPageTransitionsBuilder()
            }),
            primaryColor: Colors.blue),
      ),
    );
  }
}
