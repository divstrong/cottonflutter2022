
import 'package:cotton_natural/main/utils/common.dart';
import 'package:cotton_natural/shopHop/controllers/AddressController.dart';
import 'package:cotton_natural/shopHop/models/ShOrder.dart';
import 'package:cotton_natural/shopHop/providers/OrdersProvider.dart';
import 'package:cotton_natural/shopHop/screens/ShAddNewAddress.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cotton_natural/shopHop/models/ShAddress.dart';
import 'package:cotton_natural/shopHop/models/ShProduct.dart';
import 'package:cotton_natural/shopHop/screens/ShPaymentsScreen.dart';
import 'package:cotton_natural/shopHop/utils/ShColors.dart';
import 'package:cotton_natural/shopHop/utils/ShConstant.dart';
import 'package:cotton_natural/shopHop/utils/ShExtension.dart';
import 'package:cotton_natural/shopHop/utils/ShStrings.dart';
import 'package:cotton_natural/main/utils/AppWidget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class ShOrderSummaryScreen extends StatefulWidget {
  static String tag = '/ShOrderSummaryScreen';

  @override
  ShOrderSummaryScreenState createState() => ShOrderSummaryScreenState();
}

class ShOrderSummaryScreenState extends State<ShOrderSummaryScreen> {
  List<Item?> list = [];
  var selectedPosition = 0;
  List<String> images = [];
  var currentIndex = 0;
  var isLoaded = false;
  List<ShOrder> orderList=[];
  late ShAddressModel addressModel;
  var primaryColor;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    addressModel = Provider.of<OrdersProvider>(context,listen: false).getAddress();
    if(isAddressEmpty()){
      addressModel = await AddressController.getAddressFromSharePreferences();
      Provider.of<OrdersProvider>(context,listen: false).setAddress(addressModel);
    }

    orderList = Provider.of<OrdersProvider>(context,listen: false).getOrderList();

    list.clear();
    orderList.forEach((element) {list.add(element.item);});
    setState(() { });

