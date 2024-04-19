import 'package:e_shop/models/product_model.dart';
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
  List<String> _myCategory = [];

  FocusNode searchBarFocusNode = FocusNode();
  TextEditingController searchTextController = TextEditingController();

  // Location Coordinate
  late LocationPermission permission;
  String _latitude = '';
  String _longitude = '';

  // Produk Terlaku controller
  int promoIndex = 1;
  bool _isLoading = false;
  bool _isLimit = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    searchBarFocusNode.addListener(_onFocusChange);

    // Add a listener to the scroll controller to detect when the user reaches the bottom of the list
    _scrollController.addListener(_scrollListener);

    // Get Suggestion
    _getSuggestionList();

    // Get Location
    _getLocation();

    // Get Promo
    _getPromo();
  }

  void _getSuggestionList() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final productProvider =
    Provider.of<ProductProvider>(context, listen: false);

    // Get data from SharedPref
    var data = await authProvider.getLoginData();
    // Get Category By Tree
    if (await productProvider.getSuggestionData(
        bearerToken: data!.token.toString())) {
      if (context.mounted) {
        setState(() {
          _myCategory.clear();
          _myCategory = productProvider.suggestionData!.data!;
        });
      }
      print("Suggestion Data : ${_myCategory}");
    } else {
      print("Suggestion Data Failed : ${_myCategory}");
    }
  }

  // Load more data
  void _scrollListener() {
    print("${_scrollController.position.pixels}");
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        _isLimit == false) {
      // User has scrolled to the bottom, load more data
      print("Reach End");
      _loadData();
    } else {
      print("Not Reach End");
    }
  }

  void _loadData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);

    // Simulated data loading, you would replace this with your actual data loading logic
    if (context.mounted) {
      setState(() {
        _isLoading = true;
        print("Kondisi loading $_isLoading");
      });
    }

    Future.delayed(const Duration(seconds: 5), () async {
      var data = await authProvider.getLoginData();

      // Get Best Seller
      print(
          "Cabang Load More ${settingsProvider.storeLocation.data?.first.id}");
      if (data!.token != null &&
          settingsProvider.storeLocation.data != null &&
          _isLimit != true) {
        if (await productProvider.getPromoProduct(
            cabangId: settingsProvider.storeLocation.data!.first.id.toString(),
            token: authProvider.user.token.toString(),
            limit: 5,
            page: promoIndex + 1,
            query: searchTextController.text.isEmpty ? null : searchTextController.text
        )) {
          if (context.mounted) {
            setState(() {
              promoIndex = promoIndex + 1;
            });
          }
        } else {
          if (context.mounted) {
            setState(() {
              _isLimit = true;
            });
          }
        }
      }
      if (context.mounted) {
        setState(() {
          _isLoading = false;
          print("kondisi loading $_isLoading");
        });
      }

      // }
    });
  }

  void _onFocusChange() {
    if (context.mounted) {
      setState(() {
        print("Searchbar Clicked ${searchBarFocusNode.hasFocus}");
        if(searchBarFocusNode.hasFocus == false){
          searchTextController.text = "";
        }
      });
    }
  }

  // Function to get the current location
  void _getLocation() async {
    permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  void _getPromo() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);

    // Get data from SharedPref
    var data = await authProvider.getLoginData();

    // Get Promo
    if (data?.token != null) {
      if (await productProvider.getPromoProduct(
          cabangId: authProvider.user.data.cabangId.toString(),
          token: authProvider.user.token.toString(),
          limit: 5,
          page: promoIndex,
          query: searchTextController.text
      )) {
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
  }

  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider = Provider.of<ProductProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        print("Searchbar Clicked ${searchBarFocusNode.hasFocus}");
        searchBarFocusNode.removeListener(() {});
        if (context.mounted) {
          setState(() {});
        }
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
                      searchTextController: searchTextController,
                    isPromo: true,
                  ),
                ),
              )
            ] else ...[
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: productProvider.promoProduct!.data!.length,
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  itemBuilder: (context, index) {
                    return DynamicCardVertical(
                      data: productProvider.promoProduct!.data![index],
                      isDiscount: productProvider
                                  .promoProduct!.data![index].diskon !=
                              0 &&
                          productProvider.promoProduct!.data![index].diskon !=
                              null,
                    );
                  },
                ),
              ),
            ],
            _isLoading
                ? Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Container(),
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
              MaterialPageRoute(builder: (context) => SearchList(text: value, isPromo: true,)),
            );
          }
        },
        onChanged: (query) {
          if (context.mounted) {
            setState(() {
              myCategoryFiltered.clear();
              myCategoryFiltered = _myCategory
                  .where((element) =>
                      element.toLowerCase().contains(query.toLowerCase()))
                  .toList();
            });
          }
        },
      ),
    );
  }
}
