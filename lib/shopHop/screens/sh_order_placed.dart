import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../main/utils/AppWidget.dart';
import '../providers/OrdersProvider.dart';
import '../utils/ShColors.dart';
import '../utils/ShConstant.dart';
import '../utils/ShImages.dart';
import '../utils/ShStrings.dart';
import 'ShHomeScreen.dart';

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
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
                width: 180,
              ),
              SizedBox(
                width: 300,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          Provider.of<OrdersProvider>(context, listen: false)
                              .resetOrdersProvider();
                          ShHomeScreen(
                            goToTabIndex: 0,
                          ).launch(context);
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
                              'Continue Shopping',
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
        ),
      ),
    );
  }
}
