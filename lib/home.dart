// ignore_for_file: prefer_const_constructors, duplicate_ignore, use_build_context_synchronously, unnecessary_cast

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:earnbywatching/addition/flutterfire.dart';
import 'package:earnbywatching/auth/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'addition/custom_page_route.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String gmail = '';
  String balance = '';
  late SharedPreferences preferences;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    final preferences = await SharedPreferences.getInstance();

    String? savedGmail = preferences.getString('gmail');

    if (savedGmail == null) return;

    setState(() {
      this.gmail = savedGmail;
    });
  }

  // BannerAd? bannerAd;
  // bool isLoaded = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    // bannerAd = BannerAd(
    //     size: AdSize.mediumRectangle,
    //     adUnitId: 'ca-app-pub-3940256099942544/6300978111',
    //     listener: BannerAdListener(onAdLoaded: (ad) {
    //       setState(() {
    //         isLoaded = true;
    //       });
    //       print('Banner ad Loaded');
    //     }, onAdFailedToLoad: (ad, error) {
    //       ad.dispose();
    //     }),
    //     request: AdRequest());
    // bannerAd!.load();
  }

  update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);

    // context size
    double screenWidth = queryData.size.width;
    double screenHeight = queryData.size.height;

    // document instance
    CollectionReference wallets =
        FirebaseFirestore.instance.collection('wallets');

    Widget getAd() {
      BannerAdListener bannerAdListener =
          BannerAdListener(onAdWillDismissScreen: (ad) {
        ad.dispose();
      }, onAdClosed: (ad) {
        debugPrint("Ad Got Closed");
      }, onAdClicked: (ad) {
        // add coin
        var wallet = FirebaseFirestore.instance.collection('wallets');
        int old = int.parse(balance);
        int current = old + 1;
        wallet.doc(gmail).update({'balance': current.toString()});
        update();
      });

      BannerAd bannerAd = BannerAd(
          size: AdSize.mediumRectangle,
          adUnitId: Platform.isAndroid
              ? 'ca-app-pub-3940256099942544/6300978111'
              : 'ca-app-pub-3940256099942544/2934735716',
          listener: bannerAdListener,
          request: AdRequest());

      bannerAd.load();

      return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth / 20, vertical: screenHeight / 120),
        child: PhysicalModel(
          color: Colors.white,
          shadowColor: Colors.grey.shade800,
          elevation: 8,
          child: Container(
            height: bannerAd.size.height.toDouble(),
            width: screenWidth,
            color: Colors.white,
            child: AdWidget(ad: bannerAd),
          ),
        ),
      );
    }

    // ignore: prefer_const_constructors
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.grey.shade200,
    ));

    return WillPopScope(
      onWillPop: () {
        exit(1);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          actions: [
            FutureBuilder<DocumentSnapshot>(
              future: wallets.doc(gmail).get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text("!");
                }

                if (snapshot.hasData && !snapshot.data!.exists) {
                  return Text("!");
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> wallets =
                      snapshot.data!.data() as Map<String, dynamic>;
                  balance = wallets['balance'];
                  return Padding(
                    padding: EdgeInsets.only(right: screenWidth / 20),
                    child: Center(
                      child: Text(
                        wallets['balance'],
                        style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: screenWidth / 12,
                            color: Colors.grey.shade800),
                      ),
                    ),
                  );
                }

                return Center(
                    child: CircularProgressIndicator(
                  color: Colors.yellow.shade800,
                ));
              },
            ),
          ],
          centerTitle: true,
          title: Image.asset(
            'assets/images/logo.jpeg',
            width: screenWidth / 2.2,
          ),
          backgroundColor: Colors.white,
          toolbarHeight: screenHeight / 7.3,
          leading: IconButton(
            padding: EdgeInsets.only(left: screenWidth / 20),
            onPressed: () async {
              bool shouldNavigate = await signOut();
              if (shouldNavigate) {
                Navigator.push(
                    context,
                    CustomPageRoute(
                        child: Signin(), direction: AxisDirection.left));

                final preferences = await SharedPreferences.getInstance();

                await preferences.setString('gmail', '');
                await preferences.setBool('signedin', false);
              }
            },
            icon: Icon(Icons.output),
            color: Colors.grey,
            iconSize: screenWidth / 13,
          ),
        ),
        body: SafeArea(
          child: ListView.separated(
              itemBuilder: (context, index) {
                if (index != 0) {
                  return getAd();
                }
                return Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth / 20, vertical: screenWidth / 20),
                  alignment: Alignment.centerRight,
                  child: Text(
                    'شاهد واربح',
                    style: TextStyle(
                        fontFamily: "Tajawal",
                        fontSize: screenWidth / 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 12,
                );
              },
              itemCount: 15),
        ),
      ),
    );
  }
}
