import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

Future<String> loadContentAsset(String path) async {
  return await rootBundle.loadString(path);
}

extension StringExtension on String? {
  String? toCurrencyFormat({var format = '\$'}) {
    String? dblPrice = double.tryParse(this ?? '0')!.toStringAsFixed(2);
    return format + dblPrice;
  }

  String formatDateTime() {
    if (this == null || this!.isEmpty || this == "null") {
      return "NA";
    } else {
      return DateFormat("HH:mm dd MMM yyyy", "en_US")
          .format(DateFormat("yyyy-MM-dd HH:mm:ss.0", "en_US").parse(this!));
    }
  }

//* capitalize first word
  String capitalize() {
    return "${this![0].toUpperCase()}${this?.substring(1).toLowerCase()}";
  }

  String formatDate() {
    if (this == null || this!.isEmpty || this == "null") {
      return "NA";
    } else {
      return DateFormat("dd MMM yyyy", "en_US")
          .format(DateFormat("yyyy-MM-dd", "en_US").parse(this!));
    }
  }
}
