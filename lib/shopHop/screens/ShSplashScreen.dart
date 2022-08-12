import 'dart:async';

import 'package:cotton_natural/shopHop/screens/ShHomeScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:cotton_natural/main/utils/AppWidget.dart';
import 'package:cotton_natural/shopHop/utils/ShColors.dart';
import 'package:cotton_natural/shopHop/utils/ShImages.dart';

class ShSplashScreen extends StatefulWidget {
  static String tag = '/ShophopSplash';

  @override
  ShSplashScreenState createState() => ShSplashScreenState();
}

class ShSplashScreenState extends State<ShSplashScreen> {
  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    var _duration = Duration(seconds: 3);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    finish(context);
    ShHomeScreen().launch(context);
  }

  @override
  Widget build(BuildContext context) {
    changeStatusColor(Colors.black);
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: width + width * 0.4,
        child: Stack(
          children: <Widget>[
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(ic_app_icon, width: width * 0.5),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Stack(
                children: <Widget>[
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
