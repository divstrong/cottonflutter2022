import 'dart:convert';
import 'package:cotton_natural/shopHop/api/MyResponse.dart';
import 'package:cotton_natural/shopHop/api/Network.dart';
import 'package:cotton_natural/shopHop/api/api_util.dart';
import 'package:cotton_natural/shopHop/models/ShAddress.dart';
import 'package:cotton_natural/shopHop/utils/InternetUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AddressController {

  //--------------------- Log In ---------------------------------------------//
  static Future<MyResponse> loginUser() async {

    String loginUrl = ApiUtil.MAIN_API_URL + ApiUtil.AUTH_LOGIN;
    Map<String, String> header = ApiUtil.getHeader(requestType: RequestType.Post);
    Map data = {};
    String body = json.encode(data);

    //Check Internet
    bool isConnected = await InternetUtils.checkConnection();

    if (!isConnected) {
      return MyResponse.makeInternetConnectionError();
    }

    //Response
    try {
      NetworkResponse response = await Network.post(loginUrl, headers: header, body: body );
      MyResponse myResponse = MyResponse(response.statusCode);
      print('rrrrrrrr : ${response.statusCode}');
      print('bbbbbbbbbbbbbb : ${response.body}');
      if (response.statusCode == 200) {

        myResponse.success = true;
      } else {
        Map<String, dynamic> data = json.decode(response.body);
        myResponse.success = false;
        myResponse.setError(data);
      }
      return myResponse;
    }catch(e){
      print(e.toString());
      return MyResponse.makeServerProblemError();
    }
  }

  static saveAddressToSharePreferences(ShAddressModel newAddress) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('name', newAddress.name);
    await sharedPreferences.setString('zip', newAddress.zip);
    await sharedPreferences.setString('region', newAddress.region);
    await sharedPreferences.setString('address', newAddress.address);
    await sharedPreferences.setString('country', newAddress.country);
    await sharedPreferences.setString('city', newAddress.city);
    await sharedPreferences.setString('email', newAddress.email);
  }

  static Future<ShAddressModel> getAddressFromSharePreferences( ) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String name = await sharedPreferences.getString('name') ?? "";
    String zip = await sharedPreferences.getString('zip') ?? "";
    String region = await sharedPreferences.getString('region') ?? "";
    String address = await sharedPreferences.getString('address') ?? "";
    String country = await sharedPreferences.getString('country') ?? "";
    String city = await sharedPreferences.getString('city') ?? "";
    String email = await sharedPreferences.getString('email') ?? "";
    ShAddressModel newAddress = ShAddressModel(name: name, zip: zip, region: region, city: city, address: address, country: country,email: email);
    return newAddress;
  }


}
