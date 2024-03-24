import 'package:e_shop/models/detail_product_model.dart';
import 'package:e_shop/models/product_category_model.dart';
import 'package:e_shop/models/promo_product_model.dart';
import 'package:e_shop/services/product_service.dart';
import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  // Promo Model
  PromoProductModel? _promoProduct;

  PromoProductModel? get promoProduct => _promoProduct;

  set promoProduct(PromoProductModel? promoProductModel) {
    _promoProduct = promoProductModel;
    notifyListeners();
  }

  Future<bool> getPromoProduct(
      {required String cabangId, required String token}) async {
    try {
      PromoProductModel promoProduct = await ProductService()
          .getPromoProduct(cabangId: cabangId, token: token);
      _promoProduct = promoProduct;
      print("Get Promo : ${promoProduct}");
      return true;
    } catch (e) {
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
}
