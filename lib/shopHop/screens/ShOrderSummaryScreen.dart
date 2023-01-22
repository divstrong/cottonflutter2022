import 'dart:convert';

import 'package:cotton_natural/main/utils/AppWidget.dart';
import 'package:cotton_natural/shopHop/controllers/AddressController.dart';
import 'package:cotton_natural/shopHop/models/ShAddress.dart';
import 'package:cotton_natural/shopHop/providers/OrdersProvider.dart';
import 'package:cotton_natural/shopHop/screens/sh_order_finalize.dart';
import 'package:cotton_natural/shopHop/utils/ShColors.dart';
import 'package:cotton_natural/shopHop/utils/ShConstant.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../api/Network.dart';

class ShOrderSummaryScreen extends StatefulWidget {
  static String tag = '/ShOrderSummaryScreen';

  @override
  ShOrderSummaryScreenState createState() => ShOrderSummaryScreenState();
}

class ShOrderSummaryScreenState extends State<ShOrderSummaryScreen> {
  String googleApikey = "AIzaSyDy7HBo2RAeyVdVKMU8jRvbQ6CH8pMRM5U";
  var isLoaded = false;
  late ShAddressModel shipAddressModel;
  late ShAddressModel billAddressModel;
  String shippingAddressText = "Search Location";
  String billingAddressText = "Search Location";
  DateTime? selectedDateTime;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    shipAddressModel =
        Provider.of<OrdersProvider>(context, listen: false).getShipAddress();
    billAddressModel =
        Provider.of<OrdersProvider>(context, listen: false).getBillAddress();
    if (isShippingAddressEmpty()) {
      shipAddressModel = await AddressController.getShipToFromCachedData();
      billAddressModel = await AddressController.getBillToFromCachedData();
      Provider.of<OrdersProvider>(context, listen: false)
          .setShipAddress(shipAddressModel);
      Provider.of<OrdersProvider>(context, listen: false)
          .setBillAddress(billAddressModel);
    }
    nameController.text = shipAddressModel.name;
    emailController.text = shipAddressModel.email;
    phoneController.text = shipAddressModel.phone;
    shippingAddressText = shipAddressModel.address;
    billingAddressText = billAddressModel.address;

    setState(() {
      isLoaded = true;
    });
  }

  bool isShippingAddressEmpty() => (shipAddressModel == ShAddressModel.empty());

  @override
  dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveShippingAddress() async {
    ShAddressModel newAddress = ShAddressModel(
      name: nameController.text,
      zip: '',
      region: '',
      city: '',
      address: shippingAddressText,
      country: '',
      email: emailController.text,
      phone: phoneController.text,
    );
    await AddressController.cacheShipToAddress(newAddress);
    Provider.of<OrdersProvider>(context, listen: false)
        .setShipAddress(newAddress);
  }

  Future<void> _saveBillingAddress() async {
    ShAddressModel newAddress = ShAddressModel(
      name: nameController.text,
      zip: '',
      region: '',
      city: '',
      address: billingAddressText,
      country: '',
      email: emailController.text,
      phone: phoneController.text,
    );
    await AddressController.cacheBillToAddress(newAddress);
    Provider.of<OrdersProvider>(context, listen: false)
        .setBillAddress(newAddress);
  }

  @override
  Widget build(BuildContext context) {
    var continueButton = SizedBox(
      width: 300,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: () async {
                await _saveBillingAddress();

                await _saveShippingAddress();

                if (selectedDateTime == null) {
                  toasty(context, 'Invalid Ship Date');
                  return;
                }

                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => OrderFinalize(
                      shipDate: DateFormat('MM/dd/yyyy').format(
                        selectedDateTime!,
                      ),
                    ),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(
                  top: spacing_standard_new + 30.0,
                  bottom: spacing_standard_new + 60.0,
                ),
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: sh_colorPrimary.withOpacity(0.9),
                ),
                child: Center(
                  child: text(
                    'Continue',
                    textColor: sh_white,
                    fontSize: textSizeLargeMedium,
                    fontFamily: fontBold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      body: (isLoaded)
          ? SingleChildScrollView(
              child: Column(
                children: [
                  buildDatePicker(
                    title: "Ship Date",
                    selectedDateTime: selectedDateTime,
                    onPickDateTime: (DateTime dateTime) {
                      setState(() {
                        selectedDateTime = dateTime;
                      });
                    },
                  ),
                  buildWholesale(
                    title: "Name",
                    txtController: nameController,
                    keyBType: TextInputType.name,
                    icon: Icons.account_circle_outlined,
                  ),
                  buildWholesale(
                    title: "Email",
                    txtController: emailController,
                    keyBType: TextInputType.emailAddress,
                    icon: Icons.email_outlined,
                  ),
                  buildWholesale(
                    title: "Phone",
                    txtController: phoneController,
                    keyBType: TextInputType.phone,
                    icon: Icons.phone_outlined,
                  ),
                  buildAddressPicker(
                    title: 'Shipping Address',
                    locationText: shippingAddressText,
                    onPickLocation: (String locationText) {
                      setState(() {
                        shippingAddressText = locationText;
                      });
                    },
                  ),
                  buildAddressPicker(
                    title: 'Billing Address',
                    locationText: billingAddressText,
                    onPickLocation: (String locationText) {
                      setState(() {
                        billingAddressText = locationText;
                      });
                    },
                  ),
                  continueButton,
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget buildDatePicker({
    required String title,
    required DateTime? selectedDateTime,
    required void Function(DateTime) onPickDateTime,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          text(
            title,
            fontSize: textSizeNormal,
            fontFamily: fontSemibold,
          ),
          InkWell(
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
              );

              if (pickedDate == null) return;

              onPickDateTime(pickedDate);
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey),
                ),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  (selectedDateTime == null)
                      ? ''
                      : DateFormat('MM/dd/yyyy').format(
                          selectedDateTime,
                        ),
                  style: TextStyle(fontSize: textSizeMedium),
                ),
                trailing: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Icon(Icons.calendar_today_outlined),
                ),
                dense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAddressPicker({
    required String title,
    required String locationText,
    required void Function(String) onPickLocation,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          text(
            title,
            fontSize: textSizeNormal,
            fontFamily: fontSemibold,
          ),
          Autocomplete<String>(
            initialValue: TextEditingValue(text: locationText),
            optionsBuilder: (TextEditingValue value) async {
              NetworkResponse response = await Network.get(
                'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${value.text}&types=address&key=$googleApikey',
              );
              return (response.statusCode == 200)
                  ? ((json.decode(response.body)
                              as Map<String, dynamic>)['predictions']
                          as List<dynamic>)
                      .map(
                        (e) => ((e as Map<String, dynamic>)['description']
                            as String),
                      )
                      .toList()
                  : [];
            },
            onSelected: (String value) {
              onPickLocation(value);
            },
            fieldViewBuilder: (
              BuildContext context,
              TextEditingController controller,
              FocusNode focusNode,
              void Function() onFieldSubmitted,
            ) {
              return TextField(
                controller: controller,
                focusNode: focusNode,
                decoration: InputDecoration(
                  suffixIcon: Icon(
                    Icons.location_on_outlined,
                  ),
                ),
                onSubmitted: (String value) {
                  onFieldSubmitted();
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildWholesale({
    required String title,
    required TextEditingController txtController,
    required TextInputType keyBType,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          text(
            title,
            fontSize: textSizeNormal,
            fontFamily: fontSemibold,
          ),
          TextField(
            controller: txtController,
            keyboardType: keyBType,
            decoration: InputDecoration(
              suffixIcon: Icon(
                icon,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
