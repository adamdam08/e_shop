import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:e_shop/models/user_model.dart';

class AuthService {
  String baseURL = 'http://103.127.132.116/api/v1/';

  Future<UserModel> salesLogin(
      {required String email, required String password}) async {
    var url = Uri.parse("${baseURL}auth/login");
    var header = {'Content-Type': 'application/json'};
    Map data = {"email": email, "password": password, "tipe": "sales"};
    var body = jsonEncode(data);
    var response = await http.post(url, headers: header, body: body);
    // ignore: avoid_print
    print("Login: ${response.body}");

// **success melakukan login
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);
      UserModel login = UserModel.fromJson(data);
      return login;
    } else {
      throw Exception("Gagal Login");
    }
  }

  Future<UserModel> getProfile(
      {required String id, required String token}) async {
    var url = Uri.parse("${baseURL}akun/profil?id=$id");
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
      UserModel login = UserModel.fromJson(data);
      return login;
    } else {
      throw Exception("Gagal Mendapatkan Profile");
    }
  }
}
