import 'package:cotton_natural/main/utils/AppWidget.dart';
import 'package:cotton_natural/main/utils/common.dart';
import 'package:cotton_natural/shopHop/controllers/AddressController.dart';
import 'package:cotton_natural/shopHop/controllers/ProductController.dart';
import 'package:cotton_natural/shopHop/models/ShAddress.dart';
import 'package:cotton_natural/shopHop/models/ShOrder.dart';
import 'package:cotton_natural/shopHop/providers/OrdersProvider.dart';
import 'package:cotton_natural/shopHop/screens/ShAddNewAddress.dart';
import 'package:cotton_natural/shopHop/screens/sh_order_placed.dart';
import 'package:cotton_natural/shopHop/utils/ShColors.dart';
import 'package:cotton_natural/shopHop/utils/ShConstant.dart';
import 'package:cotton_natural/shopHop/utils/ShStrings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wp_woocommerce/models/order_payload.dart';
import 'package:flutter_wp_woocommerce/woocommerce.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import 'ShAddNewBillToAddress.dart';

class ShOrderSummaryScreen extends StatefulWidget {
  static String tag = '/ShOrderSummaryScreen';

  @override
  ShOrderSummaryScreenState createState() => ShOrderSummaryScreenState();
}

class ShOrderSummaryScreenState extends State<ShOrderSummaryScreen> {
  WooCommerce wooCommerce = WooCommerce(
    baseUrl: base_url,
    consumerKey: api_Consumer_Key,
    consumerSecret: api_Consumer_Secret,
  );
  List<Item?> list = [];
  var selectedPosition = 0;
  List<String> images = [];
  var currentIndex = 0;
  var isLoaded = false;
  List<ShOrder> orderList = [];
  late ShAddressModel shipAddressModel;
  late ShAddressModel billAddressModel;
  var primaryColor;
  bool billAsShipping = false;

  final dateTimeController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    shipAddressModel =
        Provider.of<OrdersProvider>(context, listen: false).getAddress();
    billAddressModel =
        Provider.of<OrdersProvider>(context, listen: false).getBillAddress();
    if (isAddressEmpty()) {
      shipAddressModel = await AddressController.getShipToFromCachedData();
      billAddressModel = shipAddressModel;
      Provider.of<OrdersProvider>(context, listen: false)
          .setShipAddress(shipAddressModel);
      Provider.of<OrdersProvider>(context, listen: false)
          .setBillAddress(billAddressModel);
    }

    orderList =
        Provider.of<OrdersProvider>(context, listen: false).getOrderList();

    list.clear();
    orderList.forEach((element) {
      list.add(element.item);
    });
    setState(() {});

