import 'package:cotton_natural/main/utils/common.dart';
import 'package:cotton_natural/shopHop/models/ShOrder.dart';
import 'package:cotton_natural/shopHop/models/ShProduct.dart';
import 'package:cotton_natural/shopHop/providers/OrdersProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:cotton_natural/main/utils/AppWidget.dart';
import 'package:cotton_natural/shopHop/screens/ShOrderSummaryScreen.dart';
import 'package:cotton_natural/shopHop/utils/ShColors.dart';
import 'package:cotton_natural/shopHop/utils/ShConstant.dart';
import 'package:cotton_natural/shopHop/utils/ShExtension.dart';
import 'package:cotton_natural/shopHop/utils/ShStrings.dart';
import 'package:provider/provider.dart';

class ShCartFragment extends StatefulWidget {
  static String tag = '/ShProfileFragment';

  @override
  ShCartFragmentState createState() => ShCartFragmentState();
}

class ShCartFragmentState extends State<ShCartFragment> {
  List<Item?> list = [];
  List<ShOrder> orderList=[];
  late String dropDownValue;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData()  {
    dropDownValue = Provider.of<OrdersProvider>(context,listen: false).getShippingMethod().id??'notset';

    orderList = Provider.of<OrdersProvider>(context,listen: false).getOrderList();

    list.clear();
    orderList.forEach((element) {list.add(element.item);});

    if(Provider.of<OrdersProvider>(context, listen: false).getOrderCount() < 1){
      Provider.of<OrdersProvider>(context, listen: false).resetOrdersProvider();
    }
    setState(() { });

    // var products = await loadCartProducts();
    // setState(() {
    //   list.clear();
    //   list.addAll(products);
    // });
    // list.forEach((element) {print(element!.name);});
    // print("${list[0]!.image![0]}");
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }


