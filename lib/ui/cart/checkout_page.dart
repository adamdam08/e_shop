import 'package:e_shop/provider/cart_provider.dart';
import 'package:e_shop/provider/customer_provider.dart';
import 'package:e_shop/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatefulWidget {
  CheckoutPage({Key? key}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String selectedCustomer = "Pilih customer";
  String? customerID;

  @override
  void initState() {
    super.initState();

    _setCustomerData();
  }

  void _setCustomerData() async {
    CustomerProvider customerProvider =
        Provider.of<CustomerProvider>(context, listen: false);
// dummy data
    List<Map<dynamic, dynamic>> customerListFiltered = [];
    customerListFiltered = customerProvider.myCustomer;
    customerListFiltered = customerListFiltered
        .where((element) =>
            element["id"] == customerProvider.selectCustomer.toString())
        .toList();

    if (customerProvider.myCustomer.isEmpty) {
      selectedCustomer = "Pilih customer";
    } else {
      if (customerListFiltered.isNotEmpty) {
        selectedCustomer = customerListFiltered.first["nama_lengkap"];
        customerID = customerListFiltered.first["id"];
      } else {
        selectedCustomer = "Pilih customer";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    CartProvider cartProduct = Provider.of<CartProvider>(context);
    CustomerProvider customerProvider = Provider.of<CustomerProvider>(context);

    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: true,
        left: true,
        right: true,
        child: Container(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                color: backgroundColor3,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const SizedBox(
                            width:
                                20, //MediaQuery.of(context).size.width * 0.1,
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Text(
                          "Pengiriman",
                          style: poppins.copyWith(
                              fontSize: 20,
                              fontWeight: semiBold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: Column(
                children: [
                  Text(
                    "${selectedCustomer} (${customerID})",
                    style: poppins.copyWith(
                        fontSize: 20, fontWeight: semiBold, color: Colors.red),
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