    setState(() {
      isLoaded = true;
    });
  }

  @override
  dispose() {
    dateTimeController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  bool isAddressEmpty() => (shipAddressModel == ShAddressModel.empty());

  bool isBillAddressEmpty() => (billAddressModel == ShAddressModel.empty());

  List<LineItems> orderItems() {
    List<LineItems> wooOrder = [];
    for (var product in list) {
      LineItems productItem = LineItems(
        name: product?.name,
        productId: product?.id.toInt(),
        quantity: product?.count.toInt(),
        total: product?.price,
      );
      wooOrder.add(productItem);
    }
    return wooOrder;
  }

  Future<void> _createOrder({
    required ShAddressModel shipTo,
    required ShAddressModel billTo,
  }) async {
    WooOrderPayloadBilling? billing = WooOrderPayloadBilling(
      firstName: billTo.name,
      address1: billTo.address,
      city: billTo.city,
      country: billTo.country,
      state: billTo.region,
      postcode: billTo.zip,
    );
    WooOrderPayloadShipping? shipping = WooOrderPayloadShipping(
      firstName: shipTo.name,
      address1: shipTo.address,
      city: shipTo.city,
      country: shipTo.country,
      state: shipTo.region,
      postcode: shipTo.zip,
    );
    List<LineItems> productItem = orderItems();
    WooOrderPayload order = WooOrderPayload(
      billing: billing,
      shipping: shipping,
      lineItems: productItem,
    );
    try {
      await wooCommerce
          .createOrder(order)
          .then(
            (value) => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => OrderPlaced()),
            ),
          )
          .then((value) => list.clear());
    } catch (e) {
      log("error sending Products $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    // address
    final nameShipTo = Text(
      shipAddressModel.name,
      style: TextStyle(fontFamily: fontRegular, fontSize: textSizeMedium),
    );
    final addressShipTo = Text(
      shipAddressModel.address,
      style: TextStyle(fontFamily: fontRegular, fontSize: textSizeMedium),
    );
    final cityShipTo = Text(
      shipAddressModel.city,
      style: TextStyle(fontFamily: fontRegular, fontSize: textSizeMedium),
    );
    final regionShipTo = Text(
      shipAddressModel.region,
      style: TextStyle(fontFamily: fontRegular, fontSize: textSizeMedium),
    );
    final countryShipTo = Text(
      shipAddressModel.country,
      style: TextStyle(fontFamily: fontRegular, fontSize: textSizeMedium),
    );
    final zipShipTo = Text(
      shipAddressModel.zip,
      style: TextStyle(fontFamily: fontRegular, fontSize: textSizeMedium),
    );

    // address
    final nameBillTo = Text(
      billAddressModel.name,
      style: TextStyle(fontFamily: fontRegular, fontSize: textSizeMedium),
    );
    final addressBillTo = Text(
      billAddressModel.address,
      style: TextStyle(fontFamily: fontRegular, fontSize: textSizeMedium),
    );
    final cityBillTo = Text(
      billAddressModel.city,
      style: TextStyle(fontFamily: fontRegular, fontSize: textSizeMedium),
    );
    final regionBillTo = Text(
      billAddressModel.region,
      style: TextStyle(fontFamily: fontRegular, fontSize: textSizeMedium),
    );
    final countryBillTo = Text(
      billAddressModel.country,
      style: TextStyle(fontFamily: fontRegular, fontSize: textSizeMedium),
    );
    final zipBillTo = Text(
      billAddressModel.zip,
      style: TextStyle(fontFamily: fontRegular, fontSize: textSizeMedium),
    );

    final bodySipTo = Container(
      child: Wrap(
        runSpacing: spacing_standard_new,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: text(
                  'Ship To:',
                  textColor: sh_textColorPrimary,
                  fontSize: textSizeXNormal,
                  fontFamily: fontBold,
                ),
              ),
            ],
          ),
          if (!(shipAddressModel == ShAddressModel.empty()))
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(child: nameShipTo),
                  ],
                ),
                isAddressEmpty() ? SizedBox() : addressShipTo,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(child: cityShipTo),
                    SizedBox(
                      width: spacing_standard_new,
                    ),
                    Expanded(child: regionShipTo),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(child: countryShipTo),
                    SizedBox(
                      width: spacing_standard_new,
                    ),
                    Expanded(child: zipShipTo),
                  ],
                ),
              ],
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () {
                  ShAddNewAddress().launch(context);
                },
                child: isAddressEmpty()
                    ? Container(
                        width: 250,
                        margin: const EdgeInsets.only(
                          top: spacing_standard_new,
                        ),
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            width: 1,
                            color: sh_colorPrimary.withOpacity(0.9),
                          ),
                        ),
                        child: Center(
                          child: text(
                            'Add Ship Address',
                            textColor: sh_colorPrimary,
                            fontSize: textSizeLargeMedium,
                            fontFamily: fontBold,
                          ),
                        ),
                      )
                    : text(
                        'Change Ship To',
                        textColor: sh_colorPrimary,
                        fontSize: textSizeSMedium,
                        fontFamily: fontRegular,
                        underline: true,
                      ),
              ),
            ],
          ),
        ],
      ),
    );

    final bodyBillTo = Container(
      child: Wrap(
        runSpacing: spacing_standard_new,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 5,
                child: text(
                  'Bill To:',
                  textColor: sh_textColorPrimary,
                  fontSize: textSizeXNormal,
                  fontFamily: fontBold,
                ),
              ),
              SizedBox(
                width: 150,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      activeColor: sh_colorPrimary,
                      value: billAsShipping,
                      onChanged: (bool? value) {
                        billAsShipping = value!;
                        if (value) {
                          billAddressModel = shipAddressModel;
                        }
                        setState(() {});
                      },
                    ),
                    Expanded(
                      child: text("Same As Ship To", fontSize: textSizeSmall),
                    ),
                  ],
                ),
              )
            ],
          ),
          if (!(billAddressModel == ShAddressModel.empty()))
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(child: nameBillTo),
                  ],
                ),
                isBillAddressEmpty() ? SizedBox() : addressBillTo,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(child: cityBillTo),
                    SizedBox(
                      width: spacing_standard_new,
                    ),
                    Expanded(child: regionBillTo),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(child: countryBillTo),
                    SizedBox(
                      width: spacing_standard_new,
                    ),
                    Expanded(child: zipBillTo),
                  ],
                ),
              ],
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () {
                  ShAddNewBillToAddress().launch(context);
                },
                child: isBillAddressEmpty()
                    ? Container(
                        width: 250,
                        margin: const EdgeInsets.only(
                          top: spacing_standard_new,
                        ),
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            width: 1,
                            color: sh_colorPrimary.withOpacity(0.9),
                          ),
                        ),
                        child: Center(
                          child: text(
                            'Add Bill Address',
                            textColor: sh_colorPrimary,
                            fontSize: textSizeLargeMedium,
                            fontFamily: fontBold,
                          ),
                        ),
                      )
                    : text(
                        'Change Bill To',
                        textColor: sh_colorPrimary,
                        fontSize: textSizeSMedium,
                        fontFamily: fontRegular,
                        underline: true,
                      ),
              ),
            ],
          ),
        ],
      ),
    );

    var cartList = isLoaded
        ? ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: list.length,
            shrinkWrap: true,
            padding: EdgeInsets.only(bottom: spacing_standard_new),
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.all(spacing_standard_new),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                          child: text(
                            'Items:',
                            textColor: sh_textColorPrimary,
                            fontSize: textSizeXNormal,
                            fontFamily: fontBold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: sh_itemText_background,
                    margin: EdgeInsets.only(
                      left: spacing_standard_new,
                      right: spacing_standard_new,
                      top: spacing_standard_new,
                    ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        height: spacing_standard,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 16.0),
                                        child: text(
                                          list[index]!.name,
                                          textColor: sh_textColorPrimary,
                                          fontSize: textSizeLargeMedium,
                                          fontFamily: fontMedium,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 16.0,
                                          top: spacing_control,
                                        ),
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.black,
                                              ),
                                              padding: EdgeInsets.all(
                                                spacing_control_half,
                                              ),
                                              child: Icon(
                                                Icons.done,
                                                color: sh_white,
                                                size: 12,
                                              ),
                                            ),
                                            SizedBox(
                                              width: spacing_standard,
                                            ),
                                            //
                                            text(
                                              ProductController.getSizeTypeText(
                                                list[index]!.size!,
                                              ),
                                              textColor: sh_textColorPrimary,
                                              fontSize: textSizeMedium,
                                            ),
                                            SizedBox(
                                              width: spacing_standard,
                                            ),
                                            Container(
                                              padding: EdgeInsets.fromLTRB(
                                                spacing_standard,
                                                1,
                                                spacing_standard,
                                                1,
                                              ),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: sh_view_color,
                                                  width: 1,
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  text(
                                                    "Qty: ${Provider.of<OrdersProvider>(context, listen: true).getItemQty(list[index]!.id.toInt(), list[index]!.size)}",
                                                    textColor:
                                                        sh_textColorPrimary,
                                                    fontSize: textSizeSMedium,
                                                  ),
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
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
              // return Chats(mListings[index], index);
            },
          )
        : Container();

    var addressContainer = isLoaded
        ? Container(
            width: double.infinity,
            // color: sh_item_background,
            padding: EdgeInsets.all(spacing_standard_new),
            // margin: EdgeInsets.all(spacing_standard_new),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  child: SingleChildScrollView(child: bodySipTo),
                  margin: EdgeInsets.all(16),
                ),
              ],
            ),
          )
        : Container();

    var billToAddressContainer = isLoaded
        ? Container(
            width: double.infinity,
            // color: sh_item_background,
            padding: EdgeInsets.all(spacing_standard_new),
            // margin: EdgeInsets.all(spacing_standard_new),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  child: SingleChildScrollView(child: bodyBillTo),
                  margin: EdgeInsets.all(16),
                ),
              ],
            ),
          )
        : Container();

    var submitOrder = list.length > 0
        ? SizedBox(
            width: 300,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: InkWell(
                    onTap: () => _createOrder(
                      billTo: billAddressModel,
                      shipTo: shipAddressModel,
                    ),
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
                          'Submit Order',
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
        : SizedBox();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: sh_white,
        title: text(
          sh_order_checkout,
          textColor: sh_textColorPrimary,
          fontSize: textSizeNormal,
          fontFamily: fontMedium,
        ),
        iconTheme: IconThemeData(color: sh_textColorPrimary),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildWholesale(
              title: "Ship Date",
              txtController: dateTimeController,
              keyBType: TextInputType.datetime,
              icon: Icons.calendar_today_outlined,
              isDateTime: true,
            ),
            buildWholesale(
              title: "Email",
              txtController: emailController,
              keyBType: TextInputType.emailAddress,
              icon: Icons.email_outlined,
              isDateTime: false,
            ),
            buildWholesale(
              title: "Phone",
              txtController: phoneController,
              keyBType: TextInputType.phone,
              icon: Icons.phone_outlined,
              isDateTime: false,
            ),
            Stack(
              alignment: Alignment.bottomLeft,
              children: <Widget>[
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 70.0),
                    child: Column(
                      children: <Widget>[
                        isLoaded ? addressContainer : Container(),
                        isLoaded ? billToAddressContainer : Container(),
                        cartList,
                        // paymentDetail,
                        images.isNotEmpty
                            ? Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: sh_view_color,
                                    width: 0.5,
                                  ),
                                ),
                                margin:
                                    const EdgeInsets.all(spacing_standard_new),
                                child: Image.asset(
                                  images[currentIndex],
                                  width: double.infinity,
                                  height: width * 0.4,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Container(),
                        submitOrder,
                        //? order total and Continue button
                        // Container(
                        //   color: sh_white,
                        //   child: bottomButtons,
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildWholesale({
    required String title,
    required TextEditingController txtController,
    required TextInputType keyBType,
    required IconData icon,
    required bool isDateTime,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          text(
            title,
            fontSize: textSizeNormal,
            fontFamily: fontSemibold,
          ),
          TextField(
            controller: txtController,
            keyboardType: keyBType,
            decoration: InputDecoration(
              suffixIcon: Icon(
                icon,
              ),
            ),
            onTap: isDateTime
                ? () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(), //get today's date
                      firstDate: DateTime
                          .now(), //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      log(
                        pickedDate,
                      ); //get the picked date in the format => 2022-07-04 00:00:00.000
                      String formattedDate = DateFormat('yyyy-MM-dd').format(
                        pickedDate,
                      ); // format date in required form here we use yyyy-MM-dd that means time is removed
                      log(
                        formattedDate,
                      ); //formatted date output using intl package =>  2022-07-04
                      //You can format date as per your need

                      setState(() {
                        txtController.text =
                            formattedDate; //set foratted date to TextField value.
                      });
                    } else {
                      print("Date is not selected");
                    }
                  }
                : null,
          ),
        ],
      ),
    );
  }

  bool validateAddress(BuildContext myContext) {
    if (isAddressEmpty()) {
      toasty(myContext, 'Address is empty');
      return false;
    }
    return true;
  }
}
