import 'dart:ffi';

import 'package:e_shop/models/customer/customer_address_model.dart';
import 'package:e_shop/models/customer/customer_data_model.dart';
import 'package:e_shop/services/customer_service.dart';
import 'package:flutter/cupertino.dart';

class CustomerProvider with ChangeNotifier {
  List<Map<String, String?>> _myCustomer = [];
  List<Map<String, String?>> get myCustomer => _myCustomer;

  set myCustomer(List<Map<String, String?>> customer) {
    _myCustomer = customer;
    notifyListeners();
  }

  int _selectCustomer = 0;
  int get selectCustomer => _selectCustomer;

  set selectCustomer(int customer) {
    _selectCustomer = customer;
    notifyListeners();
  }

  Future<String> addCustomerData({
    required Map data,
    required String token,
  }) async {
    try {
      await CustomerService().addNewCustomer(data: data, token: token);
      return "";
    } catch (e) {
      return "$e";
    }
  }

  Future<String> updateCustomerData({
    required bool isSales,
    required Map data,
    required String id,
    required String token,
  }) async {
    try {
      await CustomerService()
          .updateCustomer(isSales: isSales, data: data, id: id, token: token);
      return "";
    } catch (e) {
      return "$e";
    }
  }

  Future<bool> getListCustomerData({
    required String token,
  }) async {
    try {
      CustomerDataModel data =
          await CustomerService().getListCustomer(token: token);
      _myCustomer = data.data!
          .map((e) => {
                "id": e.id.toString(),
                "username": e.username,
                "password": e.password,
                "email": e.emailPelanggan,
                "nama_lengkap": e.namaPelanggan,
                "tgl_lahir": e.tglLahirPelanggan, // datepicker
                "jenis_kelamin":
                    e.jenisKelaminPelanggan, // Laki-laki / Perempuan
                "alamat": e.alamatPelanggan,
                "telp": e.telpPelanggan,
              })
          .toList();

      print("List Customer : ${data.data?.map((e) => {
            "id": e.id,
            "username": e.username,
            "password": e.password,
            "email": e.emailPelanggan,
            "nama_lengkap": e.namaPelanggan,
            "tgl_lahir": e.tglLahirPelanggan, // datepicker
            "jenis_kelamin": e.jenisKelaminPelanggan, // Laki-laki / Perempuan
            "alamat": e.alamatPelanggan,
            "telp": e.telpPelanggan,
          }.toString())}");
      return true;
    } catch (e) {
      return false;
    }
  }

  String _selectedCity = "-";
  String get selectedCity => _selectedCity;

  set selectedCity(String selectedCity) {
    _selectedCity = selectedCity;
    notifyListeners();
  }

  //Address
  CustomerAddressModel? _customerAddressList;
  CustomerAddressModel? get customerAddressList => _customerAddressList;

  set customerAddressList(CustomerAddressModel? customerAddressList) {
    _customerAddressList = customerAddressList;
    notifyListeners();
  }

  Future<bool> getListCustomerAddress({
    required String id,
    required String token,
  }) async {
    try {
      CustomerAddressModel data = await CustomerService()
          .getListCustomerAddress(userId: id, token: token);
      _customerAddressList = data!;
      return true;
    } catch (e) {
      return false;
    }
  }

  int? _selectAddress;
  int? get selectAddress => _selectAddress;

  set selectAddress(int? selectAddress) {
    _selectAddress = selectAddress;
    notifyListeners();
  }
}
