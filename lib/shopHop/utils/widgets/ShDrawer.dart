import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../main/utils/AppWidget.dart';
import '../ShColors.dart';
import '../ShConstant.dart';
import '../ShImages.dart';

class customDrawer extends StatefulWidget {
  const customDrawer({Key? key}) : super(key: key);

  @override
  State<customDrawer> createState() => _customDrawerState();
}

class _customDrawerState extends State<customDrawer> {
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                    Padding(
                      padding: const EdgeInsets.only(
                        top: spacing_middle + 70.0,
                        bottom: spacing_middle,
                      ),
                      child: Column(
                        children: <Widget>[
                          Image.asset(ic_app_icon, width: 80),
                          text(
                            "v 1.0",
                            textColor: sh_textColorPrimary,
                            fontSize: textSizeSmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 0,
                ),
                // ListView.builder(
                //   padding: EdgeInsets.all(0.0),
                //   scrollDirection: Axis.vertical,
                //   itemCount: list.length,
                //   shrinkWrap: true,
                //   physics: ScrollPhysics(),
                //   itemBuilder: (context, index) {
                //     return getDrawerItem(
                //       list[index].name,
                //       callback: () {
                //         // ToDO return;
                //         // ShSubCategory(category: list[index]).launch(context);
                //       },
                //     );
                //   },
                // ),
                SizedBox(height: 10),
                getDrawerItem(
                  'Shipping & Handling',
                  callback: () async {
                    const String url =
                        'https://www.cottonnatural.com/shipping-and-handling/';
                    await launchUrl(
                      Uri.parse(url),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                ),
                SizedBox(height: 10),
                getDrawerItem(
                  'Warranty & Returns',
                  callback: () async {
                    const String url =
                        'https://www.cottonnatural.com/warranty-and-return/';
                    await launchUrl(
                      Uri.parse(url),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                ),
                SizedBox(height: 10),
                getDrawerItem(
                  'Retail Locations',
                  callback: () async {
                    const String url =
                        'https://www.cottonnatural.com/retail-locations/';
                    await launchUrl(
                      Uri.parse(url),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
