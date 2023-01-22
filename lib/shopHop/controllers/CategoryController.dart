import 'package:flutter/cupertino.dart';
import 'package:flutter_wp_woocommerce/woocommerce.dart';
import 'package:nb_utils/nb_utils.dart';

import '../utils/ShConstant.dart';

class CategoryController with ChangeNotifier {
  WooCommerce wooCommerce = WooCommerce(
    baseUrl: base_url,
    consumerKey: api_Consumer_Key,
    consumerSecret: api_Consumer_Secret,
  );

  List<WooProductCategory> _categoryList = [];
  List<WooProductCategory> _mainCategoryList = [];
  List<WooProductCategory> _subCategoryList = [];
  //--------------------- Get All Cats ---------------------------------------------//
  Future<void> fetchAllCategories() async {
    _categoryList = [];

    try {
      _categoryList = (await wooCommerce.getProductCategories(perPage: 100))
          .where((e) => (e.slug != 'sales' && e.slug != 'mwb_wgm_giftcard'))
          .toList();
      log("all category length ===>>> ${_categoryList.length}");
    } catch (e) {
      //If any server error...
      // return MyResponse.makeServerProblemError<List<ShCategory>>();
      Fluttertoast.showToast(msg: e.toString() + "from fetching categoryData");
      log(e.toString());
    }
    notifyListeners();
  }

//--------------------- Get Main Cats ---------------------------------------------//
  Future<void> fetchMainCategories() async {
    await fetchAllCategories();
    _mainCategoryList = [];

    try {
      _mainCategoryList = (await wooCommerce.getProductCategories(parent: 0))
          .where((e) => (e.slug != 'sales' && e.slug != 'mwb_wgm_giftcard'))
          .toList();
      log("main category length ===>>> ${_mainCategoryList.toString()}");
    } catch (e) {
      //If any server error...
      // return MyResponse.makeServerProblemError<List<ShCategory>>();
      Fluttertoast.showToast(msg: e.toString() + "from fetching categoryData");
      log(e.toString());
    }
    notifyListeners();
  }

  // --------------------- Get Sub Cats ---------------------------------------------//
  List<WooProductCategory> fetchSubCategory(
    int? id,
  ) {
    _subCategoryList = [];
    for (var cat in _categoryList) {
      if (cat.parent == id) {
        _subCategoryList.add(cat);
      }
    }
    return _subCategoryList;
  }

  static String? decodeCategoriesNames(String? catName) {
    switch (catName) {
      case "Big &amp; Tall":
        return "Big-Tall";
    }
    return catName;
  }

  List<WooProductCategory> get getAllCategory => _categoryList;
  List<WooProductCategory> get getMainCategory => _mainCategoryList;
}
