import 'dart:convert';
import 'package:cotton_natural/shopHop/api/MyResponse.dart';
import 'package:cotton_natural/shopHop/api/Network.dart';
import 'package:cotton_natural/shopHop/api/api_util.dart';
import 'package:cotton_natural/shopHop/models/ShCategory.dart';
import 'package:cotton_natural/shopHop/utils/InternetUtils.dart';


class CategoryController {

  //--------------------- Get Main Cats ---------------------------------------------//
  static Future<MyResponse<List<ShCategory>>> getMainCategories() async {

    String url = ApiUtil.MAIN_API_URL + ApiUtil.MAIN_CATEGORIES ;
    Map<String, String> headers = ApiUtil.getHeader(requestType: RequestType.Get);

    //Check Internet
    bool isConnected = await InternetUtils.checkConnection();
    if (!isConnected) {
      return MyResponse.makeInternetConnectionError();
    }

    try {
      NetworkResponse response = await Network.get(url, headers: headers);
      MyResponse<List<ShCategory>> myResponse = MyResponse(response.statusCode);

      if (ApiUtil.isResponseSuccess(response.statusCode)) {
        myResponse.success = true;
        myResponse.data = ShCategory.getCategoryList(json.decode(response.body));
      } else {
        myResponse.success = false;
        myResponse.setError(json.decode(response.body));
      }
      return myResponse;
    }catch(e){
      //If any server error...
      return MyResponse.makeServerProblemError<List<ShCategory>>();
    }
  }

  //--------------------- Get Sub Cats ---------------------------------------------//
  static Future<MyResponse<List<ShCategory>>> getSubCategory(String? categorySlug) async {

    String url = ApiUtil.MAIN_API_URL + ApiUtil.SUB_CATEGORIES + categorySlug! ;
    Map<String, String> headers = ApiUtil.getHeader(requestType: RequestType.Get);

    //Check Internet
    bool isConnected = await InternetUtils.checkConnection();
    if (!isConnected) {
      return MyResponse.makeInternetConnectionError();
    }

    try {
      NetworkResponse response = await Network.get(url, headers: headers);
      MyResponse<List<ShCategory>> myResponse = MyResponse(response.statusCode);

      if (ApiUtil.isResponseSuccess(response.statusCode)) {
        myResponse.success = true;
        myResponse.data = ShCategory.getCategoryList(json.decode(response.body));
      } else {
        myResponse.success = false;
        myResponse.setError(json.decode(response.body));
      }
      return myResponse;
    }catch(e){
      //If any server error...
      return MyResponse.makeServerProblemError<List<ShCategory>>();
    }
  }

}
