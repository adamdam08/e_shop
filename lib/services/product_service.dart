import 'dart:convert';
import 'package:e_shop/models/detail_product_model.dart';
import 'package:e_shop/models/product/banner_model.dart';
import 'package:e_shop/models/product/product_category_tree_model.dart';
import 'package:e_shop/models/product/suggestion_model.dart';
import 'package:e_shop/models/product_category_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:e_shop/models/product_model.dart';

class ProductService {
  String baseURL = 'http://103.127.132.116/api/v1/';
  // String baseURL = 'http://192.168.122.217:3001/api/v1/';

  // Get Promo Product
  Future<ProductModel> getPromoProduct({
    required String cabangId,
    required String token,
    required int page,
    required int limit,
  }) async {
    var url = Uri.parse(
        "${baseURL}produk?cabang=$cabangId&sort=promo&page=$page&limit=$limit");
    // produk?cabang=1&sort=promo&page=1&limit=15
    var header = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    var response = await http.get(url, headers: header);
    print("Promo uri : ${url}");
    print("Promo response: ${response.body}");

    // **success melakukan login
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);

      ProductModel promoProductModel = ProductModel.fromJson(data);
      return promoProductModel;
    } else {
      throw Exception("Gagal Mendapatkan Promo");
    }
  }

  // Get Product Terlaris
  Future<ProductModel> getBestSellerProduct({
    required String cabangId,
    required String token,
    required int page,
    required int limit,
  }) async {
    var url = Uri.parse(
        "${baseURL}produk?cabang=$cabangId&sort=terlaris&page=$page&limit=$limit");
    // produk?cabang=1&sort=promo&page=1&limit=15
    var header = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    var response = await http.get(url, headers: header);
    print("Promo uri : ${url}");
    print("Promo response: ${response.body}");

    // **success melakukan login
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);
      ProductModel promoProductModel = ProductModel.fromJson(data);

      if (promoProductModel.data!.isNotEmpty) {
        return promoProductModel;
      } else {
        throw Exception("Gagal Mendapatkan Best Seller");
      }
    } else {
      throw Exception("Gagal Mendapatkan Best Seller");
    }
  }

  // Get Product Terlaris
  Future<ProductModel> getSearchProduct(
      {required String cabangId,
      required String token,
      required int page,
      required int limit,
      String? cat,
      String query = ""}) async {
    var url = Uri.parse(
        "${baseURL}produk?cabang=$cabangId&sort=terlaris&page=$page&limit=$limit&cat=$cat&q=$query");
    var header = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    var response = await http.get(url, headers: header);
    print("Promo uri : ${url}");
    print("Promo response: ${response.body}");

    // **success melakukan login
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);
      ProductModel promoProductModel = ProductModel.fromJson(data);

      if (promoProductModel.data!.isNotEmpty) {
        return promoProductModel;
      } else {
        throw Exception("Gagal Mendapatkan Best Seller");
      }
    } else {
      throw Exception("Gagal Mendapatkan Best Seller");
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

  // Category Product
  Future<ProductCategoryModel> getCategoryProduct(
      {required String token}) async {
    var url = Uri.parse("${baseURL}produk/kategori?tree=0");
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

  // Category Product Tree
  Future<CategoryTreeModel> getCategoryTree({required String token}) async {
    var url = Uri.parse("${baseURL}produk/kategori?tree=1");
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

      CategoryTreeModel productCatModel = CategoryTreeModel.fromJson(data);
      return productCatModel;
    } else {
      throw Exception("Gagal Mendapatkan Kategori");
    }
  }

  Future<BannerModel> getBanner({required String token}) async {
    var url = Uri.parse("${baseURL}produk/banner");
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

      BannerModel productCatModel = BannerModel.fromJson(data);
      return productCatModel;
    } else {
      throw Exception("Gagal Mendapatkan Banner");
    }
  }

  Future<SuggestionModel> getSuggestionList({required String token}) async {
    var url = Uri.parse("${baseURL}produk/suggestion");
    var header = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    var response = await http.get(url, headers: header);
    // ignore: avoid_print
    print("Suggestion Service : ${response.body}");

    // **success melakukan login
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);
      SuggestionModel dataModel = SuggestionModel.fromJson(data);
      return dataModel;
    } else {
      throw Exception("Gagal Mendapatkan Saran");
    }
  }
}
