import 'package:flutter/material.dart';

enum RequestType { Post, Get, PostWithAuth, GetWithAuth }

class ApiUtil {
  /*----------------- Fpr development server -----------------*/
  static const String IP_ADDRESS =
      "staging.cottonnatural.com"; /*192.168.1.105 10.0.2.2/cottonlaravel/public cottonlaravel-o7458.ondigitalocean.app*/

  static const String PORT = "80";
  static const String API_VERSION = "v1";
  static const String USER_MODE = "user/";
  static const String BASE_URL = "https://" + IP_ADDRESS + "/";

  static const String MAIN_API_URL_DEV =
      BASE_URL + "api/" + API_VERSION + "/" + USER_MODE;

  //Main Url for production and testing
  static const String MAIN_API_URL = MAIN_API_URL_DEV;

  // ------------------ Status Code ------------------------//
  static const int SUCCESS_CODE = 200;
  static const int ERROR_CODE = 400;
  static const int UNAUTHORIZED_CODE = 401;

  //Custom codes
  static const int INTERNET_NOT_AVAILABLE_CODE = 500;
  static const int SERVER_ERROR_CODE = 501;
  static const int MAINTENANCE_CODE = 503;

  //------------------ Header ------------------------------//

  static Map<String, String> getHeader(
      {RequestType requestType = RequestType.Get, String token = ""}) {
    switch (requestType) {
      case RequestType.Post:
        return {
          "Accept": "application/json",
          "Content-type": "application/json"
        };
      case RequestType.Get:
        return {
          "Accept": "application/json",
        };
      case RequestType.PostWithAuth:
        return {
          "Accept": "application/json",
          "Content-type": "application/json",
          "Authorization": "Bearer " + token
        };
      case RequestType.GetWithAuth:
        return {
          "Accept": "application/json",
          "Authorization": "Bearer " + token
        };
    }
    //Not reachable
  }

  // ----------------------  Body --------------------------//
  static Map<String, dynamic> getPatchRequestBody() {
    return {'_method': 'PATCH'};
  }

  //------------------- API LINKS ------------------------//

  //Maintenance
  static const String MAINTENANCE = "maintenance/";

  //App Data
  static const String CONTACT_US = "contact_us/";

  //User
  static const String USER = "user/";

  //Auth
  static const String AUTH_LOGIN = "login/";
  static const String AUTH_REGISTER = "register/";

  //Forgot password
  static const String FORGOT_PASSWORD = "password/email";

  //CATEGORY
  static const String MAIN_CATEGORIES = "categories/";
  static const String SUB_CATEGORIES = "categories/";

  //PRODUCT
  static const String SUB_CATEGORY_PRODUCTS = "products/";

  //WISH
  static const String TOGGLE_WISH = "toggle_wish/";
  static const String INIT_IS_WISHED = "init_is_wished/";
  static const String GET_WISH_PRODUCTS = "get_wish_products/";
  static const String REMOVE_FROM_WISH = "remove_wish/";

  //SEARCH
  static const String SEARCH = 'search';

  //Order
  static const String ORDER = "orders/";
  static const String ORDER_DETAIL = "order/";

  //Payment
  static const String PAYMENT = "payment/";

  //----------------- Redirects ----------------------------------//
  static checkRedirectNavigation(BuildContext context, int statusCode) async {
    switch (statusCode) {
      case SUCCESS_CODE:
      case ERROR_CODE:
        return;
      case UNAUTHORIZED_CODE:
        // await AuthController.logoutUser();
        // Navigator.pushAndRemoveUntil(
        //   context,
        //   MaterialPageRoute(
        //     builder: (BuildContext context) => ShSignIn(),
        //   ),
        //   (route) => false,
        // );
        return;
      case MAINTENANCE_CODE:
      case SERVER_ERROR_CODE:
        // Navigator.pushAndRemoveUntil(
        //   context,
        //   MaterialPageRoute(
        //     builder: (BuildContext context) => MaintenanceScreen(),
        //   ),
        //   (route) => false,
        // );
        return;
    }
    return;
  }

  static bool isResponseSuccess(int responseCode) {
    return responseCode >= 200 && responseCode < 300;
  }
}