  shippingDropDown() {
    List<String> items = ['notset','standard', 'express'];
    return Container(
      width: 150,
      child: DropdownButton<String>(
        elevation: 10,
        iconSize: 30,
        style: TextStyle(color: Colors.blue),
        value:dropDownValue,
        isExpanded: true,
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text((value=='standard')?'Standard Delivery':(value=='express')?'Express Delivery':'Not Set'),
          );
        }).toList(),
        onChanged: (val) {
          dropDownValue = val!;
          setState(() { });
          Provider.of<OrdersProvider>(context, listen: false).setShippingMethod(shippingMethodName: dropDownValue);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var cartList = (Provider.of<OrdersProvider>(context, listen: false).getOrderCount() > 0)?
    ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: list.length,
        shrinkWrap: true,
        padding: EdgeInsets.only(bottom: spacing_standard_new),
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            color: sh_itemText_background,
            margin: EdgeInsets.only(left: spacing_standard_new, right: spacing_standard_new, top: spacing_standard_new),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  networkCachedImage(
                    list[index]!.image_url!,
                    aWidth: width * 0.32,
                    aHeight: width * 0.37,
                    fit: BoxFit.fill,
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
                                child: text(list[index]!.name, textColor: sh_textColorPrimary, fontSize: textSizeLargeMedium, fontFamily: fontMedium),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0, top: spacing_control),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black),
                                      padding: EdgeInsets.all(spacing_control_half),
                                      child: Icon(
                                        Icons.done,
                                        color: sh_white,
                                        size: 12,
                                      ),
                                    ),
                                    SizedBox(
                                      width: spacing_standard,
                                    ),
                                    text(ShProduct.getSizeTypeText(list[index]!.size!), textColor: sh_textColorPrimary, fontSize: textSizeMedium),
                                    SizedBox(
                                      width: spacing_standard,
                                    ),
                                    Container(
                                      padding: EdgeInsets.fromLTRB(spacing_standard, 1, spacing_standard, 1),
                                      decoration: BoxDecoration(border: Border.all(color: sh_view_color, width: 1)),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          IconButton(
                                            onPressed: (){
                                              Provider.of<OrdersProvider>(context, listen: false).increaseProductCount(list[index]!.id.toInt(),list[index]!.size);
                                            },
                                            icon: Icon(
                                              Icons.add,
                                              color: sh_textColorPrimary,
                                              size: 16,
                                            ),
                                          ),
                                          text("Qty: ${Provider.of<OrdersProvider>(context, listen: true).getItemQty(list[index]!.id.toInt(),list[index]!.size)}", textColor: sh_textColorPrimary, fontSize: textSizeSMedium),
                                          IconButton(
                                            onPressed: (){
                                              Provider.of<OrdersProvider>(context, listen: false).decreaseProductCount(list[index]!.id.toInt(),list[index]!.size);
                                              fetchData();
                                            },
                                            icon: Icon(
                                              Icons.remove,
                                              color: sh_textColorPrimary,
                                              size: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    text(list[index]!.price.toString().toCurrencyFormat(),textColor: sh_colorPrimary,fontSize: textSizeNormal,fontFamily: fontMedium),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 1,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                ],
                                mainAxisAlignment: MainAxisAlignment.center,
                              ),
                            ),
                            Container(
                              width: 1,
                              color: sh_view_color,
                              height: 35,
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: (){
                                  Provider.of<OrdersProvider>(context,listen: false).removeItemFromBasket(productId: list[index]!.id.toInt(),size: list[index]!.size);
                                  fetchData();
                                },
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.delete_outline,
                                      color: sh_textColorPrimary,
                                      size: 16,
                                    ),
                                    text(sh_lbl_remove, textColor: sh_textColorPrimary, fontSize: textSizeSmall)
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.center,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
          // return Chats(mListings[index], index);
        }):
    Center(
      child: Container(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Your Cart Is Empty',
              style: TextStyle(
                color: sh_textColorPrimary,
                fontFamily: fontSemibold,
                fontSize: textSizeNormal,
              ),
            ),
            Container(
              height: 200,
            ),
          ],
        ),
      ),
    );

    var paymentDetail = (Provider.of<OrdersProvider>(context, listen: false).getOrderCount() > 0)?
    Container(
      margin: EdgeInsets.fromLTRB(spacing_standard_new, spacing_standard_new, spacing_standard_new, 80),
      decoration: BoxDecoration(border: Border.all(color: sh_view_color, width: 1.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(spacing_standard_new, spacing_middle, spacing_standard_new, spacing_middle),
            child: text(sh_lbl_payment_details, textColor: sh_textColorPrimary, fontSize: textSizeLargeMedium, fontFamily: fontMedium),
          ),
          Divider(
            height: 1,
            color: sh_view_color,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(spacing_standard_new, spacing_middle, spacing_standard_new, spacing_middle),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: spacing_standard,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                      text('Shipping Type:'),shippingDropDown(),
                    ],
                ),
                Row(
                  children: <Widget>[
                      text(Provider.of<OrdersProvider>(context, listen: false).getShippingMethod().description, textColor: Colors.black54, fontFamily: fontRegular),
                    ],
                ),
                Row(
                  children: <Widget>[
                      text(sh_lbl_shipping_charge),
                      text(Provider.of<OrdersProvider>(context, listen: false).getShippingMethod().price.toCurrencyFormat(), textColor: sh_colorPrimary, fontFamily: fontMedium),
                    ],
                ),
                SizedBox(
                  height: spacing_standard,
                ),
                Row(
                  children: <Widget>[
                    text(sh_lbl_total_amount),
                    text(Provider.of<OrdersProvider>(context,listen: true).getTotalPrice(), textColor: sh_colorPrimary, fontFamily: fontBold, fontSize: textSizeLargeMedium),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    ):
    Container(height: 150,);

    var bottomButtons = Container(
      height: 65,
      decoration: BoxDecoration(boxShadow: [BoxShadow(color: sh_shadow_color, blurRadius: 10, spreadRadius: 2, offset: Offset(0, 3))], color: sh_white),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                text(Provider.of<OrdersProvider>(context,listen: true).getTotalPrice(), textColor: sh_textColorPrimary, fontFamily: fontBold, fontSize: textSizeLargeMedium),
                text('Order Total', fontSize: 14.0),
              ],
            ),
          ),
          Expanded(
            child: InkWell(
              child: Container(
                child: text(sh_lbl_continue, textColor: sh_white, fontSize: textSizeLargeMedium, fontFamily: fontMedium),
                color: sh_colorPrimary,
                alignment: Alignment.center,
                height: double.infinity,
              ),
              onTap: () {
                if(Provider.of<OrdersProvider>(context, listen: false).getOrderCount() > 0){
                  if(Provider.of<OrdersProvider>(context, listen: false).getShippingMethod().id == 'notset'){
                    toasty(context, 'Please Select A Shipping Method');
                  }else{
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (BuildContext context) =>  ShOrderSummaryScreen(),
                    //   ),
                    // );
                    ShOrderSummaryScreen().launch(context);
                  }
                }else{
                  toasty(context, 'Your Cart Is Empty');
                }

              },
            ),
          )
        ],
      ),
    );


    return Scaffold(
      body: Container(
        height: height,
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: <Widget>[
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 70.0),
                child: Column(
                  children: <Widget>[cartList, paymentDetail],
                ),
              ),
            ),
            Container(
              color: sh_white,
              padding: const EdgeInsets.only(bottom: 60),
              child: bottomButtons,
            )
          ],
        ),
      ),
    );
  }

}
