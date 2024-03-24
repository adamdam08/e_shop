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

  Future<bool> getStoreLocation(
      {required String lat,
      required String long,
      required String token}) async {
    print("Store Location :  $lat : $long");
    try {
      StoreLocationModel storeLocation = await SettingsService()
          .getStoreByCoordinate(lat: lat, long: long, token: token);
      _storeLocation = storeLocation;
      _storeLocation.data = _storeLocation.data
          ?.where((element) => element.terdekat == true)
          .toList();

      print("Store Location :  ${storeLocation.data?.length}");
      return true;
    } catch (e) {
      print("Error : $e");
      return false;
    }
  }
}
