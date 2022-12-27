import 'package:cotton_natural/main/utils/AppWidget.dart';
import 'package:cotton_natural/shopHop/controllers/AddressController.dart';
import 'package:cotton_natural/shopHop/models/ShAddress.dart';
import 'package:cotton_natural/shopHop/providers/OrdersProvider.dart';
import 'package:cotton_natural/shopHop/screens/ShOrderSummaryScreen.dart';
import 'package:cotton_natural/shopHop/utils/ShColors.dart';
import 'package:cotton_natural/shopHop/utils/ShConstant.dart';
import 'package:cotton_natural/shopHop/utils/ShStrings.dart';
import 'package:cotton_natural/shopHop/utils/ShWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class ShAddNewAddress extends StatefulWidget {
  static String tag = '/AddNewAddress';
  @override
  ShAddNewAddressState createState() => ShAddNewAddressState();
}

class ShAddNewAddressState extends State<ShAddNewAddress> {
  var primaryColor;
  late ShAddressModel providerAddress;
  var zipCont = TextEditingController();
  var addressCont = TextEditingController();
  var cityCont = TextEditingController();
  var regionCont = TextEditingController();
  var countryCont = TextEditingController();
  var nameCont = TextEditingController();
  var emailCont = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    providerAddress =
        Provider.of<OrdersProvider>(context, listen: false).getAddress();
    if (isAddressProviderEmpty()) {
      providerAddress =
          await AddressController.getAddressFromSharePreferences();
      // print('loaded from shp ${providerAddress.name} ${providerAddress.email}');
      Provider.of<OrdersProvider>(context, listen: false)
          .setAddress(providerAddress);
    }

    // print('${isAddressProviderEmpty()} loaded from provider ${providerAddress.name} ${providerAddress.email}');

    nameCont.text = providerAddress.name;
    addressCont.text = providerAddress.address;
    cityCont.text = providerAddress.city;
    regionCont.text = providerAddress.region;
    countryCont.text = providerAddress.country;
    zipCont.text = providerAddress.zip;
    emailCont.text = providerAddress.email;
  }

  bool isAddressProviderEmpty() {
    return (providerAddress.name == '' ||
        providerAddress.address == '' ||
        providerAddress.city == '' ||
        providerAddress.email == '' ||
        providerAddress.country == '' ||
        providerAddress.region == '' ||
        providerAddress.zip == '');
  }

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
        email: emailCont.text,
      );
      await AddressController.saveAddressToSharePreferences(newAddress);
      Provider.of<OrdersProvider>(context, listen: false)
          .setAddress(newAddress);
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

    final email = TextFormField(
      controller: emailCont,
      autofocus: false,
      onFieldSubmitted: (term) {
        FocusScope.of(context).nextFocus();
      },
      textInputAction: TextInputAction.next,
      style: TextStyle(fontFamily: fontRegular, fontSize: textSizeMedium),
      decoration: formFieldDecoration('Email'),
    );

    final saveButton = MaterialButton(
      height: 50,
      minWidth: double.infinity,
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(40.0)),
      onPressed: () {
        if (validateAddress()) {
          onSaveClicked();
        }
      },
      color: sh_colorPrimary,
      child: text(sh_lbl_save_address,
          fontFamily: fontMedium,
          fontSize: textSizeLargeMedium,
          textColor: sh_white),
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
        email,
        saveButton,
      ],
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: sh_white,
        title: text(
            (providerAddress.name == '' &&
                    providerAddress.address == '' &&
                    providerAddress.city == '')
                ? sh_lbl_add_new_address
                : sh_lbl_edit_address,
            textColor: sh_textColorPrimary,
            fontSize: textSizeNormal,
            fontFamily: fontMedium),
        iconTheme: IconThemeData(color: sh_textColorPrimary),
        actionsIconTheme: IconThemeData(color: sh_colorPrimary),
        // actions: <Widget>[cartIcon(context, 3)],
      ),
      body: Container(
          width: double.infinity,
          child: SingleChildScrollView(child: body),
          margin: EdgeInsets.all(16)),
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
    }
    return true;
  }
}
