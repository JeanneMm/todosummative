import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_todo_app/Services/notifi_service.dart';
import 'package:flutter_todo_app/route_generator.dart';
import 'package:flutter_todo_app/screens/home.dart';
import 'package:flutter_todo_app/screens/splash.dart';

// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// ...

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Color.fromARGB(0, 243, 233, 233)));
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDo App',
      home: Home(title: '',),
      initialRoute: '/splash',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
