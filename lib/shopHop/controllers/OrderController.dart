import 'dart:convert';

import 'package:cotton_natural/shopHop/api/MyResponse.dart';
import 'package:cotton_natural/shopHop/api/Network.dart';
import 'package:cotton_natural/shopHop/api/api_util.dart';
import 'package:cotton_natural/shopHop/models/Order.dart';
import 'package:cotton_natural/shopHop/utils/InternetUtils.dart';

class OrderController {
  //--------------------- get Order List ---------------------------------------------//
  static Future<MyResponse<List<Order>>> getOrderList() async {
    String token = '';
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
    String token = '';
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
        myResponse.data = Order_data.fromJson(json.decode(response.body));
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
}
