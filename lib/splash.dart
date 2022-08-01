// ignore_for_file: prefer_const_constructors, unused_local_variable

import 'dart:async';

import 'package:earnbywatching/auth/signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool signedin = false;
  late SharedPreferences preferences;

  Future init() async {
    final preferences = await SharedPreferences.getInstance();

    bool? signedState = preferences.getBool('signedin');

    if (signedState == null) return;

    setState(() {
      this.signedin = signedState;
    });
  }

  @override
  void initState() {
    Timer(const Duration(seconds: 6), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Page(),
        ),
      );
    });
    super.initState();

    init();
  }

  Page() {
    if (signedin) {
      return Home();
    } else {
      return Signin();
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);

    // context size
    double screenWidth = queryData.size.width;
    double screenHeight = queryData.size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Image.asset(
            'assets/images/logo.jpeg',
            width: screenWidth,
          ),
        ),
      ),
    );
  }
}
