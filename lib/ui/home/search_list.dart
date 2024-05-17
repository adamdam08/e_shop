import 'dart:math';

import 'package:e_shop/models/product_model.dart';
import 'package:e_shop/provider/auth_provider.dart';
import 'package:e_shop/provider/product_provider.dart';
import 'package:e_shop/provider/settings_provider.dart';
import 'package:e_shop/theme/theme.dart';
import 'package:e_shop/ui/category/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import '../product/detail_item.dart';

class SearchList extends StatefulWidget {
  final String text;
  final bool isPromo;
  final String cat;
  const SearchList(
      {super.key, required this.text, this.isPromo = false, this.cat = ""});

  @override
  State<SearchList> createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  List<String> myCategoryFiltered = [];
  List<String> _myCategory = [];

  int searchIndex = 1;
  bool _isLoading = false;
  bool _isInitLoading = false;
  bool _isLimit = false;
  final ScrollController _scrollController = ScrollController();

  FocusNode searchBarFocusNode = FocusNode();
  TextEditingController searchTextController = TextEditingController();

  @override
  initState() {
    super.initState();
    searchTextController.text = "";
    searchBarFocusNode.addListener(_onFocusChange);

    // Add a listener to the scroll controller to detect when the user reaches the bottom of the list
    _scrollController.addListener(_scrollListener);

    setState(() {
      _isInitLoading = true;
    });

    print("Promo : ${widget.isPromo}");

    if (widget.cat != "") {
      // Get Promo
      _getByCategory();
    } else {
      if (widget.isPromo) {
        // Get Promo
        _getPromoList();
      } else {
        _getBySearch();
      }
    }

    // Get Suggestion
    _getSuggestionList();
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
            limit: 6,
            page: searchIndex + 1,
            query: searchTextController.text.isEmpty
                ? null
                : searchTextController.text)) {
          setState(() {
            searchIndex = searchIndex + 1;
          });
        } else {
          setState(() {
            _isLimit = true;
          });
        }
      }

      setState(() {
        _isLoading = false;
        print("kondisi loading $_isLoading");
      });

      // }
    });
  }

  void _getBySearch() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    if (await authProvider.getLoginData() != null &&
        settingsProvider.storeLocation.data != null) {
      if (await productProvider.getSearchProduct(
          cabangId: authProvider.user.data.cabangId.toString(),
          token: authProvider.user.token.toString(),
          limit: 6,
          page: searchIndex,
          sort: "",
          cat: "",
          query: widget.text)) {
        print("Search Result ${productProvider.searchProduct}");
        setState(() {});
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
              backgroundColor: Colors.red,
              content: Text(
                'Data Tidak Ditemukan!',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        setState(() {});
      }
    }
  }

  void _getByCategory() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    if (await authProvider.getLoginData() != null &&
        settingsProvider.storeLocation.data != null) {
      if (await productProvider.getSearchProduct(
          cabangId: authProvider.user.data.cabangId.toString(),
          token: authProvider.user.token.toString(),
          limit: 6,
          page: searchIndex,
          sort: "",
          cat: widget.cat,
          query: widget.text)) {
        print("Search Result ${productProvider.searchProduct}");
        setState(() {});
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
              backgroundColor: Colors.red,
              content: Text(
                'Data Tidak Ditemukan!',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        setState(() {});
      }
    }
  }

  void _getPromoList() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    if (await authProvider.getLoginData() != null &&
        settingsProvider.storeLocation.data != null) {
      if (await productProvider.getSearchProduct(
          cabangId: authProvider.user.data.cabangId.toString(),
          token: authProvider.user.token.toString(),
          limit: 6,
          page: searchIndex,
          sort: "promo",
          cat: widget.cat,
          query: widget.text)) {
        print("Search Result ${productProvider.searchProduct}");
        setState(() {});
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
              backgroundColor: Colors.red,
              content: Text(
                'Data Tidak Ditemukan!',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        setState(() {});
      }
    }
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
      setState(() {
        _isInitLoading = false;
      });
      print("Suggestion Data : ${_myCategory}");
    } else {
      setState(() {
        _isInitLoading = false;
      });
      print("Suggestion Data Failed : ${_myCategory}");
    }
  }

  void _onFocusChange() {
    if (context.mounted) {
      setState(() {
        print("Searchbar Clicked ${searchBarFocusNode.hasFocus}");
        if (searchBarFocusNode.hasFocus == false) {
          searchTextController.text = "";
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    Widget searchBar(bool isKeyboardVisible) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (isKeyboardVisible == false) ...[
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: SizedBox(
                  child: Icon(
                    Icons.arrow_back,
                    color: backgroundColor1,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
            Expanded(
              child: Container(
                height: 50,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: TextField(
                  textInputAction: TextInputAction.search,
                  controller: searchTextController,
                  focusNode: searchBarFocusNode,
                  obscureText: false,
                  cursorColor: Colors.grey,
                  maxLines: 1,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    prefixIconColor: Colors.grey,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(color: Colors.red, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(color: Colors.green, width: 1),
                    ),
                    hintText: "Cari disini...",
                    hintStyle:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                    alignLabelWithHint: true,
                  ),
                  onSubmitted: (value) {
                    if (value != "") {
                      FocusScope.of(context).unfocus();
                      searchTextController.text = "";
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchList(
                                  text: value,
                                  cat: widget.cat,
                                )),
                      );
                    }
                  },
                  onChanged: (query) {
                    setState(() {
                      myCategoryFiltered.clear();
                      myCategoryFiltered = _myCategory
                          .where((element) => element
                              .toLowerCase()
                              .contains(query.toLowerCase()))
                          .toList();
                    });
                  },
                  onTap: () {
                    print("Focus : ${searchBarFocusNode.hasFocus}");
                  },
                ),
              ),
            ),
          ],
        ),
      );
    }

    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Scaffold(
        body: SafeArea(
            top: true,
            left: true,
            right: true,
            bottom: true,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              color: Colors.white,
              child: _isInitLoading
                  ? Expanded(
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: backgroundColor1,
                            ),
                            Container(
                              height: 30,
                            ),
                            Text(
                              "Loading Data",
                              style: poppins.copyWith(
                                fontWeight: semiBold,
                                color: backgroundColor1,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        searchBar(isKeyboardVisible),
                        if (isKeyboardVisible) ...[
                          Expanded(
                            child: SuggestionListView(
                                myCategory: myCategoryFiltered,
                                searchTextController: searchTextController),
                          )
                        ] else ...[
                          if (widget.isPromo) ...[
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: backgroundColor3),
                              child: Text("Promo",
                                  style: poppins.copyWith(color: Colors.white)),
                            )
                          ],
                          if (widget.cat != "") ...[
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: backgroundColor3),
                              child: Text(widget.cat.replaceAll('_', ' '),
                                  style: poppins.copyWith(color: Colors.white)),
                            )
                          ],
                          const SizedBox(
                            height: 10,
                          ),
                          if (widget.text.isNotEmpty) ...[
                            RichText(
                              text: TextSpan(
                                text: 'Hasil Pencarian : ',
                                style: poppins.copyWith(color: Colors.black),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: widget.text,
                                      style: poppins.copyWith(
                                          color: backgroundColor1)),
                                ],
                              ),
                            ),
                          ],
                          const SizedBox(
                            height: 10,
                          ),
                          if (productProvider.searchProduct?.data == null) ...[
                            Expanded(
                              child: Center(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.report_problem,
                                    size: 48,
                                  ),
                                  Text(
                                    "Produk Tidak Tersedia",
                                    style: poppins.copyWith(
                                        fontWeight: regular, fontSize: 20),
                                  ),
                                ],
                              )),
                            )
                          ] else ...[
                            Expanded(
                              child: GridView.builder(
                                controller: _scrollController,
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 200,
                                        mainAxisExtent: 300,
                                        crossAxisSpacing: 25,
                                        mainAxisSpacing: 10),
                                itemCount:
                                    productProvider.searchProduct!.data!.length,
                                itemBuilder: (BuildContext ctx, index) {
                                  return SearchDynamicCard(
                                      text: productProvider
                                          .searchProduct!.data![index]);
                                },
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            _isLoading
                                ? Center(
                                    child: Container(
                                      height: _isLoading ? 15 : 0,
                                      width: 15,
                                      child: const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                  )
                                : Container(),
                          ]
                        ],
                      ],
                    ),
            )),
      );
    });
  }
}

