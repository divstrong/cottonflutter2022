import 'dart:convert';

import 'package:cotton_natural/shopHop/api/MyResponse.dart';
import 'package:cotton_natural/shopHop/api/Network.dart';
import 'package:cotton_natural/shopHop/api/api_util.dart';
import 'package:cotton_natural/shopHop/controllers/AuthController.dart';
import 'package:cotton_natural/shopHop/models/ShProduct.dart';
import 'package:cotton_natural/shopHop/utils/InternetUtils.dart';

class WishController{

  //--------------------- toggle wish ---------------------------------------------//
  static Future<MyResponse> toggleWish(int? productId) async {

    String url = ApiUtil.MAIN_API_URL + ApiUtil.TOGGLE_WISH + productId.toString() ;
    String token = await AuthController.getApiToken() ?? '';
    Map<String, String> headers = ApiUtil.getHeader(requestType: RequestType.PostWithAuth,token: token);

    //Check Internet
    bool isConnected = await InternetUtils.checkConnection();
    if (!isConnected) {
      return MyResponse.makeInternetConnectionError();
    }

    try {

      NetworkResponse response = await Network.post(url, headers: headers);
      MyResponse myResponse = MyResponse(response.statusCode);

      if (ApiUtil.isResponseSuccess(response.statusCode)) {
        myResponse.success = true;
        myResponse.data = json.decode(response.body);
      } else {
        myResponse.success = false;
        myResponse.setError(json.decode(response.body));
      }
      return myResponse;
    }catch(e){
      return MyResponse.makeServerProblemError();
    }
  }

  //--------------------- init Is Wished  ---------------------------------------------//
  static Future<MyResponse> initIsWished(int? productId) async {

    String url = ApiUtil.MAIN_API_URL + ApiUtil.INIT_IS_WISHED + productId.toString() ;
    String token = await AuthController.getApiToken() ?? '';
    Map<String, String> headers = ApiUtil.getHeader(requestType: RequestType.PostWithAuth,token: token);

    //Check Internet
    bool isConnected = await InternetUtils.checkConnection();
    if (!isConnected) {
      return MyResponse.makeInternetConnectionError();
    }

    try {
      NetworkResponse response = await Network.post(url, headers: headers);
      MyResponse myResponse = MyResponse(response.statusCode);

      if (ApiUtil.isResponseSuccess(response.statusCode)) {
        myResponse.success = true;
        myResponse.data = json.decode(response.body);
      } else {
        myResponse.success = false;
        myResponse.setError(json.decode(response.body));
      }
      return myResponse;
    }catch(e){
      return MyResponse.makeServerProblemError();
    }
  }

  //--------------------- get wish product ---------------------------------------------//
  static Future<MyResponse<List<ShProduct>>> getWishProducts() async {

    String url = ApiUtil.MAIN_API_URL + ApiUtil.GET_WISH_PRODUCTS ;
    String token = await AuthController.getApiToken() ?? '';
    Map<String, String> headers = ApiUtil.getHeader(requestType: RequestType.GetWithAuth,token: token);

    //Check Internet
    bool isConnected = await InternetUtils.checkConnection();
    if (!isConnected) {
      return MyResponse.makeInternetConnectionError();
    }

    try {

      NetworkResponse response = await Network.get(url, headers: headers);
      MyResponse<List<ShProduct>> myResponse = MyResponse(response.statusCode);

      if (ApiUtil.isResponseSuccess(response.statusCode)) {
        myResponse.success = true;
        myResponse.data = ShProduct.getListFromJson(json.decode(response.body));
      } else {
        myResponse.success = false;
        myResponse.setError(json.decode(response.body));
      }
      return myResponse;
    }catch(e){
      return MyResponse.makeServerProblemError<List<ShProduct>>();
    }
  }

  //--------------------- remove from wish  ---------------------------------------------//
  static Future<MyResponse> removeWish(int? productId) async {

    String url = ApiUtil.MAIN_API_URL + ApiUtil.REMOVE_FROM_WISH + productId.toString() ;
    String token = await AuthController.getApiToken() ?? '';
    Map<String, String> headers = ApiUtil.getHeader(requestType: RequestType.GetWithAuth,token: token);

    //Check Internet
    bool isConnected = await InternetUtils.checkConnection();
    if (!isConnected) {
      return MyResponse.makeInternetConnectionError();
    }

    try {

      NetworkResponse response = await Network.get(url, headers: headers);
      MyResponse myResponse = MyResponse(response.statusCode);

      if (ApiUtil.isResponseSuccess(response.statusCode)) {
        myResponse.success = true;
        myResponse.data = response.body.trim();
      } else {
        myResponse.success = false;
        myResponse.setError(json.decode(response.body));
      }
      return myResponse;
    }catch(e){
      return MyResponse.makeServerProblemError();
    }
  }

}