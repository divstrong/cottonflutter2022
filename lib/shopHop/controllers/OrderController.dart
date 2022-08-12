import 'dart:convert';
import 'dart:developer';

import 'package:cotton_natural/shopHop/api/MyResponse.dart';
import 'package:cotton_natural/shopHop/api/Network.dart';
import 'package:cotton_natural/shopHop/api/api_util.dart';
import 'package:cotton_natural/shopHop/models/Order.dart';
import 'package:cotton_natural/shopHop/models/ShPaymentCard.dart';
import 'package:cotton_natural/shopHop/utils/InternetUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AuthController.dart';

class OrderController {
  //--------------------- get Order List ---------------------------------------------//
  static Future<MyResponse<List<Order>>> getOrderList() async {
    String token = await AuthController.getApiToken() ?? '';
    String url = ApiUtil.MAIN_API_URL + ApiUtil.ORDER;
    Map<String, String> headers =
        ApiUtil.getHeader(requestType: RequestType.GetWithAuth, token: token);

    //Check Internet
    bool isConnected = await InternetUtils.checkConnection();
    if (!isConnected) {
      return MyResponse.makeInternetConnectionError();
    }

    try {
      NetworkResponse response = await Network.get(url, headers: headers);
      MyResponse<List<Order>> myResponse = MyResponse(response.statusCode);
      if (ApiUtil.isResponseSuccess(response.statusCode)) {
        myResponse.success = true;
        // log('json.decode(response.body) ${response.body}');
        myResponse.data = Order.getListFromJson(json.decode(response.body));
      } else {
        Map<String, dynamic> data = json.decode(response.body);
        myResponse.success = false;
        myResponse.setError(data);
      }
      return myResponse;
    } catch (e) {
      print('my error getOrderList : ${e.toString()}');
      return MyResponse.makeServerProblemError<List<Order>>();
    }
  }

  //------------------------ Get single order -----------------------------------------//
  static Future<MyResponse<Order_data>> getSingleOrder(int? id) async {
    //Getting User Api Token
    String token = await AuthController.getApiToken() ?? '';
    String url = ApiUtil.MAIN_API_URL + ApiUtil.ORDER_DETAIL + id!.toString();
    Map<String, String> headers =
    ApiUtil.getHeader(requestType: RequestType.GetWithAuth, token: token);

    //Check Internet
    bool isConnected = await InternetUtils.checkConnection();
    if (!isConnected) {
      return MyResponse.makeInternetConnectionError();
    }

    try {
      NetworkResponse response = await Network.get(url, headers: headers);
      MyResponse<Order_data> myResponse = MyResponse(response.statusCode);
      if (ApiUtil.isResponseSuccess(response.statusCode)) {
        myResponse.success = true;
        myResponse.data = Order_data.fromJson( json.decode(response.body));
      } else {
        Map<String, dynamic> data = json.decode(response.body);
        myResponse.success = false;
        myResponse.setError(data);
      }
      return myResponse;
    } catch (e) {
      //If any server error...
      print('my error getSingleOrder : ${e.toString()}');
      return MyResponse.makeServerProblemError();
    }
  }


  static saveCardToSharePreferences(ShPaymentCard newCard) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('cardNo', newCard.cardNo);
    await sharedPreferences.setString('year', newCard.year);
    await sharedPreferences.setString('month', newCard.month);
    await sharedPreferences.setString('cvv', newCard.cvv);
    await sharedPreferences.setString('holderName', newCard.holderName);
  }

  static Future<ShPaymentCard> getCardFromSharePreferences( ) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String cardNo = await sharedPreferences.getString('cardNo') ?? "";
    String year = await sharedPreferences.getString('year') ?? "";
    String month = await sharedPreferences.getString('month') ?? "";
    String cvv = await sharedPreferences.getString('cvv') ?? "";
    String holderName = await sharedPreferences.getString('holderName') ?? "";
    ShPaymentCard newCard = ShPaymentCard(cardNo: cardNo,year: year,month: month,cvv: cvv,holderName: holderName);
    return newCard;
  }

}