    setState(() {
      isLoaded = true;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isAddressEmpty(){
    return (addressModel.name == '' && addressModel.address == '' && addressModel.city == '');
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    // address
    final name = Text(
      addressModel.name,
      style: TextStyle(fontFamily: fontBold, fontSize: textSizeXNormal),
    );
    final address = Text(
      addressModel.address,
      style: TextStyle(fontFamily: fontRegular, fontSize: textSizeMedium),
    );
    final city = Text(
      addressModel.city,
      style: TextStyle(fontFamily: fontRegular, fontSize: textSizeMedium),
    );
    final region = Text(
      addressModel.region,
      style: TextStyle(fontFamily: fontRegular, fontSize: textSizeMedium),
    );
    final country = Text(
      addressModel.country,
      style: TextStyle(fontFamily: fontRegular, fontSize: textSizeMedium),
    );
    final zip = Text(
      addressModel.zip,
      style: TextStyle(fontFamily: fontRegular, fontSize: textSizeMedium),
    );
    final email = Text(
      addressModel.email,
      style: TextStyle(fontFamily: fontRegular, fontSize: textSizeMedium),
    );



    final body = Container(
      child: Wrap(
          runSpacing: spacing_standard_new,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(child:  text('Shipping Address', textColor: sh_textColorPrimary, fontSize: textSizeLargeMedium, fontFamily: fontMedium),),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(child: name),
              ],
            ),
            isAddressEmpty()
              ? Center(child: text('Address Is Empty', textColor: sh_textColorPrimary, fontSize: textSizeLargeMedium, fontFamily: fontMedium),)
              :address,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(child: city),
                SizedBox(
                  width: spacing_standard_new,
                ),
                Expanded(child: region),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(child: country),
                SizedBox(
                  width: spacing_standard_new,
                ),
                Expanded(child: zip),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(child:  email),
              ],
            ),

            Row(
              children: <Widget>[
                Expanded(
                  child:InkWell(
                    onTap: (){
                      ShAddNewAddress().launch(context);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: spacing_standard_new,),
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: sh_colorPrimary.withOpacity(0.9),
                      ),
                      child:  Center(child: text(isAddressEmpty()? 'Add Address' : 'Edit Address', textColor: sh_white, fontSize: textSizeLargeMedium, fontFamily: fontRegular)),
                    ),
                  ),

                ),
              ],
            ),
            // Row(
            //   children: <Widget>[
            //     Expanded(
            //       child:InkWell(
            //         onTap: (){
            //           Provider.of<OrdersProvider>(context,listen: false).
            //           setAddress(ShAddressModel(name: '', zip: '', region: '', city: '', address: '', country: ''));
            //           print('address provider cleaned');
            //         },
            //         child: Container(
            //           margin: const EdgeInsets.only(top: spacing_standard_new,),
            //           padding: const EdgeInsets.only(top: spacing_standard_new, bottom: spacing_standard_new),
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(30),
            //             color: sh_colorPrimary.withOpacity(0.9),
            //           ),
            //           child:  Center(child: text( 'Empty Address Provider' , textColor: sh_white, fontSize: textSizeLargeMedium, fontFamily: fontRegular)),
            //         ),
            //       ),
            //
            //     ),
            //   ],
            // ),
            // Row(
            //   children: <Widget>[
            //     Expanded(
            //       child:InkWell(
            //         onTap: () async{
            //           await AddressController.saveAddressToSharePreferences(ShAddressModel(name: '', zip: '', region: '', city: '', address: '', country: ''));
            //           print('address SHP cleaned');
            //         },
            //         child: Container(
            //           margin: const EdgeInsets.only(top: spacing_standard_new,),
            //           padding: const EdgeInsets.only(top: spacing_standard_new, bottom: spacing_standard_new),
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(30),
            //             color: sh_colorPrimary.withOpacity(0.9),
            //           ),
            //           child:  Center(child: text( 'Empty Address ShP' , textColor: sh_white, fontSize: textSizeLargeMedium, fontFamily: fontRegular)),
            //         ),
            //       ),
            //
            //     ),
            //   ],
            // ),
          ]),
    );




    var cartList = isLoaded
        ? ListView.builder(
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
                        aWidth: width * 0.25,
                        aHeight: width * 0.3,
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
                                              text("Qty: ${Provider.of<OrdersProvider>(context, listen: true).getItemQty(list[index]!.id.toInt(),list[index]!.size)}", textColor: sh_textColorPrimary, fontSize: textSizeSMedium),
                                              // Icon(
                                              //   Icons.arrow_drop_down,
                                              //   color: sh_textColorPrimary,
                                              //   size: 16,
                                              // )
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
                                        text( list[index]!.price.toString().toCurrencyFormat(),
                                            textColor: sh_colorPrimary, fontSize: textSizeNormal, fontFamily: fontMedium),

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
              // return Chats(mListings[index], index);
            })
        : Container();
    var paymentDetail = Container(
      margin: EdgeInsets.fromLTRB(spacing_standard_new, spacing_standard_new, spacing_standard_new, spacing_standard_new),
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
    );
    var addressContainer = isLoaded
    ?Container(
      width: double.infinity,
      color: sh_item_background,
      padding: EdgeInsets.all(spacing_standard_new),
      margin: EdgeInsets.all(spacing_standard_new),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            child: SingleChildScrollView(child: body),
            margin: EdgeInsets.all(16),
          ),
        ],
      ),
    )
    :Container();
    var bottomButtons = Container(
      height: 60,
      decoration: BoxDecoration(boxShadow: [BoxShadow(color: sh_shadow_color, blurRadius: 10, spreadRadius: 2, offset: Offset(0, 3))], color: sh_white),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                text(Provider.of<OrdersProvider>(context,listen: true).getTotalPrice(), textColor: sh_textColorPrimary, fontFamily: fontBold, fontSize: textSizeLargeMedium),
                text('Order Total'),
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
                if(validateAddress(context)){
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>  ShPaymentsScreen(),
                    ),
                  );
                  // ShPaymentsScreen().launch(context);
                }
              },
            ),
          )
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: sh_white,
        title: text(sh_order_summary, textColor: sh_textColorPrimary, fontSize: textSizeNormal, fontFamily: fontMedium),
        iconTheme: IconThemeData(color: sh_textColorPrimary),
      ),
      body: Stack(
        alignment: Alignment.bottomLeft,
        children: <Widget>[
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 70.0),
              child: Column(
                children: <Widget>[
                  isLoaded ? addressContainer : Container(),
                  cartList,
                  paymentDetail,
                  images.isNotEmpty
                      ? Container(
                          decoration: BoxDecoration(border: Border.all(color: sh_view_color, width: 0.5)),
                          margin: const EdgeInsets.all(spacing_standard_new),
                          child: Image.asset(
                            images[currentIndex],
                            width: double.infinity,
                            height: width * 0.4,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
          Container(
            color: sh_white,
            child: bottomButtons,
          )
        ],
      ),
    );
  }

  bool validateAddress(BuildContext myContext) {
    if(isAddressEmpty()){
      toasty(myContext, 'Address is empty');
      return false;
    }
    return true;
  }



}
