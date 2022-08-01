// ignore_for_file: prefer_const_constructors, unused_local_variable, unnecessary_new, avoid_unnecessary_containers, use_build_context_synchronously

import 'package:earnbywatching/addition/points.dart';
import 'package:earnbywatching/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../addition/custom_page_route.dart';
import '../addition/flutterfire.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

final TextEditingController emailField = TextEditingController();
final TextEditingController passwordField = TextEditingController();

class _RegisterState extends State<Register> {
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
            controller: controller,
            obscureText: password,
            textDirection: TextDirection.rtl,
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

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth / 15, vertical: screenHeight / 40),
          child: Column(crossAxisAlignment: CrossAxisAlignment.center,
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
                          Text(
                            'إنشاء حساب',
                            style: TextStyle(
                                fontFamily: "Tajawal",
                                fontSize: screenWidth / 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                          SizedBox(
                            width: screenWidth / 15,
                          ),
                          InkWell(
                            child: Text(
                              'تسجيل الدخول',
                              style: TextStyle(
                                  fontFamily: "Tajawal",
                                  fontSize: screenWidth / 22,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade600),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight / 25,
                      ),
                      Text(
                        'قم بتعبئة البيانات التالية لإنشاء حساب جديدي',
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
                    input('كلمة السر', true, passwordField),
                    SizedBox(
                      height: screenHeight / 50,
                    ),
                    input('تأكيد كلمة السر', true, passwordField)
                  ],
                ),
                SizedBox(
                  height: screenHeight / 25,
                ),
                InkWell(
                    child: button(text: 'إنشاء حساب', size: screenWidth),
                    onTap: () async {
                      bool shouldNavigate =
                          await register(emailField.text, passwordField.text);
                      if (shouldNavigate) {
                        Navigator.push(
                            context,
                            CustomPageRoute(
                                child: Home(), direction: AxisDirection.right));
                        createWallet();

                        final preferences =
                            await SharedPreferences.getInstance();

                        await preferences.setString('gmail', emailField.text);
                        await preferences.setBool('signedin', true);
                      }
                      ;
                    }),
              ]),
        ),
      ),
    );
  }
}
