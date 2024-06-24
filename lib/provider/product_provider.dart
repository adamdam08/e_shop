import 'dart:ffi';

import 'package:e_shop/models/detail_product_model.dart';
import 'package:e_shop/models/product/banner_model.dart';
import 'package:e_shop/models/product/product_category_tree_model.dart';
import 'package:e_shop/models/product/suggestion_model.dart';
import 'package:e_shop/models/product/transaction_history_model.dart';
import 'package:e_shop/models/product_category_model.dart';
import 'package:e_shop/models/product_model.dart';
import 'package:e_shop/services/product_service.dart';
import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  // Promo Model
  ProductModel? _promoProduct;

  ProductModel? get promoProduct => _promoProduct;

  set promoProduct(ProductModel? productModel) {
    _promoProduct = productModel;
    notifyListeners();
  }

  Future<bool> getPromoProduct(
      {required String cabangId,
      required String token,
      required int limit,
      required int page,
      String? query}) async {
    try {
      ProductModel promoProduct = await ProductService().getPromoProduct(
          cabangId: cabangId,
          token: token,
          limit: limit,
          page: page,
          query: query);
      if (page != 1) {
        _promoProduct!.data!.addAll(promoProduct.data!.toList());
      } else {
        _promoProduct = promoProduct;
      }
      print("Get Promo : ${promoProduct}");
      return true;
    } catch (e) {
      print("Error : $e");
      return false;
    }
  }

  // Best Seller Model
  ProductModel? _bestSellerProduct;

  ProductModel? get bestSellerProduct => _bestSellerProduct;

  set bestSellerProduct(ProductModel? bestSellerProduct) {
    _bestSellerProduct = bestSellerProduct;
    notifyListeners();
  }

  Future<bool> getBestSellerProduct({
    required String cabangId,
    required String token,
    required int limit,
    required int page,
  }) async {
    try {
      ProductModel promoProduct = await ProductService().getBestSellerProduct(
          cabangId: cabangId, token: token, limit: limit, page: page);
      if (page != 1) {
        _bestSellerProduct!.data!.addAll(promoProduct.data!.toList());
      } else {
        _bestSellerProduct = promoProduct;
      }
      print("Get Best Seller : ${_bestSellerProduct}");
      return true;
    } catch (e) {
      print("Error : $e");
      return false;
    }
  }

  // Search Model
  ProductModel? _searchProduct;

  ProductModel? get searchProduct => _searchProduct;

  set searchProduct(ProductModel? searchProduct) {
    _searchProduct = searchProduct;
    notifyListeners();
  }

  Future<bool> getSearchProduct(
      {required String cabangId,
      required String token,
      required int limit,
      required int page,
      required String sort,
      String? cat,
      String query = ""}) async {
    try {
      ProductModel promoProduct = await ProductService().getSearchProduct(
          cabangId: cabangId,
          token: token,
          limit: limit,
          page: page,
          sort: sort,
          cat: cat,
          query: query);
      if (page != 1) {
        _searchProduct!.data!.addAll(promoProduct.data!.toList());
      } else {
        _searchProduct = promoProduct;
      }
      print("Get Best Seller : ${_bestSellerProduct}");
      return true;
    } catch (e) {
      _searchProduct = ProductModel();
      print("Error : $e");
      return false;
    }
  }

  // Detail Product
  DetailProductModel? _detailProduct;

  DetailProductModel? get detailProduct => _detailProduct;

  set detailProduct(DetailProductModel? detailProduct) {
    _detailProduct = detailProduct;
    notifyListeners();
  }

  Future<bool> getDetailProduct(
      {required String id,
      required String token,
      required String cabang}) async {
    try {
      DetailProductModel detailProduct =
          await ProductService().getDetailProduct(productId: id, token: token);
      _detailProduct = detailProduct;
      _detailProduct?.data?.stok = detailProduct.data?.stok
          ?.where((element) => element.cabang == cabang)
          .toList();
      _detailProduct?.data?.harga = detailProduct.data?.harga
          ?.where((element) => element.cabang == cabang)
          .toList();
      print("Get Promo : ${detailProduct}");
      return true;
    } catch (e) {
      print("Error : $e");
      return false;
    }
  }

  // Category Product
  ProductCategoryModel? _categoryProduct;

  ProductCategoryModel? get categoryProduct => _categoryProduct;

  set categoryProduct(ProductCategoryModel? detailProduct) {
    _categoryProduct = detailProduct;
    notifyListeners();
  }

  Future<bool> getCategoryProduct({required String bearerToken}) async {
    try {
      ProductCategoryModel catProduct =
          await ProductService().getCategoryProduct(token: bearerToken);
      _categoryProduct = catProduct;
      print("Get Category Product : ${catProduct}");
      return true;
    } catch (e) {
      print("Error : $e");
      return false;
    }
  }

  Future<String?> getCategoryByID({required String id}) async {
    try {
      return categoryProduct!.data
          ?.where((element) => element.id.toString() == id)
          .first
          .kat1;
    } catch (e) {
      return "Not Found";
    }
  }

  // Category Product Tree
  CategoryTreeModel? _categoryTree;

  CategoryTreeModel? get categoryTree => _categoryTree;

  set categoryTree(CategoryTreeModel? detailProduct) {
    _categoryTree = detailProduct;
    notifyListeners();
  }

  Future<bool> getCategoryTree({required String bearerToken}) async {
    try {
      CategoryTreeModel catProduct =
          await ProductService().getCategoryTree(token: bearerToken);
      _categoryTree = catProduct;
      print("Get Category Product : ${catProduct}");
      return true;
    } catch (e) {
      print("Error : $e");
      return false;
    }
  }

  // Banner Model
  List<String>? _bannerData;
  List<String>? get bannerData => _bannerData;

  set bannerData(List<String>? bannerData) {
    _bannerData = bannerData;
    notifyListeners();
  }

  Future<bool> getBannerList({required String bearerToken}) async {
    try {
      BannerModel banner = await ProductService().getBanner(token: bearerToken);
      _bannerData = banner.data!.map((e) => e.gambarPromo.toString()).toList();
      print(
          "Get Banner : ${banner.data!.map((e) => e.gambarPromo.toString())}");
      print("Get Banner : ${_bannerData}");
      return true;
    } catch (e) {
      print("Error : $e");
      return false;
    }
  }

