import 'dart:ffi';

import 'package:e_shop/models/customer/customer_address_model.dart';
import 'package:e_shop/models/customer/customer_data_model.dart';
import 'package:e_shop/models/customer/customer_request_update_model.dart';
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

  Future<String> updateCustomerPassword({
    required Map data,
    required String token,
  }) async {
    try {
      await CustomerService().updatePasswordSales(data: data, token: token);
      return "";
    } catch (e) {
      return "$e";
    }
  }

  Future<bool> getListCustomerData({
    required String token,
    required String sort,
    required String order,
  }) async {
    try {
      print("Filter data at provider $order");
      print("Sort data at provider $sort");

      CustomerDataModel data = await CustomerService().getListCustomer(
        token: token,
        sort: sort,
        order: order,
      );
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
                "lat": e.lat.toString(),
                "lon": e.lon.toString(),
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
            "lat": e.lat.toString(),
            "lon": e.lon.toString(),
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

  // Update Request Data
  CustomerRequestUpdateModel? _customerRequestUpdateData;
  CustomerRequestUpdateModel? get customerRequestUpdateData =>
      _customerRequestUpdateData;

  set customerRequestUpdateData(
      CustomerRequestUpdateModel? customerRequestUpdateData) {
    _customerRequestUpdateData = customerRequestUpdateData;
    notifyListeners();
  }

  Future<bool> getRequestUpdateData({
    required String id,
    required String token,
  }) async {
    try {
      CustomerRequestUpdateModel data = await CustomerService()
          .getRequestDataChangeCustomer(userId: id, token: token);
      _customerRequestUpdateData = data;
      return true;
    } catch (e) {
      _customerRequestUpdateData = CustomerRequestUpdateModel();
      return false;
    }
  }

  Future<String> addRequestUpdateData({
    required Map data,
    required String token,
  }) async {
    try {
      await CustomerService()
          .addRequestDataChangeCustomer(data: data, token: token);
      return "";
    } catch (e) {
      return "$e";
    }
  }
}
