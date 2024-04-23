import 'package:e_shop/models/cart/cart_list_model.dart';
import 'package:e_shop/services/settings_service.dart';
import 'package:flutter/cupertino.dart';

class parameterCart {
  final String note;
  final int total;

  const parameterCart({required this.note, required this.total});
}

class CartProvider with ChangeNotifier {
  List<Map> _selectedProducts = [];
  List<Map> get selectedProducts => _selectedProducts;

  set selectedProducts(List<Map> products) {
    _selectedProducts = products;
    notifyListeners();
  }

  // Example
  //  {
  //     "id": 1,
  //     "nama_produk": "Sunco 2 liter",
  //     "image_url": "filename.jpg",
  //     "harga": 35000,
  //     "jumlah": 2,
  //     "total_harga": 70000
  // },

  List<Map> _myProducts = [];
  List<Map> get myProducts => _myProducts;

  set myProducts(List<Map> products) {
    _myProducts = products;
    notifyListeners();
  }

  // Catatan Model
  String _cartNote = "";
  String get cartNote => _cartNote;

  int _cartTotal = 0;
  int get cartTotal => _cartTotal;

  set cartUpdate(parameterCart data) {
    _cartNote = data.note;
    _cartTotal = data.total;
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
    required String cuid,
    required Map data,
    required String token,
  }) async {
    try {
      await SettingsService().updateCart(cuid: cuid, data: data, token: token);
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
