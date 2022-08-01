// ignore_for_file: prefer_const_constructors, unused_local_variable, unnecessary_new, avoid_unnecessary_containers, use_build_context_synchronously

import 'dart:io';

import 'package:earnbywatching/auth/register.dart';
import 'package:earnbywatching/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../addition/custom_page_route.dart';
import '../addition/flutterfire.dart';

class Signin extends StatefulWidget {
  const Signin({Key? key}) : super(key: key);

  @override
  State<Signin> createState() => _SigninState();
}

final TextEditingController emailField = TextEditingController();
final TextEditingController passwordField = TextEditingController();

class _SigninState extends State<Signin> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);

    // context size
    double screenWidth = queryData.size.width;
    double screenHeight = queryData.size.height;

    Widget input(hint, password, controller) {
      return PhysicalModel(
        color: Colors.white,
        shadowColor: Colors.grey.shade200,
        elevation: 4,
        borderRadius: new BorderRadius.circular(screenWidth / 40),
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: screenHeight / 38, horizontal: screenWidth / 25),
          child: TextField(
            obscureText: password,
            textDirection: TextDirection.rtl,
            controller: controller,
            style: TextStyle(
                fontFamily: "Tajawal",
                fontSize: screenWidth / 24,
                color: Colors.black),
            decoration: new InputDecoration.collapsed(
              hintText: hint,
              hintTextDirection: TextDirection.rtl,
              hintStyle:
                  TextStyle(fontFamily: "Tajawal", fontSize: screenWidth / 24),
            ),
          ),
        ),
      );
    }

    Widget button({text, size, color}) {
      double width = size ?? screenWidth / 2.5;
      dynamic backgroundColor = color ?? Colors.black;
      return PhysicalModel(
        color: Colors.grey.shade200,
        shadowColor: Colors.grey.shade200,
        elevation: 4,
        borderRadius: new BorderRadius.circular(screenWidth / 40),
        child: Container(
          width: width,
          padding: EdgeInsets.symmetric(vertical: screenHeight / 40),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                  fontFamily: "Tajawal",
                  fontSize: screenWidth / 25,
                  fontWeight: FontWeight.w600,
                  color: backgroundColor),
            ),
          ),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () {
        exit(1);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth / 15, vertical: screenHeight / 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Image.asset(
                    'assets/images/logo_small.png',
                    width: screenWidth / 10,
                  ),
                ),
                SizedBox(
                  height: screenHeight / 40,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            child: Text(
                              'إنشاء حساب',
                              style: TextStyle(
                                  fontFamily: "Tajawal",
                                  fontSize: screenWidth / 22,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade600),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  CustomPageRoute(
                                      child: const Register(),
                                      direction: AxisDirection.right));
                            },
                          ),
                          SizedBox(
                            width: screenWidth / 15,
                          ),
                          Text(
                            'تسجيل الدخول',
                            style: TextStyle(
                                fontFamily: "Tajawal",
                                fontSize: screenWidth / 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight / 25,
                      ),
                      Text(
                        'قم بتعبئة بيانات تسجيل الدخول',
                        style: TextStyle(
                            fontFamily: "Tajawal",
                            fontSize: screenWidth / 26,
                            color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: screenHeight / 45,
                ),
                Column(
                  children: [
                    input('البريد الالكتروني', false, emailField),
                    SizedBox(
                      height: screenHeight / 50,
                    ),
                    input('كلمة السر', true, passwordField)
                  ],
                ),
                SizedBox(
                  height: screenHeight / 25,
                ),
                InkWell(
                  child: button(text: 'تسجيل الدخول', size: screenWidth),
                  onTap: () async {
                    bool shouldNavigate =
                        await signIn(emailField.text, passwordField.text);
                    if (shouldNavigate) {
                      Navigator.push(
                          context,
                          CustomPageRoute(
                              child: Home(), direction: AxisDirection.right));

                      final preferences = await SharedPreferences.getInstance();

                      await preferences.setString('gmail', emailField.text);
                      await preferences.setBool('signedin', true);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
