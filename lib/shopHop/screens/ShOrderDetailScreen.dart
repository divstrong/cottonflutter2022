import 'package:cotton_natural/main/utils/AppWidget.dart';
import 'package:cotton_natural/main/utils/common.dart';
import 'package:cotton_natural/shopHop/api/MyResponse.dart';
import 'package:cotton_natural/shopHop/api/api_util.dart';
import 'package:cotton_natural/shopHop/controllers/OrderController.dart';
import 'package:cotton_natural/shopHop/models/Order.dart';
import 'package:cotton_natural/shopHop/utils/ShColors.dart';
import 'package:cotton_natural/shopHop/utils/ShConstant.dart';
import 'package:cotton_natural/shopHop/utils/ShExtension.dart';
import 'package:cotton_natural/shopHop/utils/ShStrings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class ShOrderDetailScreen extends StatefulWidget {
  static String tag = '/ShOrderDetailScreen';
  Order? order;

  ShOrderDetailScreen({this.order});

  @override
  ShOrderDetailScreenState createState() => ShOrderDetailScreenState();
}

class ShOrderDetailScreenState extends State<ShOrderDetailScreen> {
  Order_data? orders;
  bool isLoadingMoreData = true;
  List<Item1> itemsList = [];

  @override
  void initState() {
    super.initState();
    _getOrderData();
  }

