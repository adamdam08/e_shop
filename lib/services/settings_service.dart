import 'dart:convert';
import 'package:e_shop/models/cart/cart_list_model.dart';
import 'package:e_shop/models/customer/customer_post_model.dart';
import 'package:e_shop/models/settings/district_model.dart';
import 'package:e_shop/models/settings/shipping_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:e_shop/models/store_location_model.dart';

class SettingsService {
  String baseURL = 'http://103.127.132.116/api/v1/';

  Future<StoreLocationModel> getStoreByCoordinate(
      {required String lat,
      required String long,
      required String token}) async {
    var url = Uri.parse("${baseURL}pengaturan/cabang");
    var header = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    Map data = {"lat": lat, "lon": long};
    var body = jsonEncode(data);
    var response = await http.post(url, headers: header, body: body);
    // ignore: avoid_print
    print("Login: ${response.body}");

    // **success melakukan login
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);

      StoreLocationModel storeLocateModel = StoreLocationModel.fromJson(data);
      return storeLocateModel;
    } else {
      throw Exception("Gagal Mendapatkan Promo");
    }
  }

  Future<CartListModel> getListCart({
    required String token,
  }) async {
    var url = Uri.parse("${baseURL}keranjang");
    var header = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var response = await http.get(url, headers: header);

    // ignore: avoid_print
    print("ListCart: ${response.body}");

    // **success melakukan login
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);

      CartListModel storeLocateModel = CartListModel.fromJson(data);
      return storeLocateModel;
    } else {
      throw Exception("Tidak Dapat Mendapatkan List");
    }
  }

  // Add data customer
  Future<CustomerPostModel> addCart(
      {required Map data, required String token}) async {
    var url = Uri.parse("${baseURL}keranjang");
    var header = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var body = jsonEncode(data);
    var response = await http.post(url, headers: header, body: body);
    // ignore: avoid_print
    print("Add Customer: ${response.body}");

// **success melakukan login
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);
      CustomerPostModel callbackData = CustomerPostModel.fromJson(data);
      return callbackData;
    } else {
      var data = jsonDecode(response.body);
      throw ErrorDescription('${data['message']}');
    }
  }

  // Delete customer cart
  Future<CustomerPostModel> deleteCart(
      {required String cuid, required String token}) async {
    var url = Uri.parse("${baseURL}keranjang/$cuid");
    var header = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var response = await http.delete(url, headers: header);
    // ignore: avoid_print
    print("Add Customer: ${response.body}");

// **success melakukan login
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);
      CustomerPostModel callbackData = CustomerPostModel.fromJson(data);
      return callbackData;
    } else {
      var data = jsonDecode(response.body);
      throw ErrorDescription('${data['message']}');
    }
  }

// Add data customer
  Future<CustomerPostModel> updateCart(
      {required Map data, required String token, required String cuid}) async {
    var url = Uri.parse("${baseURL}keranjang/$cuid");
    var header = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var body = jsonEncode(data);
    var response = await http.put(url, headers: header, body: body);
    // ignore: avoid_print
    print("Add Customer: ${response.body}");

// **success melakukan login
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);
      CustomerPostModel callbackData = CustomerPostModel.fromJson(data);
      return callbackData;
    } else {
      var data = jsonDecode(response.body);
      throw ErrorDescription('${data['message']}');
    }
  }

  // List Ship
  Future<ShippingModel> getListShipping({
    required String token,
    required String cabang,
  }) async {
    var url = Uri.parse("${baseURL}pengaturan/kurir?cabang=$cabang");
    var header = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    var response = await http.get(url, headers: header);
    // ignore: avoid_print
    print("Shipping: ${url}");
    print("Shipping: ${response.body}");

// **success melakukan login
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);
      ShippingModel callbackData = ShippingModel.fromJson(data);
      return callbackData;
    } else {
      var data = jsonDecode(response.body);
      throw ErrorDescription('${data['message']}');
    }
  }
}
