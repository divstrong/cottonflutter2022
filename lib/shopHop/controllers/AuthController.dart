import 'dart:convert';

import 'package:cotton_natural/shopHop/api/MyResponse.dart';
import 'package:cotton_natural/shopHop/api/Network.dart';
import 'package:cotton_natural/shopHop/api/api_util.dart';
import 'package:cotton_natural/shopHop/utils/InternetUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  //--------------------- Log In ---------------------------------------------//
  static Future<MyResponse> loginUser(String email, String password) async {
    String loginUrl = ApiUtil.MAIN_API_URL + ApiUtil.AUTH_LOGIN;
    Map<String, String> header =
        ApiUtil.getHeader(requestType: RequestType.Post);
    Map data = {'email': email, 'password': password};
    String body = json.encode(data);

    //Check Internet
    bool isConnected = await InternetUtils.checkConnection();
    if (!isConnected) {
      return MyResponse.makeInternetConnectionError();
    }

    //Response
    try {
      NetworkResponse response =
          await Network.post(loginUrl, headers: header, body: body);
      MyResponse myResponse = MyResponse(response.statusCode);
      if (response.statusCode == 200) {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        Map<String, dynamic> data = json.decode(response.body);
        Map<String, dynamic> user = data['user'];
        String token = data['token'];
        await saveUser(user);
        await sharedPreferences.setString('token', token);

        myResponse.success = true;
      } else {
        Map<String, dynamic> data = json.decode(response.body);
        myResponse.success = false;
        myResponse.setError(data);
      }
      return myResponse;
    } catch (e) {
      print(e.toString());
      return MyResponse.makeServerProblemError();
    }
  }

  //--------------------- Register  ---------------------------------------------//
  static Future<MyResponse> registerUser(
      String name, String email, String password) async {
    //URL
    String registerUrl = ApiUtil.MAIN_API_URL + ApiUtil.AUTH_REGISTER;

    //Body
    Map data = {'name': name, 'email': email, 'password': password};

    //Encode
    String body = json.encode(data);

    //Check Internet
    bool isConnected = await InternetUtils.checkConnection();
    if (!isConnected) {
      return MyResponse.makeInternetConnectionError();
    }

    //Response
    try {
      NetworkResponse response = await Network.post(
        registerUrl,
        headers: ApiUtil.getHeader(requestType: RequestType.Post),
        body: body,
      );

      MyResponse myResponse = MyResponse(response.statusCode);

      if (response.statusCode == 200) {
        myResponse.success = true;
      } else {
        Map<String, dynamic> data = json.decode(response.body);
        myResponse.success = false;
        myResponse.setError(data);
      }

      return myResponse;
    } catch (e) {
      print('my error : ${e.toString()}');
      //If any server error...
      return MyResponse.makeServerProblemError();
    }
  }

  //--------------------- Forgot Password ---------------------------------------------//
  static Future<MyResponse> forgotPassword(String email) async {
    String url = ApiUtil.MAIN_API_URL + ApiUtil.FORGOT_PASSWORD;

    //Body date
    Map data = {'email': email};

    //Encode
    String body = json.encode(data);

    //Check Internet
    bool isConnected = await InternetUtils.checkConnection();
    if (!isConnected) {
      return MyResponse.makeInternetConnectionError();
    }

    try {
      NetworkResponse response = await Network.post(
        url,
        headers: ApiUtil.getHeader(requestType: RequestType.Post),
        body: body,
      );

      MyResponse myResponse = MyResponse(response.statusCode);

      if (response.statusCode == 200) {
        myResponse.success = true;
      } else {
        Map<String, dynamic> data = json.decode(response.body);
        myResponse.success = false;
        myResponse.setError(data);
      }

      return myResponse;
    } catch (e) {
      return MyResponse.makeServerProblemError();
    }
  }

  //------------------------ Logout -----------------------------------------//
  static Future<bool> logoutUser() async {
    //Clear all Data
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    await sharedPreferences.remove('id');
    await sharedPreferences.remove('name');
    await sharedPreferences.remove('email');
    await sharedPreferences.remove('token');

    return true;
  }

  //------------------------ Save user in cache -----------------------------------------//
  static saveUser(Map<String, dynamic> user) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setInt('id', user['id']);
    await sharedPreferences.setString('name', user['name']);
    await sharedPreferences.setString('email', user['email']);
  }

  //------------------------ Get user from cache -----------------------------------------//

  //------------------------ Check user logged in or not -----------------------------------------//
  static Future<bool> isLoginUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString("token");
    if (token == null) {
      return false;
    }
    return true;
  }

  //------------------------ Get api token -----------------------------------------//
  static Future<String?> getApiToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString("token");
  }
}
