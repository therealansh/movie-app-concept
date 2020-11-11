import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_app_concept/pages/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Function(Movie)',
      home: HomePage(),
    );
  }
}
