import 'dart:convert';

import 'package:e_shop/models/user_model.dart';
import 'package:e_shop/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  // Login Model
  late UserModel _user;

  UserModel get user => _user;

  set user(UserModel user) {
    _user = user;
    notifyListeners();
  }

  Future<bool> salesLogin({
    required String email,
    required String password,
  }) async {
    print("Login :  $email : $password");
    try {
      UserModel user = await AuthService().salesLogin(
        email: email,
        password: password,
      );
      user.data.password = password;
      _user = user;
      saveLoginData(user);
      return true;
    } catch (e) {
      print("Error : $e");
      return false;
    }
  }

  // Set Login
  void saveLoginData(UserModel user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("data", jsonEncode(user));
  }

  void removeLoginData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("data");
  }

  // Get Login From SharedPref
  Future<UserModel?> getLoginData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var getData = prefs.getString("data");
    print("KONTOL OBJECT : ${getData}");
    if (getData != null) {
      var userData = jsonDecode(getData ?? "");
      UserModel login = UserModel.fromJson(userData);
      _user = login;
      return login;
    } else {
      return null;
    }
  }

  // Profile Model
  late UserModel _profile;

  UserModel get profile => _profile;

  set profile(UserModel profile) {
    _profile = profile;
    notifyListeners();
  }

  // Get Proflie
  Future<bool> salesProfile({required String id}) async {
    print("Get Profile : Token ${_user.token}");
    try {
      UserModel profile =
          await AuthService().getProfile(id: id, token: _user.token!);
      _user.data = profile.data;
      saveLoginData(user);
      print("Get Profile : ${profile.toJson()}");
      return true;
    } catch (e) {
      print("Error profile : $e");
      return false;
    }
  }

  // Get Customer Profile
  Future<bool> getCustomerProfile({required String id}) async {
    try {
      UserModel profile =
          await AuthService().getProfile(id: id, token: _user.token!);
      _profile = profile;
      return true;
    } catch (e) {
      print("Error profile : $e");
      return false;
    }
  }
}
