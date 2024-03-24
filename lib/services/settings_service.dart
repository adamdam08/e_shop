import 'dart:convert';
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
}
