import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main/utils/AppWidget.dart';
import '../utils/ShColors.dart';
import '../utils/ShConstant.dart';
import '../utils/ShImages.dart';
import '../utils/ShStrings.dart';

class OrderPlaced extends StatelessWidget {
  const OrderPlaced({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: sh_white,
        title: text(
          sh_order_placed_title,
          textColor: sh_textColorPrimary,
          fontSize: textSizeNormal,
          fontFamily: fontMedium,
        ),
        iconTheme: IconThemeData(color: sh_textColorPrimary),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          text(
            sh_order_Placed_header,
            isCentered: true,
            textColor: sh_black,
            maxLine: 3,
            fontSize: textSizeLarge,
            fontFamily: fontBold,
          ),
          SizedBox(
            height: 20,
          ),
          text(
            sh_order_Placed_body,
            textColor: sh_textColorSecondary,
            isCentered: true,
            maxLine: 5,
            fontSize: textSizeNormal,
            fontFamily: fontMedium,
          ),
          Image.asset(
            ic_app_icon,
            width: 200,
          ),
          SizedBox(
            width: 300,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      const String url =
                          'https://cottonlaravel-o7458.ondigitalocean.app/';
                      await launch(
                        url,
                        forceSafariVC: true,
                        forceWebView: false,
                        enableJavaScript: true,
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(
                        top: spacing_standard_new,
                      ),
                      padding: const EdgeInsets.only(
                        top: 10,
                        bottom: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: sh_colorPrimary.withOpacity(0.9),
                      ),
                      child: Center(
                        child: text(
                          'Visit Website',
                          textColor: sh_white,
                          fontSize: textSizeLargeMedium,
                          fontFamily: fontBold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