class SearchDynamicCard extends StatelessWidget {
  final Data text;
  final bool isDiscount;
  const SearchDynamicCard(
      {super.key, required this.text, this.isDiscount = true});

  @override
  Widget build(BuildContext context) {
    final settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailItem(
                    imageUrl: text.gambar?.first,
                    id: text.id.toString(),
                  )),
        );
      },
      child: Container(
        width: 150,
        height: 325,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 4,
                  offset: const Offset(0, 0))
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: text.gambar!.first,
                fit: BoxFit.cover,
                height: 175,
                width: 175,
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      text.namaProduk.toString(),
                      style: poppins.copyWith(
                          overflow: TextOverflow.ellipsis,
                          fontWeight: semiBold,
                          color: backgroundColor1,
                          fontSize: 18),
                      maxLines: 2,
                    ),
                    Text(
                      "Rp. ${text.diskon == null ? text.harga.toString() : text.hargaDiskon.toString()}",
                      style: poppins.copyWith(
                          fontWeight: medium, color: backgroundColor3),
                    ),
                    if (text.diskon != null) ...[
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              "Rp. ${text.hargaDiskon.toString()}",
                              maxLines: 1,
                              style: poppins.copyWith(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 10,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough),
                            ),
                          ),
                          Text(
                            " ${text.diskon}%",
                            style: poppins.copyWith(
                              fontSize: 10,
                              fontWeight: bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.location_city,
                          color: Colors.orange,
                          size: 12,
                        ),
                        Text(
                          " Cab. ${settingsProvider.storeLocation.data?.first.namaCabang}",
                          style: poppins.copyWith(
                            fontSize: 12,
                            fontWeight: semiBold,
                            color: backgroundColor2,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
