import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/screens/signin_page.dart';


class Splash extends StatefulWidget {
  const Splash({super.key, required String title});

  @override
  State<StatefulWidget> createState() => _SlashState();
}

class _SlashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2),
     (() => 
      // Navigator.of(context).push(
    // MaterialPageRoute(
    //   builder: (context) => const SignInPage(),
    // 
    // ),
     Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SignInPage(),
        ),
  )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Image.asset('images/ToDo.jpg'),
          
          ],
        ),
      ),
    );
  }
}