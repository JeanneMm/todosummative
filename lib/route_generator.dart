import 'package:flutter/material.dart';
import 'package:flutter_todo_app/main.dart';
import 'package:flutter_todo_app/screens/signin_page.dart';
import 'package:flutter_todo_app/screens/signup_page.dart';
import 'package:flutter_todo_app/screens/splash.dart';
import 'package:flutter_todo_app/screens/home.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const Home(title: '',));
      case '/splash':
        return MaterialPageRoute(builder: (_) =>  const Splash(title: '',));
      case '/signup':
        return MaterialPageRoute(builder: (_) => const SignUpPage());
      case '/signin':
        return MaterialPageRoute(builder: (_) => const SignInPage());
      default:
        return MaterialPageRoute(builder: (_) => const Home(title: '',));
    }
  }
}