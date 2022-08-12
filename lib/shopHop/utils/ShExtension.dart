import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:cotton_natural/shopHop/models/ShProduct.dart';

Future<String> loadContentAsset(String path) async {
  return await rootBundle.loadString(path);
}

Future<List<ShProduct>> loadProducts() async {
  String jsonString = await loadContentAsset('assets/shophop_data/products.json');
  final jsonResponse = json.decode(jsonString);
  return (jsonResponse as List).map((i) => ShProduct.fromJson(i)).toList();
}


Future<List<String>> loadBanners() async {
  List<String> banner = [];

  return banner;
}

extension StringExtension on String? {
  String? toCurrencyFormat({var format = '\$'}) {
    String? dblPrice = double.tryParse(this??'0')!.toStringAsFixed(2);
    return format + dblPrice;
  }

  String formatDateTime() {
    if (this == null || this!.isEmpty || this == "null") {
      return "NA";
    } else {
      return DateFormat("HH:mm dd MMM yyyy", "en_US").format(DateFormat("yyyy-MM-dd HH:mm:ss.0", "en_US").parse(this!));
    }
  }

  String formatDate() {
    if (this == null || this!.isEmpty || this == "null") {
      return "NA";
    } else {
      return DateFormat("dd MMM yyyy", "en_US").format(DateFormat("yyyy-MM-dd", "en_US").parse(this!));
    }
  }
}
