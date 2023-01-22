import 'dart:convert';

import 'package:cotton_natural/shopHop/screens/sh_order_placed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wp_woocommerce/models/order_payload.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../main/utils/AppWidget.dart';
import '../../main/utils/common.dart';
import '../api/Network.dart';
import '../controllers/ProductController.dart';
import '../models/ShAddress.dart';
import '../models/ShOrder.dart';
import '../providers/OrdersProvider.dart';
import '../utils/ShColors.dart';
import '../utils/ShConstant.dart';
import '../utils/ShStrings.dart';

class OrderFinalize extends StatefulWidget {
  const OrderFinalize({
    Key? key,
    required this.shipDate,
  }) : super(key: key);

  final String shipDate;

  @override
  State<OrderFinalize> createState() => _OrderFinalizeState();
}

class _OrderFinalizeState extends State<OrderFinalize> {
  Map<String, Item?> itemListMap = {};
  var isLoaded = false;
  bool isSubmittingOrder = false;
  late ShAddressModel shipAddressModel;
  late ShAddressModel billAddressModel;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() {
    shipAddressModel =
        Provider.of<OrdersProvider>(context, listen: false).getShipAddress();
    billAddressModel =
        Provider.of<OrdersProvider>(context, listen: false).getBillAddress();

    _resetItemMap();

    setState(() {
      isLoaded = true;
    });
  }

  List<LineItems> _orderItems() {
    List<LineItems> wooOrder = itemListMap.values
        .toList()
        .map(
          (e) => LineItems(
            name: '${e?.id}-${e?.name}-${e?.size}',
            productId: e?.id.toInt(),
            quantity: e?.count.toInt(),
            total: e?.price,
          ),
        )
        .toList();
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
    List<LineItems> productItem = _orderItems();
    WooOrderPayload order = WooOrderPayload(
      billing: billing,
      shipping: shipping,
      lineItems: productItem,
    );

    isSubmittingOrder = true;
    setState(() {});

    bool isOrderCompleted = await _isOrderComplete(
      shipTo,
      billTo,
      productItem,
      order,
    );

    if (isOrderCompleted) {
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => OrderPlaced()),
      );

