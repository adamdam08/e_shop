import 'dart:convert';
import 'package:e_shop/models/customer/customer_address_model.dart';
import 'package:e_shop/models/customer/customer_data_model.dart';
import 'package:e_shop/models/customer/customer_post_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:e_shop/models/product_model.dart';

class CustomerService {
  String baseURL = 'http://103.127.132.116/api/v1/';
  // String baseURL = 'http://192.168.122.217:3001/api/v1/';

  // Get Promo Product
  Future<ProductModel> getPromoProduct(
      {required String cabangId, required String token}) async {
    var url = Uri.parse("${baseURL}produk/promo?cabang=$cabangId");
    var header = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    var response = await http.get(url, headers: header);
    // ignore: avoid_print
    print("Login: ${response.body}");

    // **success melakukan login
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);

      ProductModel promoProductModel = ProductModel.fromJson(data);
      return promoProductModel;
    } else {
      throw Exception("Gagal Mendapatkan Promo");
    }
  }

  // Add data customer
  Future<CustomerPostModel> addNewCustomer(
      {required Map data, required String token}) async {
    var url = Uri.parse("${baseURL}akun/register");
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

  // Add data customer
  Future<CustomerPostModel> updateCustomer(
      {required Map data,
      required String id,
      required String token,
      required bool isSales}) async {
    var url = isSales
        ? Uri.parse("${baseURL}akun/profil")
        : Uri.parse("${baseURL}akun/profil?id=$id");
    var header = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var body = jsonEncode(data);
    var response = await http.put(url, headers: header, body: body);
    // ignore: avoid_print
    print("Update Customer: ${url}");
    print("Update Customer: ${id}");
    print("Update Customer: ${body}");
    print("Update Customer: ${response.body}");

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

  // Get List Customer
  Future<CustomerDataModel> getListCustomer({required String token}) async {
    var url = Uri.parse("${baseURL}customer");
    var header = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var response = await http.get(url, headers: header);
    // ignore: avoid_print
    print("Login: ${response.body}");

// **success melakukan login
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);
      CustomerDataModel callbackData = CustomerDataModel.fromJson(data);
      return callbackData;
    } else {
      var data = jsonDecode(response.body);
      throw ErrorDescription('${data['message']}');
    }
  }

  // Get List Customer
  Future<CustomerAddressModel> getListCustomerAddress(
      {required String userId, required String token}) async {
    var url = Uri.parse("${baseURL}customer/alamat?id=$userId");
    var header = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    var response = await http.get(url, headers: header);
    // ignore: avoid_print
    print("Address: ${response.body}");

    // **success melakukan login
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);

      CustomerAddressModel dataModel = CustomerAddressModel.fromJson(data);
      return dataModel;
    } else {
      throw Exception("Gagal Mendapatkan List Alamat");
    }
  }
}
