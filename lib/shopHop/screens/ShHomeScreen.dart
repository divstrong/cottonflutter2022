import 'package:cotton_natural/main/utils/AppWidget.dart';
import 'package:cotton_natural/shopHop/api/MyResponse.dart';
import 'package:cotton_natural/shopHop/controllers/AuthController.dart';
import 'package:cotton_natural/shopHop/controllers/CategoryController.dart';
import 'package:cotton_natural/shopHop/models/Account.dart';
import 'package:cotton_natural/shopHop/models/ShCategory.dart';
import 'package:cotton_natural/shopHop/screens/ShAccountScreen.dart';
import 'package:cotton_natural/shopHop/screens/ShHomeFragment.dart';
import 'package:cotton_natural/shopHop/screens/ShOrderListScreen.dart';
import 'package:cotton_natural/shopHop/screens/ShProfileFragment.dart';
import 'package:cotton_natural/shopHop/screens/ShSearchScreen.dart';
import 'package:cotton_natural/shopHop/screens/ShWishlistFragment.dart';
import 'package:cotton_natural/shopHop/screens/sh_call_us.dart';
import 'package:cotton_natural/shopHop/utils/ShColors.dart';
import 'package:cotton_natural/shopHop/utils/ShConstant.dart';
import 'package:cotton_natural/shopHop/utils/ShImages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ShOrderSummaryScreen.dart';
import 'ShSubCategory.dart';

class ShHomeScreen extends StatefulWidget {
  static String tag = '/ShHomeScreen';
  final int? goToTabIndex;
  ShHomeScreen({this.goToTabIndex});
  @override
  ShHomeScreenState createState() => ShHomeScreenState();
}

class ShHomeScreenState extends State<ShHomeScreen> {
  List<ShCategory> list = [];
  var homeFragment = ShHomeFragment();
  var cartFragment = ShOrderSummaryScreen();
  var wishlistFragment = ShWishlistFragment();
  var profileFragment = ShAccountScreen();
  var loginFragment = CallUs();
  late var fragments;
  var selectedTab = 0;
  Account userAccount = Account(null, '', '', '');

  bool login = false;

  @override
  void initState() {
    super.initState();
    selectedTab = ((widget.goToTabIndex != null) ? widget.goToTabIndex : 0)!;
    fragments = [
      homeFragment,
      wishlistFragment,
      cartFragment,
      profileFragment,
      loginFragment
    ];
    fetchData();
  }

  fetchData() async {
    MyResponse<List<ShCategory>> myResponse =
        await CategoryController.getMainCategories();

    if (myResponse.success) {
      list.clear();
      list = myResponse.data;
      setState(() {});
    } else {
      toasty(context, myResponse.errorText);
    }

    login = await AuthController.isLoginUser();

    if (login) {
      userAccount = await AuthController.getAccount();
    } else {
      userAccount.name = "Guest User";
    }
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
        title = "Wishlist";
        break;
      case 2:
        title = "Cart Checkout";
        break;
      case 3:
        title = "Profile";
        break;
      case 4:
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
          } else if (selectedTab == 3) ...{
            IconButton(
              icon: Icon(Icons.edit_rounded),
              onPressed: () {
                ShProfileFragment().launch(context);
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
                      tabItem(0, sh_ic_tag),
                      // tabItem(1, sh_ic_heart),
                      tabItem(
                        2,
                        sh_ic_cart,
                      ),
                      if (login) ...{
                        tabItem(3, sh_user)
                      } else ...{
                        tabItem(4, sh_ic_call)
                      },
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
                  login
                      ? SizedBox(height: 30)
                      : SizedBox(
                          height: 0,
                        ),
                  login
                      ? Container(
                          color: sh_editText_background,
                          padding: EdgeInsets.fromLTRB(
                            0,
                            spacing_standard,
                            0,
                            spacing_standard,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    ShOrderListScreen().launch(context);
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(height: spacing_control),
                                      text(
                                        "My Order",
                                        textColor: sh_textColorPrimary,
                                        fontFamily: fontMedium,
                                      ),
                                      SizedBox(height: spacing_control),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    setState(() {
                                      selectedTab = 1;
                                    });
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(height: spacing_control),
                                      text(
                                        "Wishlist",
                                        textColor: sh_textColorPrimary,
                                        fontFamily: fontMedium,
                                      ),
                                      SizedBox(height: spacing_control),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : SizedBox(
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
                          ShSubCategory(category: list[index]).launch(context);
                        },
                      );
                    },
                  ),
                  // SizedBox(height: 30),
                  // Divider(color: sh_view_color, height: 1),
                  // SizedBox(height: 20),
                  // login
                  //     ? SizedBox()
                  //     : getDrawerItem(
                  //         'Login',
                  //         callback: () {
                  //           ShSignIn().launch(context);
                  //         },
                  //       ),
                  // getDrawerItem(
                  //   sh_lbl_settings,
                  //   callback: () {
                  //     ShSettingsScreen().launch(context);
                  //   },
                  // ),
                  // SizedBox(height: 10),
                  // getDrawerItem('Company', callback: () {}),
                  // SizedBox(height: 10),
                  // getDrawerItem(
                  //   'Payment Methods',
                  //   callback: () async {
                  //     const String url =
                  //         'https://cottonlaravel-o7458.ondigitalocean.app/payment-methods';
                  //     await launch(
                  //       url,
                  //       forceSafariVC: true,
                  //       forceWebView: false,
                  //       enableJavaScript: true,
                  //     );
                  //   },
                  // ),
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
