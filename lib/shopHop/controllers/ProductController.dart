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
    _wooProductList = pList;
  }

  Future<Map<int, List<WooProduct>>> getCategoryProducts({
    required List<WooProductCategory> subCategoryList,
  }) async {
    Map<int, List<WooProduct>> subCatWooProducts = {};

    for (var subCat in subCategoryList) {
      List<WooProduct> wooSubProducts = await wooCommerce.getProducts(
        category: subCat.id.toString(),
      );
      subCatWooProducts[subCat.id!] = wooSubProducts;
    }
    return subCatWooProducts;
  }

  List<WooProduct> get getAllProducts => _wooProductList;

  Future<List<String>> loadBanners() async {
    List<String> banner = [];

    return banner;
  }
}
