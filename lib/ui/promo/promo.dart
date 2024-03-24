import 'package:e_shop/provider/auth_provider.dart';
import 'package:e_shop/provider/product_provider.dart';
import 'package:e_shop/provider/settings_provider.dart';
import 'package:e_shop/ui/home/home.dart';
import 'package:e_shop/theme/theme.dart';
import 'package:e_shop/ui/home/search_list.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../category/category.dart';

class Promo extends StatefulWidget {
  const Promo({super.key});

  @override
  State<Promo> createState() => _PromoState();
}

class _PromoState extends State<Promo> {
  List<String> myCategoryFiltered = [];
  List<String> myCategory = ["Tepung", "Kecap", "Sambal", "Beras", "Mie"];

  FocusNode searchBarFocusNode = FocusNode();
  TextEditingController searchTextController = TextEditingController();

  // Location Coordinate
  late LocationPermission permission;
  String _latitude = '';
  String _longitude = '';

  @override
  void initState() {
    super.initState();
    searchBarFocusNode.addListener(_onFocusChange);

    _getLocation();

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);

    Future.delayed(Duration.zero, () async {
      // Get data from SharedPref
      var data = await authProvider.getLoginData();

      // Get Store Location
      if (data?.token != null) {
        if (await settingsProvider.getStoreLocation(
            lat: _latitude,
            long: _latitude,
            token: authProvider.user.token.toString())) {
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                backgroundColor: Colors.red,
                content: Text(
                  'Gagal Mendapatkan Lokasi!',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
        }
      }

      // Get Promo
      print("Cabang ${settingsProvider.storeLocation.data?.first.id}");
      if (data?.token != null && settingsProvider.storeLocation.data != null) {
        if (await productProvider.getPromoProduct(
            cabangId: settingsProvider.storeLocation.data!.first.id.toString(),
            token: authProvider.user.token.toString())) {
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                backgroundColor: Colors.red,
                content: Text(
                  'Gagal Mendapatkan Promo Terbaru!',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
        }
      }
    });
  }

  void _onFocusChange() {
    setState(() {
      print("Searchbar Clicked ${searchBarFocusNode.hasFocus}");
    });
  }

  @override
  void dispose() {
    super.dispose();
    searchBarFocusNode.removeListener(_onFocusChange);
    searchBarFocusNode.dispose();
  }

  // Function to get the current location
  void _getLocation() async {
    permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _latitude = position.latitude.toString();
      _longitude = position.longitude.toString();
    });

    print("Location : ${_latitude}, ${_longitude} ");
  }

  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider = Provider.of<ProductProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        print("Searchbar Clicked ${searchBarFocusNode.hasFocus}");
        searchBarFocusNode.removeListener(() {});
        setState(() {});
        return true;
      },
      child: Container(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              color: backgroundColor3,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Promo",
                          style: poppins.copyWith(
                              fontSize: 20,
                              fontWeight: semiBold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  searchbar()
                ],
              ),
            ),
            if (searchBarFocusNode.hasFocus) ...[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SuggestionListView(
                      myCategory: myCategoryFiltered,
                      searchTextController: searchTextController),
                ),
              )
            ] else ...[
              Expanded(
                child: ListView(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  children: [
                    if (productProvider.promoProduct?.data != null)
                      for (var i in productProvider.promoProduct!.data!)
                        DynamicCardVertical(
                          data: i,
                          isDiscount: i.diskon != 0,
                        )
                    else
                      SizedBox(),
                  ],
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget searchbar() {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white),
      child: TextFormField(
        textInputAction: TextInputAction.search,
        obscureText: false,
        cursorColor: Colors.grey,
        maxLines: 1,
        controller: searchTextController,
        focusNode: searchBarFocusNode,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          prefixIconColor: Colors.grey,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Colors.white, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: backgroundColor3, width: 1),
          ),
          hintText: "Cari promo disini...",
          hintStyle:
              const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
          alignLabelWithHint: true,
        ),
        onFieldSubmitted: (value) {
          if (value != "") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchList(text: value)),
            );
          }
        },
        onChanged: (query) {
          setState(() {
            myCategoryFiltered.clear();
            myCategoryFiltered = myCategory
                .where((element) =>
                    element.toLowerCase().contains(query.toLowerCase()))
                .toList();
          });
        },
      ),
    );
  }
}
