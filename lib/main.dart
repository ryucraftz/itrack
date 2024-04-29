// ignore_for_file: avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:itrack/admin/add_class.dart';
import 'package:itrack/admin/add_student.dart';
import 'package:itrack/admin/admin_dashb.dart';
import 'package:itrack/admin/student_list.dart';
import 'package:itrack/admin/view_classes.dart';
import 'package:itrack/firebase_options.dart';
import 'package:itrack/screens/loading_screen.dart';
import 'package:itrack/screens/login_page.dart';
import 'package:itrack/screens/signup_page.dart';
import 'package:itrack/screens/start_page.dart';
import 'package:itrack/user/give_attendance.dart';
import 'package:itrack/user/user_dashb.dart';
import 'package:location/location.dart' as loc;
import 'package:itrack/services/auth_service.dart';
import 'package:itrack/services/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences spInstance;
late DatabaseReference dbReference;

main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  spInstance = await SharedPreferences.getInstance();
  dbReference = FirebaseDatabase.instance.ref();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark));
  _checklocationServices();

  runApp(const MyApp());
}

Future _checklocationServices() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    loc.Location.instance.requestService;
    print('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    print(
        'Location permissions are permanently denied, we cannot request permissions.');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'itrack',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const AdminDashboard(),
      ),
    );
  }
}
