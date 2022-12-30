import 'package:cotton_natural/shopHop/models/ShAddress.dart';
import 'package:cotton_natural/shopHop/models/ShOrder.dart';
import 'package:cotton_natural/shopHop/models/ShPaymentCard.dart';
import 'package:cotton_natural/shopHop/models/ShProduct.dart';
import 'package:cotton_natural/shopHop/utils/ShExtension.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/src/extensions/string_extensions.dart';

class OrdersProvider extends ChangeNotifier {
  List<ShOrder> _orderList = [];
  double _totalPrice = 0.00;
  bool isLoggedIn = false;
  // Standard Delivery $5.99 / Delivery in 5 to 7 business Days
  // Express Delivery $19.99 / Delivery in 1 business Days
  ShippingMethod _shippingMethod = ShippingMethod(
    id: 'notset',
    name: 'Not Set',
    price: '0',
    description: '',
  );
  ShAddressModel _orderAddress = ShAddressModel(
    name: '',
    zip: '',
    region: '',
    city: '',
    address: '',
    country: '',
  );

  ShAddressModel _billAddress = ShAddressModel(
    name: '',
    zip: '',
    region: '',
    city: '',
    address: '',
    country: '',
  );
  ShPaymentCard _paymentCard =
      ShPaymentCard(cardNo: '', month: '', year: '', cvv: '', holderName: '');

  setCard(ShPaymentCard newCard) {
    this._paymentCard = newCard;
    notifyListeners();
  }

  ShPaymentCard getCard() {
    return this._paymentCard;
  }

  setShipAddress(ShAddressModel newAddress) {
    this._orderAddress = newAddress;
    notifyListeners();
  }

  //? new bill address
  setBillAddress(ShAddressModel newAddress) {
    this._billAddress = newAddress;
    notifyListeners();
  }

  ShAddressModel getAddress() {
    return this._orderAddress;
  }

  ShAddressModel getBillAddress() {
    return this._billAddress;
  }

  setShippingMethod({String shippingMethodName = 'standard'}) {
    this._shippingMethod = (shippingMethodName == 'standard')
        ? ShippingMethod(
            id: 'standard',
            name: 'Standard Delivery',
            price: '5.99',
            description: 'Delivery in 5 to 7 business Days',
          )
        : (shippingMethodName == 'express')
            ? ShippingMethod(
                id: 'express',
                name: ' Express Delivery',
                price: '19.99',
                description: 'Delivery in 1 business Days',
              )
            : ShippingMethod(
                id: 'notset',
                name: 'Not Set',
                price: '0',
                description: '',
              );

    notifyListeners();
  }

  ShippingMethod getShippingMethod() {
    return this._shippingMethod;
  }

  List<ShOrder> getOrderList() {
    return _orderList;
  }

  bool isProductAlreadyAdded(int? productId, String? size) {
    bool res = false;
    _orderList.forEach((element) {
      if (element.item!.id.toInt() == productId && element.item!.size == size)
        res = true;
    });

    return res;
  }

  void increaseProductCount(int? productId, String? size) {
    _orderList.forEach((element) {
      if (element.item!.id.toInt() == productId && element.item!.size == size) {
        element.item!.count = ((element.item!.count!.toInt()) + 1).toString();
      }
    });

    notifyListeners();
  }

  void decreaseProductCount(int? productId, String? size) {
    _orderList.forEach((element) {
      if (element.item!.id.toInt() == productId && element.item!.size == size) {
        element.item!.count = (element.item!.count!.toInt() - 1).toString();
      }
    });
    _orderList.removeWhere(
      (element) => (element.item!.count == 0 && element.item!.size == size),
    );
    notifyListeners();
  }

  int getItemQty(int? productId, String? size) {
    int itemCount = 0;
    _orderList.forEach((element) {
      if (element.item!.id.toInt() == productId && element.item!.size == size) {
        itemCount = element.item!.count!.toInt();
      }
    });
    return itemCount;
  }

  void addItemToBasket({
    required ShProduct? product,
    int count = 1,
    String? size,
  }) {
    if (this.isProductAlreadyAdded(product!.id, size)) {
      increaseProductCount(product.id, size);
    } else {
      Item item = Item(
        id: product.id.toString(),
        image_url: product.images![0],
        name: product.name,
        price: product.price,
        count: count.toString(),
        slug: product.slug,
        size: size,
      );
      ShOrder order = ShOrder(
        item: item,
        order_date: 'order_date',
        order_number: 'order_number',
        order_status: 'order_status',
      );
      _orderList.add(order);
    }

    notifyListeners();
  }

  void removeItemFromBasket({required int? productId, String? size}) {
    _orderList.removeWhere(
      (element) =>
          element.item!.id.toInt() == productId && element.item!.size == size,
    );

    notifyListeners();
  }

  String? getTotalPrice() {
    _totalPrice = 0.00;
    _orderList.forEach((element) {
      _totalPrice = _totalPrice +
          double.parse(element.item!.price ?? '0') *
              element.item!.count!.toInt();
    });
    _totalPrice = _totalPrice + double.parse(_shippingMethod.price ?? '0');

    return _totalPrice.toStringAsFixed(2).toCurrencyFormat();
  }

  double getTotalPriceSimple() {
    _totalPrice = 0.00;
    _orderList.forEach((element) {
      _totalPrice = _totalPrice +
          double.parse(element.item!.price ?? '0') *
              element.item!.count!.toInt();
    });
    _totalPrice = _totalPrice + double.parse(_shippingMethod.price ?? '0');

    return _totalPrice;
  }

  int getOrderCount() {
    int count = 0;
    _orderList.forEach((element) {
      count = count +
          this.getItemQty(element.item!.id!.toInt(), element.item!.size);
    });
    return count;
  }

  resetOrdersProvider() {
    this._orderList = [];
    this._totalPrice = 0.00;
    this.isLoggedIn = false;
    this._shippingMethod = ShippingMethod(
      id: 'notset',
      name: 'Not Set',
      price: '0',
      description: '',
    );
    this._orderAddress = ShAddressModel.empty();
    this._billAddress = ShAddressModel.empty();

    this._paymentCard =
        ShPaymentCard(cardNo: '', month: '', year: '', cvv: '', holderName: '');
    notifyListeners();
  }
}