  _getOrderData() async {
    setState(() {
      isLoadingMoreData = true;
    });

    MyResponse<Order_data> myResponse =
        await OrderController.getSingleOrder(widget.order!.id);
    if (myResponse.success) {
      orders = myResponse.data;
      itemsList.clear();
      itemsList = orders!.itemsList!.items!;
    } else {
      ApiUtil.checkRedirectNavigation(context, myResponse.responseCode);
      toasty(context, myResponse.errorText);
    }
    setState(() {
      isLoadingMoreData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var item = (itemsList.length > 0)
        ? ListView.builder(
            itemCount: itemsList.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return Container(
                color: sh_itemText_background,
                margin: EdgeInsets.only(
                    left: spacing_standard_new,
                    right: spacing_standard_new,
                    top: spacing_standard_new),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      networkCachedImage(
                        itemsList[index].imageUrl.toString(),
                        aWidth: width * 0.3,
                        aHeight: width * 0.3,
                        fit: BoxFit.contain,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    height: spacing_standard,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: text(itemsList[index].name,
                                        textColor: sh_textColorPrimary,
                                        fontSize: textSizeLargeMedium,
                                        fontFamily: fontMedium),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0, top: spacing_control),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.black),
                                          padding: EdgeInsets.all(
                                              spacing_control_half),
                                          child: Icon(
                                            Icons.done,
                                            color: sh_white,
                                            size: 16,
                                          ),
                                        ),
                                        SizedBox(
                                          width: spacing_standard_new,
                                        ),
                                        text(itemsList[index].size,
                                            textColor: sh_textColorPrimary,
                                            fontSize: textSizeLargeMedium),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0, top: 4.0, bottom: 4.0),
                                    child: text(itemsList[index].name),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        text(
                                            itemsList[index]
                                                .price
                                                .toString()
                                                .toCurrencyFormat()!,
                                            textColor: sh_colorPrimary,
                                            fontSize: textSizeNormal,
                                            fontFamily: fontMedium),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          )
        : Center(
            child: text('No Product Found',
                textColor: sh_tomato, fontSize: textSizeMedium));
    var orderStatus = Container(
      height: width * 0.32,
      margin: EdgeInsets.all(16.0),
      padding: EdgeInsets.all(16.0),
      decoration:
          BoxDecoration(border: Border.all(color: sh_view_color, width: 1.0)),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 4.0),
                  width: 10.0,
                  height: 10.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.amber),
                ),
                Expanded(
                  child: VerticalDivider(
                    color: Colors.grey,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 4.0),
                  width: 10.0,
                  height: 10.0,
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
                ),
              ],
            ),
            SizedBox(
              width: spacing_standard_new,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  text(
                      widget.order!.createdAt!.substring(0, 10) +
                          "\n Order Placed",
                      maxLine: 2,
                      fontSize: textSizeMedium,
                      textColor: sh_textColorPrimary),
                  text(widget.order!.status!.toUpperCase(),
                      fontSize: textSizeMedium, textColor: sh_textColorPrimary),
                ],
              ),
            )
          ],
        ),
      ),
    );
    var shippingDetail = Container(
      margin: EdgeInsets.only(
          left: spacing_standard_new, right: spacing_standard_new),
      decoration:
          BoxDecoration(border: Border.all(color: sh_view_color, width: 1.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(spacing_standard_new,
                spacing_middle, spacing_standard_new, spacing_middle),
            child: text(sh_lbl_shipping_details,
                textColor: sh_textColorPrimary,
                fontSize: textSizeLargeMedium,
                fontFamily: fontMedium),
          ),
          Divider(
            height: 1,
            color: sh_view_color,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(spacing_standard_new,
                spacing_middle, spacing_standard_new, spacing_middle),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    text(sh_lbl_order_id),
                    text('#' + widget.order!.id.toString(),
                        textColor: sh_textColorPrimary, fontFamily: fontMedium),
                  ],
                ),
                SizedBox(
                  height: spacing_standard,
                ),
                Row(
                  children: <Widget>[
                    text(sh_lbl_order_date),
                    text(widget.order!.createdAt!.substring(0, 10),
                        textColor: sh_textColorPrimary, fontFamily: fontMedium),
                  ],
                ),
                SizedBox(
                  height: spacing_standard,
                ),
                Row(
                  children: <Widget>[
                    text(sh_lbl_shipping_charge),
                    text("\$" + widget.order!.shipping!,
                        textColor: sh_colorPrimary,
                        fontFamily: fontBold,
                        fontSize: textSizeLargeMedium),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
    var paymentDetail = Container(
      margin: EdgeInsets.only(
          left: spacing_standard_new,
          right: spacing_standard_new,
          top: spacing_standard_new),
      decoration:
          BoxDecoration(border: Border.all(color: sh_view_color, width: 1.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(spacing_standard_new,
                spacing_middle, spacing_standard_new, spacing_middle),
            child: text(sh_lbl_payment_details,
                textColor: sh_textColorPrimary,
                fontSize: textSizeLargeMedium,
                fontFamily: fontMedium),
          ),
          Divider(
            height: 1,
            color: sh_view_color,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(spacing_standard_new,
                spacing_middle, spacing_standard_new, spacing_middle),
            child: Column(
              children: <Widget>[
                // Row(
                //   children: <Widget>[
                //     text(sh_lbl_offer),
                //     text(sh_text_offer_not_available, textColor: sh_textColorPrimary, fontFamily: fontMedium),
                //   ],
                // ),
                // SizedBox(
                //   height: spacing_standard,
                // ),
                // Row(
                //   children: <Widget>[
                //     text(sh_lbl_shipping_charge),
                //     text(widget.order!.shippingMethod!, textColor: Colors.green, fontFamily: fontMedium),
                //   ],
                // ),
                SizedBox(
                  height: spacing_standard,
                ),
                Row(
                  children: <Widget>[
                    text(sh_lbl_total_amount),
                    text("\$" + widget.order!.total!,
                        textColor: sh_colorPrimary,
                        fontFamily: fontBold,
                        fontSize: textSizeLargeMedium),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: sh_white,
        title: text(sh_lbl_my_orders,
            textColor: sh_textColorPrimary,
            fontSize: textSizeNormal,
            fontFamily: fontBold),
        iconTheme: IconThemeData(color: sh_textColorPrimary),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            Container(
              height: itemsList.length > 0 ? itemsList.length * 150 : 150,
              child: item,
            ),
            orderStatus,
            shippingDetail,
            paymentDetail,
            SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }
}