      _resetItemMap();
    } else {
      toasty(
        context,
        "Order could not be complete",
        bgColor: Colors.red,
        textColor: Colors.white,
      );
    }

    isSubmittingOrder = false;
    setState(() {});
  }

  Future<bool> _isOrderComplete(
    ShAddressModel shipTo,
    ShAddressModel billTo,
    List<LineItems> productItem,
    WooOrderPayload order,
  ) async {
    try {
      String title =
          '${DateFormat('dd/MM/yy').format(DateTime.now())}, ${billTo.name}';
      String content = '''
      <div class="flexdis">
  <div class="left">
    <div>Ship Date
      <strong>${_getValidData(widget.shipDate)}</strong>
    </div>

    <div>Name
      <strong>${_getValidData(billTo.name)}</strong>
    </div>

    <div>Phone
      <strong>${_getValidData(billTo.phone)}</strong>
    </div>

    <div>Email
      <strong>${_getValidData(billTo.email)}</strong>
    </div>

    <div>Ship To
      <strong>${_getValidData(shipTo.address)}</strong>
    </div>

    <div>Bill To
      <strong>${_getValidData(billTo.address)}</strong>
    </div>
  </div>

  <div class="right">Items:
  
    ${productItem.map(
                (e) {
                  Item? eItem = itemListMap[e.name];
                  return '''
                  <div class="flexitems"><img class="alignleft size-thumbnail wp-image-8629" src="${eItem?.image_url?.split('?')[0]}" alt="" width="80" height="80" />
      <div><strong>${eItem?.name}</strong>
        <strong>Qty: ${e.quantity.toString()}</strong>
      </div>
    </div>
                ''';
                },
              ).toList().join('\n\n')}
  </div>
</div>
      
      ''';

      await Network.post(
        'https://www.cottonnatural.com/wp-json/wp/v2/wholesale?title=$title&content=$content&status=private',
        headers: {
          'Authorization':
              'Basic ${base64.encode(utf8.encode('admin:J^VcBw4xguodmjfG(iVM@p&&'))}',
        },
      );

      await _sendEmail(
        shipTo,
        billTo,
        productItem,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _sendEmail(
    ShAddressModel shipTo,
    ShAddressModel billTo,
    List<LineItems> productItem,
  ) async {
    await Network.post(
      'https://api.postmarkapp.com/email/batch',
      headers: {
        'X-Postmark-Server-Token': '8178fc14-d635-46e3-9894-99834a5b2425',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(
        [billTo.email, 'jay@cottonnatural.com']
            .map(
              (e) => {
                "From": "info@divstrong.com",
                "To": e,
                "Subject": "Order Confirmation",
                "HtmlBody": '''
                    <table class="wrapper" width="100%">
    <tr>
        <td class="wrapper-inner" align="center">
            <table class="main" align="center">
                <tr>
                    <td class="header">
                    </td>
                </tr>
                <tr>
                    <td class="main-content">
                        <table width="600" cellpadding="0" cellspacing="0" border="0" align="center" class="em_main_table" style="table-layout:fixed;">
                            <tr>
                                <td height="40" class="em_height">&nbsp;</td>
                            </tr>
                            <tr>
                                <td align="center" class="em_aside"><a href="#" target="_blank" style="text-decoration:none;"><img src="https://www.cottonnatural.com/wp-content/uploads/2020/10/logo-transparent2.png" width="120" height="100" style="display:block;font-family: Arial, sans-serif; font-size:15px; line-height:18px; color:#30373b;  font-weight:bold;" border="0" alt="Cotton Natural" /></a></td>
                            </tr>
                            <tr>
                                <td height="30" class="em_height">&nbsp;</td>
                            </tr>
                        </table>

                        <table width="600" cellpadding="0" cellspacing="0" border="0" align="center" style="margin: 50px 100px;">
                            <tr>
                                <td height="16" class="em_height">&nbsp;</td>
                            </tr>
                            <tr>
                                <td align="left" style="font-family:'Rubik', Arial, sans-serif; font-size:22px;  color:#000000; text-decoration:none; font-weight:600;">
                                    Order Confirmation
                                </td>
                            </tr>
                            <tr>
                                <td height="5" class="em_height">&nbsp;</td>
                            </tr>
                            <tr>
                                <td align="left" style="font-family:'Rubik', Arial, sans-serif; font-size:16px;  color:#4f5a68; text-decoration:none; font-weight:300; margin: 50px;">
                                    The following order details have been received and one of our staff will be reaching out within two (2) days to process the order.
                                </td>
                            </tr>
                            
                            <tr>
                                <td height="46" class="em_height">&nbsp;</td>
                            </tr>
                            <tr>
                                <td align="left" style="font-family:'Rubik', Arial, sans-serif; font-size:22px;  color:#000000; text-decoration:none; font-weight:600;">
                                    Desired Ship Date: ${widget.shipDate}
                                </td>
                            </tr>
                            
                            <tr>
                                <td height="46" class="em_height">&nbsp;</td>
                            </tr>                
                            <table width="600" cellpadding="0" cellspacing="0" border="0" align="center" style="table-layout:fixed;">
                              <tr align="left">
                                <td width="280" align="left" style="font-family:'Rubik', Arial, sans-serif; font-size:22px;  color:#000000; text-decoration:none; font-weight:600;">Ship To:</td>
                                <td width="280" align="left" style="font-family:'Rubik', Arial, sans-serif; font-size:22px;  color:#000000; text-decoration:none; font-weight:600;">Bill To:</td>
                              </tr>
                              <tr align="left">
                                <td width="280" align="left" style="font-family:'Rubik', Arial, sans-serif; font-size:16px;  color:#4f5a68; text-decoration:none; font-weight:300; margin: 50px;">
                                    ${shipTo.name}
                                    <br/>
                                    ${shipTo.address}
                                    <br/>
                                    ${shipTo.phone}
                                </td>
                                <td width="280" align="left" style="font-family:'Rubik', Arial, sans-serif; font-size:16px;  color:#4f5a68; text-decoration:none; font-weight:300; margin: 50px;">
                                    ${billTo.name}
                                    <br/>
                                    ${billTo.address}
                                    <br/>
                                    ${billTo.phone}
                                </td>
                              </tr>
                            </table>

                            <tr>
                                <td height="6" class="em_height">&nbsp;</td>
                            </tr>
                            <table width="600" cellpadding="0" cellspacing="0" border="0" align="center" class="em_main_table border border-top" style="table-layout:fixed; margin-top: 10px; border: solid 1px #e5e5e5; border-top: solid 4px #01579b; ">
                                <tr>
                                    <td valign="left" class="em_aside">
                                        <table width="600" cellpadding="0" cellspacing="0" border="0" align="center" class="em_main_table" style="table-layout:fixed; ">

                                            <tr style="margin: 50px;">
                                                <td height="1" bgcolor="#d8e4f0" style="font-size:0px;line-height:0px; margin-top:10px;"><img src="https://www.sendwithus.com/assets/img/emailmonks/images/spacer.gif" width="1" height="1" alt="" style="display:block;" border="0" /></td>
                                            </tr>
                                            <td height="14" class="em_height">&nbsp;</td>
                                            <tr >
                                                <td style="font-family:'Rubik', Arial, sans-serif; font-size:17px;  color:#232425; text-decoration:none; font-weight:500; margin-right: 10px; ">
                                                    &nbsp; Items
                                                </td>
                                            </tr>
                                            <td height="10" class="em_height">&nbsp;</td>
                                            <tr>
                                            </tr>
                                            <tr>
                                                <td height="1" bgcolor="#d8e4f0" style="font-size:0px;line-height:0px;"><img src="https://www.sendwithus.com/assets/img/emailmonks/images/spacer.gif" width="1" height="1" alt="" style="display:block;" border="0" /></td>
                                            </tr>
                                            
                                            <table width="600" style="border-top: 1px solid #efefef " border="0" cellspacing="0" cellpadding="10">
                                              ${productItem.map((e) {
                          Item? eItem = itemListMap[e.name];
                          return '''
                                                <tr align="left">
                                                <td class="img-td" align="center"> <img src="${eItem?.image_url?.split('?')[0]}" width="70" height="90" style="border-radius: 4px;"/></td>
                                                <td width="350" style="font-family:'Rubik', Arial, sans-serif; font-size:16px;  color:#232425;">
                                                  <span>${eItem?.name}</span>
                                                  <br/>
                                                  <span style="font-family:'Rubik', Arial, sans-serif; font-size:13px;  color:#000000; margin-top:15px" >SIZE: ${ProductController.getSizeTypeText(eItem?.size ?? '')}</span>
                                                  <span style="font-family:'Rubik', Arial, sans-serif; font-size:13px;  color:#000000; margin-left: 15px" >QTY: ${e.quantity.toString()}</span>
                                                  <br/>
                                                </td>
                                              </tr>                                                
                                                ''';
                        }).toList().join('\n\n')}
                                            </table>

                                            <td height="41" class="em_height">&nbsp;</td>
                                            </tr>

                                        </table>
                            </table>

                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="footer">
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<!-- End wrapper table -->
                    ''',
                "MessageStream": "outbound",
              },
            )
            .toList(),
      ),
    );
  }

  String _getValidData(String data) {
    return data.isEmpty ? 'N/A' : data;
  }

  bool isShippingAddressEmpty() => (shipAddressModel == ShAddressModel.empty());

  bool isBillingAddressEmpty() => (billAddressModel == ShAddressModel.empty());

  void _resetItemMap() {
    itemListMap = Provider.of<OrdersProvider>(
      context,
      listen: false,
    ).getOrderList().asMap().map(
          (k, v) => MapEntry(
            '${v.item?.id}-${v.item?.name}-${v.item?.size}',
            v.item,
          ),
        );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    final bodyContact = Container(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: text(
                  'Contact:',
                  textColor: sh_textColorPrimary,
                  fontSize: textSizeXNormal,
                  fontFamily: fontBold,
                ),
              ),
            ],
          ),
          if (!(shipAddressModel == ShAddressModel.empty()))
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          '${shipAddressModel.name}   ${shipAddressModel.phone}',
                          style: TextStyle(
                            fontFamily: fontRegular,
                            fontSize: textSizeNormal,
                          ),
                        ),
                      ),
                    ],
                  ),
                  isShippingAddressEmpty()
                      ? SizedBox()
                      : Text(
                          shipAddressModel.email,
                          style: TextStyle(
                            fontFamily: fontRegular,
                            fontSize: textSizeNormal,
                          ),
                        ),
                  isShippingAddressEmpty()
                      ? SizedBox()
                      : Text(
                          shipAddressModel.address,
                          style: TextStyle(
                            fontFamily: fontRegular,
                            fontSize: textSizeNormal,
                          ),
                        ),
                ],
              ),
            ),
        ],
      ),
    );

    var contactContainer = isLoaded
        ? Container(
            width: double.infinity,
            padding: EdgeInsets.all(spacing_standard_new),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  child: SingleChildScrollView(child: bodyContact),
                  margin: EdgeInsets.all(16),
                ),
              ],
            ),
          )
        : Container();

    final bodyShipTo = Container(
      child: Column(
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
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          shipAddressModel.name,
                          style: TextStyle(
                            fontFamily: fontRegular,
                            fontSize: textSizeNormal,
                          ),
                        ),
                      ),
                    ],
                  ),
                  isShippingAddressEmpty()
                      ? SizedBox()
                      : Text(
                          shipAddressModel.address,
                          style: TextStyle(
                            fontFamily: fontRegular,
                            fontSize: textSizeNormal,
                          ),
                        ),
                ],
              ),
            ),
        ],
      ),
    );

    var shipToAddressContainer = isLoaded
        ? Container(
            width: double.infinity,
            padding: EdgeInsets.all(spacing_standard_new),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  child: SingleChildScrollView(child: bodyShipTo),
                  margin: EdgeInsets.all(16),
                ),
              ],
            ),
          )
        : Container();

    final bodyBillTo = Container(
      child: Column(
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
            ],
          ),
          if (!(billAddressModel == ShAddressModel.empty()))
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          billAddressModel.name,
                          style: TextStyle(
                            fontFamily: fontRegular,
                            fontSize: textSizeNormal,
                          ),
                        ),
                      ),
                    ],
                  ),
                  isBillingAddressEmpty()
                      ? SizedBox()
                      : Text(
                          billAddressModel.address,
                          style: TextStyle(
                            fontFamily: fontRegular,
                            fontSize: textSizeNormal,
                          ),
                        ),
                ],
              ),
            ),
        ],
      ),
    );

    var billToAddressContainer = isLoaded
        ? Container(
            width: double.infinity,
            padding: EdgeInsets.all(spacing_standard_new),
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

    var itemText = Padding(
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
    );

    var cartList = ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: itemListMap.length,
      shrinkWrap: true,
      padding: EdgeInsets.only(bottom: spacing_standard_new),
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        List<Item?> items = itemListMap.values.toList();
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                      items[index]!.image_url!,
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
                                  child: text(
                                    items[index]!.name,
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
                                          items[index]!.size ?? 'N/A',
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
                                              "Qty: ${Provider.of<OrdersProvider>(context, listen: true).getItemQty(items[index]!.id?.toInt(), items[index]!.size)}",
                                              textColor: sh_textColorPrimary,
                                              fontSize: textSizeSMedium,
                                            ),
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            Provider.of<OrdersProvider>(
                              context,
                              listen: false,
                            ).removeItemFromBasket(
                              productId: items[index]!.id.toInt(),
                              size: items[index]!.size,
                            );

                            _resetItemMap();
                          },
                          icon: Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
        // return Chats(mListings[index], index);
      },
    );

    var submitOrder = itemListMap.length > 0
        ? SizedBox(
            width: 300,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      await _createOrder(
                        billTo: billAddressModel,
                        shipTo: shipAddressModel,
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: spacing_standard_new,
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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              contactContainer,
              shipToAddressContainer,
              billToAddressContainer,
              itemText,
              cartList,
              (isSubmittingOrder)
                  ? Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : submitOrder,
            ],
          ),
        ),
      ),
    );
  }
}
