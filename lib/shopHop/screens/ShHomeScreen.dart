import 'package:cotton_natural/main/utils/AppWidget.dart';
import 'package:cotton_natural/shopHop/screens/ShHomeFragment.dart';
import 'package:cotton_natural/shopHop/screens/ShSearchScreen.dart';
import 'package:cotton_natural/shopHop/screens/sh_call_us.dart';
import 'package:cotton_natural/shopHop/utils/ShColors.dart';
import 'package:cotton_natural/shopHop/utils/ShConstant.dart';
import 'package:cotton_natural/shopHop/utils/ShImages.dart';
import 'package:cotton_natural/shopHop/utils/widgets/ShDrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart';

import 'ShOrderSummaryScreen.dart';

class ShHomeScreen extends StatefulWidget {
  static String tag = '/ShHomeScreen';
  final int? goToTabIndex;
  ShHomeScreen({this.goToTabIndex});
  @override
  ShHomeScreenState createState() => ShHomeScreenState();
}

class ShHomeScreenState extends State<ShHomeScreen> {
  var homeFragment = ShHomeFragment();
  var cartFragment = ShOrderSummaryScreen();
  var callUs = CallUs();
  late var fragments;
  var selectedTab = 0;
  bool login = false;

  @override
  void initState() {
    super.initState();
    selectedTab = ((widget.goToTabIndex != null) ? widget.goToTabIndex : 0)!;
    fragments = [
      homeFragment,
      cartFragment,
      callUs,
    ];
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var title = "100% Pure Cotton";
    switch (selectedTab) {
      case 0:
        title = "100% Pure Cotton";
        break;
      case 1:
        title = "Cart Checkout";
        break;
      case 2:
        title = "Call Us";
        break;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: sh_white,
        iconTheme: IconThemeData(color: sh_textColorPrimary),
        actions: <Widget>[
          if (selectedTab < 3) ...{
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                ShSearchScreen().launch(context);
              },
            )
          }
        ],
        title: text(
          title,
          textColor: sh_textColorPrimary,
          fontFamily: fontBold,
          fontSize: textSizeNormal,
        ),
      ),
      body: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          fragments[selectedTab],
          Container(
            height: 58,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: <Widget>[
                Image.asset(
                  bg_bottom_bar,
                  width: width,
                  height: double.infinity,
                  fit: BoxFit.fill,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      tabItem(
                        0,
                        sh_ic_tag,
                      ),
                      tabItem(
                        1,
                        sh_ic_cart,
                      ),
                      tabItem(
                        2,
                        sh_ic_call,
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
      drawer: customDrawer(),
    );
  }

  Widget tabItem(var pos, var icon, {bool? notSVG}) {
    return GestureDetector(
      onTap: () {
        selectedTab = pos;
        setState(() {});
      },
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: selectedTab == pos
            ? BoxDecoration(
                shape: BoxShape.circle,
                color: sh_colorPrimary.withOpacity(0.2),
              )
            : BoxDecoration(),
        child: SvgPicture.asset(
          icon,
          width: 24,
          height: 24,
          color: selectedTab == pos ? sh_colorPrimary : sh_textColorSecondary,
        ),
      ),
    );
  }
}
