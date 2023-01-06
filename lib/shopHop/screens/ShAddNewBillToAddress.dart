import 'package:cotton_natural/main/utils/AppWidget.dart';
import 'package:cotton_natural/shopHop/controllers/AddressController.dart';
import 'package:cotton_natural/shopHop/models/ShAddress.dart';
import 'package:cotton_natural/shopHop/providers/OrdersProvider.dart';
import 'package:cotton_natural/shopHop/screens/ShOrderSummaryScreen.dart';
import 'package:cotton_natural/shopHop/utils/ShColors.dart';
import 'package:cotton_natural/shopHop/utils/ShConstant.dart';
import 'package:cotton_natural/shopHop/utils/ShStrings.dart';
import 'package:cotton_natural/shopHop/utils/ShWidget.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class ShAddNewBillToAddress extends StatefulWidget {
  static String tag = '/AddNewAddress';
  @override
  ShAddNewBillToAddressState createState() => ShAddNewBillToAddressState();
}

class ShAddNewBillToAddressState extends State<ShAddNewBillToAddress> {
  var primaryColor;
  late ShAddressModel billProviderAddress;

  var zipCont = TextEditingController();
  var addressCont = TextEditingController();
  var cityCont = TextEditingController();
  var regionCont = TextEditingController();
  var countryCont = TextEditingController();
  var nameCont = TextEditingController();
  var phoneCont = TextEditingController();

  @override
  void dispose() {
    zipCont.dispose();
    addressCont.dispose();
    cityCont.dispose();
    regionCont.dispose();
    countryCont.dispose();
    nameCont.dispose();
    phoneCont.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    billProviderAddress =
        Provider.of<OrdersProvider>(context, listen: false).getBillAddress();
    if (isAddressProviderEmpty()) {
      billProviderAddress = await AddressController.getBillToFromCachedData();
      // print('loaded from shp ${providerAddress.name} ${providerAddress.email}');
      Provider.of<OrdersProvider>(context, listen: false)
          .setBillAddress(billProviderAddress);
    }

    // print('${isAddressProviderEmpty()} loaded from provider ${providerAddress.name} ${providerAddress.email}');

    nameCont.text = billProviderAddress.name;
    addressCont.text = billProviderAddress.address;
    cityCont.text = billProviderAddress.city;
    regionCont.text = billProviderAddress.region;
    countryCont.text = billProviderAddress.country;
    zipCont.text = billProviderAddress.zip;
  }

  bool isAddressProviderEmpty() =>
      ShAddressModel(
        name: billProviderAddress.name,
        zip: billProviderAddress.zip,
        region: billProviderAddress.region,
        city: billProviderAddress.city,
        address: billProviderAddress.address,
        country: billProviderAddress.country,
      ) ==
      ShAddressModel.empty();

