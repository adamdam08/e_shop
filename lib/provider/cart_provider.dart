import 'package:e_shop/models/cart/cart_list_model.dart';
import 'package:e_shop/services/settings_service.dart';
import 'package:flutter/cupertino.dart';

class CartProvider with ChangeNotifier {
  // final List<Map> myProducts = List.generate(10, (index) => {
  //   "id": index,
  //   "name": "Lorem Ipsum Sit Dolor Amet",
  //   "price": 100000,
  //   "amount": 1
  // }).toList();

  List<Map> _myProducts = [];
  List<Map> get myProducts => _myProducts;

  set myProducts(List<Map> products) {
    _myProducts = products;
    notifyListeners();
  }

  // List Cart Model
  late CartListModel _cartList;

  CartListModel get cartList => _cartList;

  set cartList(CartListModel cartList) {
    _cartList = cartList;
    notifyListeners();
  }

  Future<bool> getCartList({
    required String token,
  }) async {
    try {
      CartListModel cartList =
          await SettingsService().getListCart(token: token);
      _cartList = cartList;
      return true;
    } catch (e) {
      print("Error : $e");
      return false;
    }
  }

  // Add Cart Model
  Future<String> addCart({
    required Map data,
    required String token,
  }) async {
    try {
      await SettingsService().addCart(data: data, token: token);
      return "";
    } catch (e) {
      return "$e";
    }
  }

  // Add Cart Model
  Future<String> updateCart({
    required Map data,
    required String token,
  }) async {
    try {
      await SettingsService().updateCart(data: data, token: token);
      return "";
    } catch (e) {
      return "$e";
    }
  }

  // Add Cart Model
  Future<String> deleteCart({
    required String cuid,
    required String token,
  }) async {
    try {
      await SettingsService().deleteCart(cuid: cuid, token: token);
      return "";
    } catch (e) {
      return "$e";
    }
  }
}
