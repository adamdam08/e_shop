import 'package:e_shop/models/settings/payment_model.dart';
import 'package:e_shop/models/settings/shipping_model.dart';
import 'package:e_shop/models/store_location_model.dart';
import 'package:e_shop/services/settings_service.dart';
import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  // Login Model
  late StoreLocationModel _storeLocation;

  StoreLocationModel get storeLocation => _storeLocation;

  set storeLocation(StoreLocationModel storeLocation) {
    _storeLocation = storeLocation;
    notifyListeners();
  }

  Future<bool> getStoreLocation({
    required String lat,
    required String long,
    required String token,
    required String cabangId,
  }) async {
    print("Store Location :  $lat : $long");
    try {
      StoreLocationModel storeLocation = await SettingsService()
          .getStoreByCoordinate(lat: lat, long: long, token: token);
      _storeLocation = storeLocation;
      _storeLocation.data = _storeLocation.data
          ?.where((element) => element.id == int.parse(cabangId))
          .toList();
      print("Store Location :  ${storeLocation.data?.length}");
      return true;
    } catch (e) {
      print("Error : $e");
      return false;
    }
  }

  // Shipping list
  ShippingModel? _shippingList;

  ShippingModel? get shippingList => _shippingList;

  set shippingList(ShippingModel? shippingList) {
    _shippingList = shippingList;
    notifyListeners();
  }

  Future<bool> getShippingList({
    required String token,
    required String cabangId,
  }) async {
    try {
      ShippingModel data = await SettingsService()
          .getListShipping(token: token, cabang: cabangId);
      _shippingList = data;
      print("Store Location :  ${storeLocation.data?.length}");
      return true;
    } catch (e) {
      print("Error : $e");
      return false;
    }
  }

  int? _selectedShip;
  int? get selectedShip => _selectedShip;

  set selectedShip(int? selectedShip) {
    _selectedShip = selectedShip;
    notifyListeners();
  }

  // Payment List
  PaymentModel? _paymentList;

  PaymentModel? get paymentList => _paymentList;

  set paymentList(PaymentModel? paymentList) {
    _paymentList = paymentList;
    notifyListeners();
  }

  Future<bool> getPaymentList({
    required String token,
    required String cabangId,
  }) async {
    try {
      PaymentModel data = await SettingsService().getListPayment(token: token, cabang: cabangId);
      _paymentList = data;
      print("Store Location :  ${storeLocation.data?.length}");
      return true;
    } catch (e) {
      print("Error : $e");
      return false;
    }
  }

  int? _selectedPayment;
  int? get selectedPayment => _selectedPayment;

  set selectedPayment(int? selectedPayment) {
    _selectedPayment = selectedPayment;
    notifyListeners();
  }
}
