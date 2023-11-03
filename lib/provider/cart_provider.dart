import 'package:flutter/cupertino.dart';

class CartProvider with ChangeNotifier{
  // final List<Map> myProducts = List.generate(10, (index) => {
  //   "id": index,
  //   "name": "Lorem Ipsum Sit Dolor Amet",
  //   "price": 100000,
  //   "amount": 1
  // }).toList();

  List<Map> _myProducts = [];
  List<Map> get myProducts => _myProducts;

  set myProducts(List<Map> products){
    myProducts = products;
    notifyListeners();
  }
}