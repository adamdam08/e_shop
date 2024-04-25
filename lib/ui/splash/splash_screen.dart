import 'dart:convert';

import 'package:e_shop/models/settings/district_model.dart';
import 'package:e_shop/provider/auth_provider.dart';
import 'package:e_shop/provider/cart_provider.dart';
import 'package:e_shop/provider/customer_provider.dart';
import 'package:e_shop/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  State<SplashScreenPage> createState() => SplashScreenPageState();
}

class SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final customerProvider =
        Provider.of<CustomerProvider>(context, listen: false);

    // Load District
    loadDistrict();

    Future.delayed(const Duration(seconds: 1), () async {
      var data = await authProvider.getLoginData();
      if (context.mounted) {
        if (data?.token != null) {
          // Get data from SharedPref
          var data = await authProvider.getLoginData();
          Future.delayed(Duration.zero, () async {
            // Get Store Location
            print("Token : ${data!.token}");
            if (await cartProvider.getCartList(
                token: authProvider.user.token.toString())) {
              //print(cartProvider.cartList.listData?.first.cartData?.length.toString());
              if (context.mounted) {
                setState(() {});
              }
            } else {}

            if (data.token != null) {
              if (await customerProvider.getListCustomerData(
                  token: data.token.toString())) {
              } else {}
            }

            Navigator.pushNamedAndRemoveUntil(
                context, '/home', (route) => false);
          });
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, '/login', (route) => false);
        }
      }
    });
  }

  Future<List<String?>> loadDistrict() async {
    String data = await rootBundle.loadString('assets/district.json');
    print("Assets : ${json.decode(data)}");
    DistrictModel districtData = DistrictModel.fromJson(json.decode(data));
    return districtData.districtData!.map((e) => e.name).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 50),
            alignment: Alignment.bottomCenter,
            child: const CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/logo.png'),
                Text(
                  "TOKO SM",
                  style: poppins.copyWith(
                    fontWeight: semiBold,
                    color: Colors.white,
                    fontSize: 32,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor3,
    );
  }
}
