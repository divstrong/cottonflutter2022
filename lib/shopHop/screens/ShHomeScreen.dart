import 'package:cotton_natural/main/utils/AppWidget.dart';
import 'package:cotton_natural/shopHop/controllers/CategoryController.dart';
import 'package:cotton_natural/shopHop/screens/ShHomeFragment.dart';
import 'package:cotton_natural/shopHop/screens/ShSearchScreen.dart';
import 'package:cotton_natural/shopHop/screens/sh_call_us.dart';
import 'package:cotton_natural/shopHop/utils/ShColors.dart';
import 'package:cotton_natural/shopHop/utils/ShConstant.dart';
import 'package:cotton_natural/shopHop/utils/ShImages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_wp_woocommerce/woocommerce.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ShOrderSummaryScreen.dart';

class ShHomeScreen extends StatefulWidget {
  static String tag = '/ShHomeScreen';
  final int? goToTabIndex;
  ShHomeScreen({this.goToTabIndex});
  @override
  ShHomeScreenState createState() => ShHomeScreenState();
}

class ShHomeScreenState extends State<ShHomeScreen> {
  List<WooProductCategory> list = [];
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
    fetchData();
  }

  fetchData() async {
    final catController =
        Provider.of<CategoryController>(context, listen: false);
    await catController.fetchMainCategories().then(
          (value) => list = catController.getMainCategory,
        );
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
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.80,
        height: MediaQuery.of(context).size.height,
        child: Drawer(
          elevation: 8,
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: sh_white,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 70,
                            right: spacing_large,
                          ),
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: spacing_middle),
                              Image.asset(ic_app_icon, width: 80),
                              SizedBox(height: spacing_middle),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  ListView.builder(
                    padding: EdgeInsets.all(0.0),
                    scrollDirection: Axis.vertical,
                    itemCount: list.length,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemBuilder: (context, index) {
                      return getDrawerItem(
                        list[index].name,
                        callback: () {
                          // ToDO return;
                          // ShSubCategory(category: list[index]).launch(context);
                        },
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  getDrawerItem(
                    'Shipping & Handling',
                    callback: () async {
                      const String url =
                          'https://www.cottonnatural.com/shipping-and-handling/';
                      await launch(
                        url,
                        forceSafariVC: true,
                        forceWebView: false,
                        enableJavaScript: true,
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  getDrawerItem(
                    'Warranty & Returns',
                    callback: () async {
                      const String url =
                          'https://www.cottonnatural.com/warranty-and-return/';
                      await launch(
                        url,
                        forceSafariVC: true,
                        forceWebView: false,
                        enableJavaScript: true,
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  getDrawerItem(
                    'Wholesale',
                    callback: () async {
                      const String url =
                          'https://cottonlaravel-o7458.ondigitalocean.app/wholesale';
                      await launch(
                        url,
                        forceSafariVC: true,
                        forceWebView: false,
                        enableJavaScript: true,
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  getDrawerItem(
                    'Retail Locations',
                    callback: () async {
                      const String url =
                          'https://cottonlaravel-o7458.ondigitalocean.app/retail';
                      await launch(
                        url,
                        forceSafariVC: true,
                        forceWebView: false,
                        enableJavaScript: true,
                      );
                    },
                  ),
                  SizedBox(height: 30),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(34),
                    child: Column(
                      children: <Widget>[
                        Image.asset(ic_app_icon, width: 80),
                        text(
                          "v 1.0",
                          textColor: sh_textColorPrimary,
                          fontSize: textSizeSmall,
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getDrawerItem(String? name, {VoidCallback? callback}) {
    return InkWell(
      onTap: callback,
      child: Container(
        color: sh_white,
        padding: EdgeInsets.fromLTRB(20, 14, 20, 14),
        child: Row(
          children: <Widget>[
            SizedBox(width: 20),
            text(
              name,
              textColor: sh_textColorPrimary,
              fontSize: textSizeMedium,
              fontFamily: fontMedium,
            )
          ],
        ),
      ),
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