// Banner Model
  SuggestionModel? _suggestionData;
  SuggestionModel? get suggestionData => _suggestionData;

  set suggestionData(SuggestionModel? suggestionData) {
    _suggestionData = suggestionData;
    notifyListeners();
  }

  Future<bool> getSuggestionData({required String bearerToken}) async {
    try {
      SuggestionModel suggest =
          await ProductService().getSuggestionList(token: bearerToken);
      _suggestionData = suggest;
      print("Get Suggest : ${suggest.data.toString()}");
      return true;
    } catch (e) {
      print("Error : $e");
      return false;
    }
  }

  // Add Transaction
  Future<String> addTransaction({
    required Map<String, Object?>? data,
    required String token,
  }) async {
    try {
      await ProductService().addTransaction(data: data!, token: token);
      return "";
    } catch (e) {
      return "$e";
    }
  }

  // Banner Model
  TransactionHistoryModel? _transactionHistory;
  TransactionHistoryModel? get transactionHistory => _transactionHistory;

  set transactionHistory(TransactionHistoryModel? transactionHistory) {
    _transactionHistory = transactionHistory;
    notifyListeners();
  }

  // Add Transaction
  Future<bool> getListTransaction({
    required String customerId,
    required String token,
    required String status,
    required String tglAwal,
    required String tglAkhir,
  }) async {
    print("List Transact : tgl awal : ${tglAwal}");
    print("List Transact : tgl akhir  : ${tglAkhir}");
    try {
      TransactionHistoryModel callback = await ProductService()
          .getListTransaction(
              token: token,
              customerId: customerId,
              status: status,
              tglAwal: tglAwal,
              tglAkhir: tglAkhir);
      _transactionHistory = callback;
      return true;
    } catch (e) {
      return false;
    }
  }
}
