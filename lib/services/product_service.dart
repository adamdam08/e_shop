import 'dart:convert';
import 'package:e_shop/models/detail_product_model.dart';
import 'package:e_shop/models/product_category_model.dart';
import 'package:http/http.dart' as http;
import 'package:e_shop/models/promo_product_model.dart';

class ProductService {
  String baseURL = 'http://103.127.132.116/api/v1/';

  // Get Promo Product
  Future<PromoProductModel> getPromoProduct(
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

      PromoProductModel promoProductModel = PromoProductModel.fromJson(data);
      return promoProductModel;
    } else {
      throw Exception("Gagal Mendapatkan Promo");
    }
  }

  // Get Detail Product
  Future<DetailProductModel> getDetailProduct(
      {required String productId, required String token}) async {
    var url = Uri.parse("${baseURL}produk/detail/$productId");
    var header = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    var response = await http.get(url, headers: header);
    // ignore: avoid_print
    print("Detail Product: ${response.body}");

    // **success melakukan login
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);

      DetailProductModel detailProductModel = DetailProductModel.fromJson(data);
      return detailProductModel;
    } else {
      throw Exception("Gagal Mendapatkan Promo");
    }
  }

  Future<ProductCategoryModel> getCategoryProduct(
      {required String token}) async {
    var url = Uri.parse("${baseURL}produk/kategori");
    var header = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    var response = await http.get(url, headers: header);
    // ignore: avoid_print
    print("Category Product: ${response.body}");

    // **success melakukan login
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);

      ProductCategoryModel productCatModel =
          ProductCategoryModel.fromJson(data);
      return productCatModel;
    } else {
      throw Exception("Gagal Mendapatkan Kategori");
    }
  }
}
