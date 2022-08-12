import 'package:cotton_natural/main/utils/common.dart';
import 'package:cotton_natural/shopHop/api/MyResponse.dart';
import 'package:cotton_natural/shopHop/controllers/OrderController.dart';
import 'package:cotton_natural/shopHop/models/Order.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cotton_natural/shopHop/screens/ShOrderDetailScreen.dart';
import 'package:cotton_natural/shopHop/utils/ShColors.dart';
import 'package:cotton_natural/shopHop/utils/ShConstant.dart';
import 'package:cotton_natural/shopHop/utils/ShExtension.dart';
import 'package:cotton_natural/shopHop/utils/ShStrings.dart';
import 'package:cotton_natural/main/utils/AppWidget.dart';
import 'package:nb_utils/nb_utils.dart';

class ShOrderListScreen extends StatefulWidget {
  static String tag = '/ShOrderListScreen';

  @override
  ShOrderListScreenState createState() => ShOrderListScreenState();
}

class ShOrderListScreenState extends State<ShOrderListScreen> {
  List<Order> list = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }


  fetchData() async {
    List<Order> OrderList = [];
    MyResponse<List<Order>> myResponse = await OrderController.getOrderList();

    if (myResponse.success) {
      OrderList = myResponse.data;
    } else {
      // ApiUtil.checkRedirectNavigation(context, myResponse.responseCode);
      toasty(context, myResponse.errorText);
    }

    setState(() {
      list.clear();
      list.addAll(OrderList);
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var listView = ListView.builder(
      itemCount: list.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ShOrderDetailScreen(order: list[index])));
          },
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(border: Border.all(color: sh_view_color, width: 1)),
                    child:
                    (list[index].orderData.itemsList!.items!.first.imageUrl != '' )?
                    networkCachedImage(list[index].orderData.itemsList!.items!.first.imageUrl,
                        aWidth: width * 0.29, aHeight: width * 0.29, fit: BoxFit.contain)
                    : Image.asset("assets/app-icon1.jpg", fit: BoxFit.contain, height: width * 0.29, width: width * 0.29),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        text('#'+list[index].id.toString(), textColor: sh_textColorPrimary, fontFamily: fontMedium, fontSize: textSizeLargeMedium),
                        SizedBox(height: 4),
                        text(list[index].total.toString().toCurrencyFormat(), textColor: sh_colorPrimary, fontFamily: fontMedium, fontSize: textSizeNormal),
                        SizedBox(
                          height: spacing_standard,
                        ),
                        Expanded(
                          child: IntrinsicHeight(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Container(
                                      width: spacing_standard,
                                      height: spacing_standard,
                                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.yellow),
                                    ),
                                    Expanded(
                                      child: VerticalDivider(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Container(
                                      width: spacing_standard,
                                      height: spacing_standard,
                                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      text(list[index].createdAt!.substring(0,10) + "\n Order Placed", maxLine: 2, fontSize: textSizeSmall, textColor: sh_textColorPrimary),
                                      text(list[index].status!.toUpperCase(), fontSize: textSizeSmall, textColor: sh_textColorPrimary),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: sh_white,
        title: text(sh_lbl_my_orders, textColor: sh_textColorPrimary, fontSize: textSizeNormal, fontFamily: fontBold),
        iconTheme: IconThemeData(color: sh_textColorPrimary),
      ),
      body: Container(width: width, child: listView),
    );
  }
}
