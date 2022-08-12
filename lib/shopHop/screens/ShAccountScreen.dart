
import 'package:cotton_natural/shopHop/controllers/AuthController.dart';
import 'package:cotton_natural/shopHop/models/Account.dart';
import 'package:cotton_natural/shopHop/providers/OrdersProvider.dart';
import 'package:cotton_natural/shopHop/screens/ShHomeScreen.dart';
import 'package:cotton_natural/shopHop/utils/ShImages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cotton_natural/main/utils/AppWidget.dart';
import 'package:cotton_natural/shopHop/utils/ShColors.dart';
import 'package:cotton_natural/shopHop/utils/ShConstant.dart';
import 'package:cotton_natural/shopHop/utils/ShStrings.dart';
import 'package:provider/provider.dart';

import 'ShOrderListScreen.dart';
import 'package:nb_utils/nb_utils.dart';

class ShAccountScreen extends StatefulWidget {
  static String tag = '/ShAccountScreen';

  @override
  ShAccountScreenState createState() => ShAccountScreenState();
}

class ShAccountScreenState extends State<ShAccountScreen> {

  Account userAccount = Account(null, '', '', '') ;
  late bool isInProgress;

  @override
  void initState() {
    super.initState();
    isInProgress = false;
    _getUserAccount();
  }

  _getUserAccount()async{

      if(mounted) {
        setState(() {
          isInProgress = true;
        });
      }

      userAccount =  await AuthController.getAccount();

      if(mounted) {
        setState(() {
          isInProgress = false;
        });
      }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(spacing_standard_new),
                    child: Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: spacing_standard,
                      margin: EdgeInsets.all(spacing_control),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: CircleAvatar(
                          backgroundImage: AssetImage(ic_user),
                          radius: 55,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            text("${userAccount.name}", textColor: sh_textColorPrimary, fontFamily: fontBold, fontSize: textSizeLarge),
            SizedBox(
              height: 5,
            ),
            text("${userAccount.email}", textColor: sh_textColorPrimary, fontFamily: fontBold, fontSize: textSizeLarge),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.only(left: spacing_standard_new, bottom: spacing_standard_new, right: spacing_standard_new),
              child: Column(
                children: <Widget>[
                  // getRowItem(sh_lbl_address_manager, callback: () {
                  //   ShAddressManagerScreen().launch(context);
                  // }),
                  SizedBox(height: spacing_standard_new),
                  getRowItem(sh_lbl_my_order, callback: () {
                    ShOrderListScreen().launch(context);
                  }),
                  SizedBox(height: spacing_standard_new),
                  getRowItem(sh_lbl_wish_list, callback: () {
                    ShHomeScreen(goToTabIndex: 1,).launch(context);
                  }),
                  SizedBox(height: 30,),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    // height: double.infinity,
                    child: MaterialButton(
                      padding: EdgeInsets.all(spacing_standard),
                      child: text("Sign Out", fontSize: textSizeNormal, fontFamily: fontMedium, textColor: sh_colorPrimary),
                      textColor: sh_white,
                      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(40.0), side: BorderSide(color: sh_colorPrimary, width: 1)),
                      color: sh_white,
                      onPressed: () async {
                        await AuthController.logoutUser();
                        Provider.of<OrdersProvider>(context,listen:false).resetOrdersProvider();
                        ShHomeScreen().launch(context);
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getRowItem(String title, {VoidCallback? callback}) {
    return InkWell(
      onTap: callback,
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: sh_view_color, width: 1)),
        padding: EdgeInsets.fromLTRB(spacing_standard, 0, spacing_control_half, 0),
        child: Row(
          children: <Widget>[
            Expanded(child: text(title, textColor: sh_textColorPrimary, fontSize: textSizeMedium, fontFamily: fontMedium)),
            IconButton(
              icon: Icon(
                Icons.keyboard_arrow_right,
                color: sh_textColorPrimary,
                size: 24,
              ),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}
