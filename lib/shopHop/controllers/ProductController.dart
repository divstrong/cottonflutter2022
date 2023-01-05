import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_wp_woocommerce/woocommerce.dart';

import '../utils/ShConstant.dart';

class ProductController with ChangeNotifier {
  WooCommerce wooCommerce = WooCommerce(
    baseUrl: base_url,
    consumerKey: api_Consumer_Key,
    consumerSecret: api_Consumer_Secret,
  );
  List<WooProduct> _wooProductList = [];

  static String getSizeTypeText(String sizeType) {
    switch (sizeType) {
      case 'Small':
        return 'S';
      case 'Medium':
        return 'M';
      case 'Large':
        return 'L';
      case 'X-Large':
        return 'XL';
      case 'XX-Large':
        return 'XXL';
      case '3x-Large':
        return '3XL';
      case '4x-Large':
        return '4XL';
      case '5x-Large':
        return '5XL';
    }
    return sizeType;
  }

  Future<void> fetchWooProducts() async {
    // await wooCommerce.createOrder();
    List<WooProduct> pList = [];
    pList = await wooCommerce.getProducts(perPage: 100);
    for (var i in pList) {
      log("products Attribute all attributes  ${i.attributes.toString()}");
      for (var j in i.attributes) {
        log("products Attribute attributes ${j.name} ");
      }
    }
    _wooProductList = pList;
  }

  Map<int, List<WooProduct>> getCategoryProducts({
    required List<WooProductCategory> subCategoryList,
  }) {
    Map<int, List<WooProduct>> subCatWooProducts = {};

    for (var subCat in subCategoryList) {
      subCatWooProducts.putIfAbsent(subCat.id!, () {
        List<WooProduct> wooSubProducts = [];
        for (var product in _wooProductList) {
          for (var cats in product.categories) {
            if (subCat.id == cats.id) {
              wooSubProducts.add(product);
            }
          }
        }
        return wooSubProducts;
      });
    }
    return subCatWooProducts;
  }

  List<WooProduct> get getAllProducts => _wooProductList;

  Future<List<String>> loadBanners() async {
    List<String> banner = [];

    return banner;
  }

  // //--------------------- Get Sub Cats ---------------------------------------------//
  // static Future<MyResponse<Map<String,List<ShProduct>>>> getSubCatProduct(String? categorySlug,String? subCatSlug,int limit) async {

  //   String url = ApiUtil.MAIN_API_URL + ApiUtil.SUB_CATEGORY_PRODUCTS + categorySlug! + '/' + subCatSlug! + '/' + limit.toString();
  //   Map<String, String> headers = ApiUtil.getHeader(requestType: RequestType.Get);

  //   //Check Internet
  //   bool isConnected = await InternetUtils.checkConnection();
  //   if (!isConnected) {
  //     return MyResponse.makeInternetConnectionError();
  //   }

  //   try {

  //     NetworkResponse response = await Network.get(url, headers: headers);
  //     MyResponse<Map<String,List<ShProduct>>> myResponse = MyResponse(response.statusCode);

  //     if (ApiUtil.isResponseSuccess(response.statusCode)) {
  //       myResponse.success = true;
  //       myResponse.data = ShProduct.getSubCatProductsMap(json.decode(response.body));
  //     } else {
  //       myResponse.success = false;
  //       myResponse.setError(json.decode(response.body));
  //     }
  //     return myResponse;
  //   }catch(e){
  //     //If any server error...
  //     print('errrrrrr2: ${e.toString()}');
  //     return MyResponse.makeServerProblemError<Map<String,List<ShProduct>>>();
  //   }
  // }

  // static Future<MyResponse<List<ShProduct>>> getSearchProduct(String? search) async {

  //   //Getting User Api Token
  //   // String token = await AuthController.getApiToken();
  //   String url = ApiUtil.MAIN_API_URL + ApiUtil.SEARCH + "?text=" + search! ;
  //   Map<String, String> headers = ApiUtil.getHeader(requestType: RequestType.Get);

  //   //Check Internet
  //   bool isConnected = await InternetUtils.checkConnection();
  //   if(!isConnected){
  //     return MyResponse.makeInternetConnectionError();
  //   }

  //   try {
  //     NetworkResponse response = await Network.get(url, headers: headers);
  //     MyResponse<List<ShProduct>> myResponse = MyResponse(response.statusCode);
  //     if (response.statusCode == 200) {
  //       List<ShProduct> list = ShProduct.getListFromJson(
  //           json.decode(response.body));
  //       myResponse.success = true;
  //       myResponse.data = list;
  //     } else {
  //       myResponse.setError(json.decode(response.body));
  //     }

  //     return myResponse;
  //   }catch(e){
  //     //If any server error...
  //     return MyResponse.makeServerProblemError<List<ShProduct>>();
  //   }
  // }
}