  @override
  Widget build(BuildContext context) {
    void onSaveClicked() async {
      ShAddressModel newAddress = ShAddressModel(
        name: nameCont.text,
        zip: zipCont.text,
        region: regionCont.text,
        city: cityCont.text,
        address: addressCont.text,
        country: countryCont.text,
      );
      await AddressController.cacheBillToAddress(newAddress);
      Provider.of<OrdersProvider>(context, listen: false)
          .setBillAddress(newAddress);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => ShOrderSummaryScreen(),
        ),
      );
    }

    //adding address form

    final name = TextFormField(
      controller: nameCont,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.words,
      style: TextStyle(fontFamily: fontRegular, fontSize: textSizeMedium),
      autofocus: false,
      onFieldSubmitted: (term) {
        FocusScope.of(context).nextFocus();
      },
      decoration: formFieldDecoration('Name'),
    );

    final address = TextFormField(
      controller: addressCont,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      autofocus: false,
      onFieldSubmitted: (term) {
        FocusScope.of(context).nextFocus();
      },
      decoration: formFieldDecoration('Address'),
    );

    final city = TextFormField(
      controller: cityCont,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.words,
      style: TextStyle(fontFamily: fontRegular, fontSize: textSizeMedium),
      onFieldSubmitted: (term) {
        FocusScope.of(context).nextFocus();
      },
      textInputAction: TextInputAction.next,
      autofocus: false,
      decoration: formFieldDecoration(sh_hint_city),
    );

    final region = TextFormField(
      onFieldSubmitted: (term) {
        FocusScope.of(context).nextFocus();
      },
      controller: regionCont,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.words,
      style: TextStyle(fontFamily: fontRegular, fontSize: textSizeMedium),
      autofocus: false,
      textInputAction: TextInputAction.next,
      decoration: formFieldDecoration('State/Province'),
    );

    final country = TextFormField(
      onFieldSubmitted: (term) {
        FocusScope.of(context).nextFocus();
      },
      controller: countryCont,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.words,
      style: TextStyle(fontFamily: fontRegular, fontSize: textSizeMedium),
      autofocus: false,
      textInputAction: TextInputAction.next,
      decoration: formFieldDecoration("Country"),
    );

    final zip = TextFormField(
      controller: zipCont,
      keyboardType: TextInputType.number,
      maxLength: 6,
      autofocus: false,
      onFieldSubmitted: (term) {
        FocusScope.of(context).nextFocus();
      },
      textInputAction: TextInputAction.next,
      style: TextStyle(fontFamily: fontRegular, fontSize: textSizeMedium),
      decoration: formFieldDecoration('Zip Code'),
    );

    final phone = TextFormField(
      controller: phoneCont,
      keyboardType: TextInputType.number,
      autofocus: false,
      onFieldSubmitted: (term) {
        FocusScope.of(context).nextFocus();
      },
      textInputAction: TextInputAction.next,
      style: TextStyle(fontFamily: fontRegular, fontSize: textSizeMedium),
      decoration: formFieldDecoration('Phone Number'),
    );

    final saveButton = MaterialButton(
      height: 50,
      minWidth: double.infinity,
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0)),
      onPressed: () {
        if (validateAddress()) {
          onSaveClicked();
        }
      },
      color: sh_colorPrimary,
      child: text(
        sh_lbl_save_address,
        fontFamily: fontMedium,
        fontSize: textSizeLargeMedium,
        textColor: sh_white,
      ),
    );

    final body = Wrap(
      runSpacing: spacing_standard_new,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(child: name),
          ],
        ),
        address,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(child: city),
            SizedBox(
              width: spacing_standard_new,
            ),
            Expanded(child: region),
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(child: country),
            SizedBox(
              width: spacing_standard_new,
            ),
            Expanded(child: zip),
          ],
        ),
        phone,
        saveButton,
      ],
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: sh_white,
        title: text(
          (billProviderAddress.name == '' &&
                  billProviderAddress.address == '' &&
                  billProviderAddress.city == '')
              ? sh_lbl_add_new_Bill_address
              : sh_lbl_edit_Bill_address,
          textColor: sh_textColorPrimary,
          fontSize: textSizeNormal,
          fontFamily: fontMedium,
        ),
        iconTheme: IconThemeData(color: sh_textColorPrimary),
        actionsIconTheme: IconThemeData(color: sh_colorPrimary),
        // actions: <Widget>[cartIcon(context, 3)],
      ),
      body: Container(
        width: double.infinity,
        child: SingleChildScrollView(child: body),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  bool validateAddress() {
    if (nameCont.text.trim() == '') {
      toasty(context, 'Name is require');
      return false;
    } else if (addressCont.text.trim() == '') {
      toasty(context, 'Address is require');
      return false;
    } else if (cityCont.text.trim() == '') {
      toasty(context, 'City name is require');
      return false;
    } else if (regionCont.text.trim() == '') {
      toasty(context, 'State name required');
      return false;
    } else if (countryCont.text.trim() == '') {
      toasty(context, 'Country name is require');
      return false;
    } else if (zipCont.text.trim() == '') {
      toasty(context, 'Zip Code is require');
      return false;
    } else if (phoneCont.text.trim() == '') {
      toasty(context, 'Phone is require');
      return false;
    }
    return true;
  }
}
