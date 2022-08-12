import 'dart:convert';
import 'dart:developer';

import 'package:cotton_natural/shopHop/api/MyResponse.dart';
import 'package:cotton_natural/shopHop/api/Network.dart';
import 'package:cotton_natural/shopHop/api/api_util.dart';
import 'package:cotton_natural/shopHop/models/ShAddress.dart';
import 'package:cotton_natural/shopHop/models/ShOrder.dart';
import 'package:cotton_natural/shopHop/models/ShPaymentCard.dart';
import 'package:cotton_natural/shopHop/utils/InternetUtils.dart';

import 'AuthController.dart';

class PaymentController {
  //--------------------- send Order Info To Make a Payment ---------------------------------------------//
  static Future<MyResponse> sendOrderInfo({
    required List<Item> items,
    required ShippingMethod shipping_method,
    required ShPaymentCard card,
    required ShAddressModel address,
    required double totalAmount,
  }) async {

    String token = await AuthController.getApiToken() ?? '';
    String url = ApiUtil.MAIN_API_URL + ApiUtil.ORDER_DETAIL + ApiUtil.PAYMENT;
    Map<String, String> headers = ApiUtil.getHeader(requestType: RequestType.PostWithAuth, token: token);

    Map itemsJson = {};
    int totalQty=0;

    for (var i=0;i<items.length;i++){
      totalQty += int.parse(items[i].count.toString());
      itemsJson[items[i].id.toString()]=items[i];
    }

    Map itemData = {
      'items':itemsJson,
      'subTotalPrice':totalAmount.toStringAsFixed(2),
      'totalPrice':totalAmount.toStringAsFixed(2),
      'totalQty':totalQty,
      'originalPrice':totalAmount.toStringAsFixed(2),
      'hasOrder':true,
      "couponApplied": false,
      "discountAmount": "0.00",
      "frameAmount": 0,
    };
    Map data = {
      'items':itemData,
      'shipping_method':shipping_method.id,
      'address':address.toJson(),
      'card':card.toJson(),
      'totalAmount':totalAmount.toStringAsFixed(2),
    };
    Object body = jsonEncode(data);
    // log('body : $body');
    //Check Internet
    bool isConnected = await InternetUtils.checkConnection();
    if (!isConnected) {
      return MyResponse.makeInternetConnectionError();
    }

    try {
      NetworkResponse response = await Network.post(url, headers: headers,body: body);
      // print('res statusCode : ${response.statusCode}');
      // log('res body: ${response.body}');

      MyResponse myResponse = MyResponse(response.statusCode);
      if (ApiUtil.isResponseSuccess(response.statusCode)) {
        myResponse.success = true;
        myResponse.data = json.decode(response.body);
      } else {
        Map<String, dynamic> data = json.decode(response.body);
        myResponse.success = false;
        myResponse.setError(data);
      }
      return myResponse;
    } catch (e) {
      print('error : ${e.toString()}');
      return MyResponse.makeServerProblemError();
    }
  }


}
