import 'package:flutter/cupertino.dart';

class CustomerProvider with ChangeNotifier {
  // final List<Map> myProducts = List.generate(0, (index) => {
  //   "id": index,
  //   "name": "Product $index",
  //   "phone" : "6288888888",
  //   "address" : "Malang city"
  // }).toList();

  List<Map> _myCustomer = [];
  List<Map> get myCustomer => _myCustomer;

  set myCustomer(List<Map> customer) {
    _myCustomer = customer;
    notifyListeners();
  }

  int _selectCustomer = 0;
  int get selectCustomer => _selectCustomer;

  set selectCustomer(int customer) {
    _selectCustomer = customer;
    notifyListeners();
  }
}
