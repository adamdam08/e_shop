// ignore_for_file: avoid_print

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:e_shop/models/product_model.dart' as ProductModel;
import 'package:e_shop/models/user_model.dart';
import 'package:e_shop/provider/auth_provider.dart';
import 'package:e_shop/provider/page_provider.dart';
import 'package:e_shop/provider/product_provider.dart';
import 'package:e_shop/provider/settings_provider.dart';
import 'package:e_shop/theme/theme.dart';
import 'package:e_shop/ui/category/category.dart';
import 'package:e_shop/ui/home/search_list.dart';
import 'package:e_shop/ui/product/detail_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:transparent_image/transparent_image.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<String> imgList = [];
  int carouselIndex = 0;

  // Search
  FocusNode searchBarFocusNode = FocusNode();
  TextEditingController searchTextController = TextEditingController();
  List<String> myCategoryFiltered = [];
  List<String> _myCategory = [];

  // Location Coordinate
  late LocationPermission permission;
  String _latitude = '';
  String _longitude = '';

  // Produk Terlaku controller
  int totalCart = 0;
  int bestSellerIndex = 1;
  bool _isInitLoading = false;
  bool _isLoading = false;
  bool _isLimit = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    setState(() {
      _isInitLoading = true;
    });

    // Search Bar
    searchBarFocusNode.addListener(_onFocusChange);

    // Add a listener to the scroll controller to detect when the user reaches the bottom of the list
    _scrollController.addListener(_scrollListener);

    // Latest Profil
    _getLatestProfil();

    // Load Suggestion List
    _getSuggestionList();

    // Location Settings
    _getLocationSettings();

    // List Banner
    _getListBanner();

    // Total Data
    _getTotalCart();
  }

  void _onFocusChange() {
    if (context.mounted) {
      setState(() {
        print("Focus Node : ${searchBarFocusNode.hasFocus}");
        if (searchBarFocusNode.hasFocus == false) {
          searchTextController.text = "";
        }
      });
    }
  }

  void _loadData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);

    setState(() {
      _isLoading = true;
      print("Kondisi loading $_isLoading");
    });

    Future.delayed(const Duration(seconds: 5), () async {
      // Get data from SharedPref
      var data = await authProvider.getLoginData();

      // Get Best Seller
      print(
          "Cabang Load More ${settingsProvider.storeLocation.data?.first.id}");
      if (data!.token != null &&
          settingsProvider.storeLocation.data != null &&
          _isLimit != true) {
        if (await productProvider.getBestSellerProduct(
            cabangId: settingsProvider.storeLocation.data!.first.id.toString(),
            token: authProvider.user.token.toString(),
            limit: 6,
            page: bestSellerIndex + 1)) {
          setState(() {
            print(
                "Best seller : ${productProvider.bestSellerProduct?.data.toString()}");
            bestSellerIndex = bestSellerIndex + 1;
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

  // Load Latest Profil
  void _getLatestProfil() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    // Check Latest Profil
    if (await authProvider.salesLogin(
      email: authProvider.user.data.email.toString(),
      password: authProvider.user.data.password.toString(),
    )) {
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
            backgroundColor: Colors.red,
            content: Text(
              'Gagal Mendapatkan Profil Terbaru!',
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
    }
  }

  // Load Banner
  void _getListBanner() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    // Get Banner List
    if (await productProvider.getBannerList(
      bearerToken: authProvider.user.token.toString(),
    )) {
    } else {}
  }

  // Get Location Settings
  void _getLocationSettings() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);

    // Get Store Location
    if (await settingsProvider.getStoreLocation(
      lat: _latitude,
      long: _longitude,
      token: authProvider.user.token.toString(),
      cabangId: authProvider.user.data.cabangId.toString(),
    )) {
      // Get Promo
      _getListPromo();

      // Get Best Seller
      _getListBestSeller();

      setState(() {
        _isInitLoading = false;
      });
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
            backgroundColor: Colors.red,
            content: Text(
              'Gagal Mendapatkan Data!',
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
    }
  }

  void _getListPromo() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    if (await productProvider.getPromoProduct(
        cabangId: authProvider.user.data.cabangId.toString(),
        token: authProvider.user.token.toString(),
        limit: 10,
        page: 1,
        query: "")) {
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
            backgroundColor: Colors.red,
            content: Text(
              'Gagal Mendapatkan Data!',
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
    }
  }

  void _getListBestSeller() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    if (await productProvider.getBestSellerProduct(
        cabangId: authProvider.user.data.cabangId.toString(),
        token: authProvider.user.token.toString(),
        limit: 6,
        page: bestSellerIndex)) {
      print(
          "Best seller : ${productProvider.bestSellerProduct?.data.toString()}");
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
            backgroundColor: Colors.red,
            content: Text(
              'Gagal Mendapatkan Data!',
              textAlign: TextAlign.center,
            ),
          ),
        );
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

  // Get total data
  void _getTotalCart() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);

    // Get data from SharedPref
    var data = await authProvider.getLoginData();
    // Get Category By Tree
    if (await settingsProvider.getTotalCart(
        token: data!.token.toString(),
        cabangId: data.data.cabangId.toString())) {
      if (context.mounted) {
        setState(() {
          totalCart = settingsProvider.totalCart?.totalData!.total ?? 0;
        });
      }
      print("Suggestion Data : ${_myCategory}");
    } else {
      print("Suggestion Data Failed : ${_myCategory}");
    }
  }

  Future<void> _handleRefresh() async {
    // Simulate network fetch or database query
    // await Future.delayed(Duration(seconds: 2));
    // Update the list of items and refresh the UI
    setState(() {
      _isInitLoading = true;
    });

    _getLocationSettings();

    // List Banner
    _getListBanner();
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    ProductProvider productProvider = Provider.of<ProductProvider>(context);
    PageProvider pageProvider = Provider.of(context);
    UserModel loginData = authProvider.user;

    Widget searchbar() {
      return Expanded(
        child: Container(
          height: 50,
          margin: const EdgeInsets.only(right: 10),
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
              hintText: "Cari Barang disini...",
              hintStyle:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
              alignLabelWithHint: true,
            ),
            onFieldSubmitted: (value) {
              if (value != "") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SearchList(text: value)),
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
            onEditingComplete: () => {
              setState(() {
                FocusScope.of(context).unfocus();
                print("Focus Node : ${searchBarFocusNode.canRequestFocus}");
                print("OnEditingComplete");
              })
            },
          ),
        ),
      );
    }

    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return Column(
          children: [
            Container(
              height: 100,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  searchbar(),
                  if (isKeyboardVisible == false) ...[
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/cart');
                      },
                      child: Stack(
                        children: <Widget>[
                          Icon(
                            SolarIconsBold.cartLarge,
                            size: 30,
                            color: backgroundColor3,
                          ),
                          if (totalCart > 0) ...[
                            Positioned(
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Text(
                                  "$totalCart",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/profile');
                      },
                      child: Icon(
                        Icons.view_list,
                        size: 30,
                        color: backgroundColor3,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Expanded(
              child: _isInitLoading
                  ? Container(
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
                    )
                  : RefreshIndicator(
                      onRefresh: _handleRefresh,
                      child: ListView(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        controller: _scrollController,
                        children: [
                          if (isKeyboardVisible) ...[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: SuggestionListView(
                                  myCategory: myCategoryFiltered,
                                  searchTextController: searchTextController),
                            )
                          ] else ...[
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: ((productProvider.bannerData ?? [])
                                      .isNotEmpty)
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Stack(
                                        children: [
                                          CarouselSlider(
                                            items: [
                                              for (var sliderItem
                                                  in productProvider
                                                          .bannerData ??
                                                      [])
                                                FadeInImage.memoryNetwork(
                                                  placeholder:
                                                      kTransparentImage,
                                                  image: sliderItem,
                                                  fit: BoxFit.cover,
                                                  imageErrorBuilder:
                                                      (BuildContext context,
                                                          Object error,
                                                          StackTrace?
                                                              stackTrace) {
                                                    return Container(
                                                      color: Colors.grey,
                                                      child: const Center(
                                                        child:
                                                            Icon(Icons.error),
                                                      ),
                                                    );
                                                  },
                                                ),
                                            ],
                                            options: CarouselOptions(
                                              viewportFraction: 1,
                                              autoPlay: true,
                                              autoPlayCurve: Curves.linear,
                                              reverse: false,
                                              autoPlayInterval:
                                                  const Duration(seconds: 5),
                                              initialPage: carouselIndex,
                                              scrollDirection: Axis.horizontal,
                                              onPageChanged: (index, reason) {
                                                if (context.mounted) {
                                                  setState(() {
                                                    carouselIndex = index;
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 5,
                                            left: 0,
                                            right: 0,
                                            child: DotsIndicator(
                                              dotsCount:
                                                  (productProvider.bannerData ??
                                                          [""])
                                                      .length,
                                              position: carouselIndex,
                                              decorator: DotsDecorator(
                                                color: Colors
                                                    .black38, // Inactive color
                                                activeColor: backgroundColor2,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),
                            ),
                            if (productProvider.promoProduct != null) ...[
                              CardSectionHorizontal(
                                headerText: "Promo",
                                productItem: productProvider.promoProduct,
                              ),
                            ] else
                              ...[],
                            if (productProvider.bestSellerProduct != null) ...[
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (productProvider.bestSellerProduct!.data!
                                        .isNotEmpty) ...[
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        width: double.infinity,
                                        child: Text(
                                          "Produk Terlaku",
                                          style: poppins.copyWith(
                                              fontSize: 24,
                                              fontWeight: semiBold,
                                              color: backgroundColor1),
                                        ),
                                      ),
                                      GridView.builder(
                                        gridDelegate:
                                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                                maxCrossAxisExtent: 200,
                                                mainAxisExtent: 300,
                                                crossAxisSpacing: 15,
                                                mainAxisSpacing: 10),
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: productProvider
                                            .bestSellerProduct!.data!.length,
                                        itemBuilder: (context, index) {
                                          return SearchDynamicCard(
                                            text: productProvider
                                                .bestSellerProduct!
                                                .data![index],
                                          );
                                        },
                                      ),
                                    ] else ...[
                                      const SizedBox()
                                    ],
                                  ],
                                ),
                              ),
                            ] else
                              ...[],
                            _isLoading
                                ? Container(
                                    width: 10,
                                    margin: const EdgeInsets.only(
                                        top: 10, bottom: 10),
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : Container(),
                            SizedBox(
                              height: _isLimit == false ? 40 : 0,
                            )
                          ],
                        ],
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }
}

class CardSectionHorizontal extends StatefulWidget {
  final String headerText;
  final ProductModel.ProductModel? productItem;
  const CardSectionHorizontal({
    super.key,
    required this.headerText,
    required this.productItem,
  });

  @override
  State<CardSectionHorizontal> createState() => _CardSectionHorizontalState();
}

class _CardSectionHorizontalState extends State<CardSectionHorizontal> {
  @override
  Widget build(BuildContext context) {
    final pageProvider = Provider.of<PageProvider>(context, listen: false);

    DateTime? lastPressed;
    Future<bool> onWillPop() async {
      final now = DateTime.now();
      final maxDuration = Duration(seconds: 2);

      if (lastPressed == null || now.difference(lastPressed!) > maxDuration) {
        lastPressed = now;
        Fluttertoast.showToast(
          msg: 'Tekan sekali lagi untuk keluar',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
        );
        return Future.value(false);
      }
      return Future.value(true);
    }

    return WillPopScope(
      onWillPop: onWillPop,
      child: SizedBox(
        height: 340,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              margin: const EdgeInsets.only(top: 20, bottom: 10),
              width: double.infinity,
              child: Text(
                widget.headerText,
                style: poppins.copyWith(
                    fontSize: 24,
                    fontWeight: semiBold,
                    color: backgroundColor1),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(left: 30, right: 30, bottom: 5),
                scrollDirection: Axis.horizontal,
                children: [
                  if (widget.productItem?.data != null) ...[
                    for (var i in widget.productItem!.data!) ...[
                      DynamicCardHorizontal(
                        data: i,
                        isDiscount: i.diskon != 0 && i.diskon != null,
                      )
                    ],
                    if (widget.productItem!.data!.length >= 5) ...[
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            pageProvider.currentIndex = 2;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          width: 150,
                          height: 300,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 0))
                              ]),
                          child: Center(
                            child: Text(
                              "Lihat \nSelengkapnya",
                              style: poppins.copyWith(
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: semiBold,
                                  color: backgroundColor1,
                                  fontSize: 15),
                              maxLines: 2,
                            ),
                          ),
                        ),
                      )
                    ],
                  ] else ...[
                    const SizedBox(),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DynamicCardHorizontal extends StatelessWidget {
  final ProductModel.Data data;
  final bool isDiscount;
  const DynamicCardHorizontal(
      {super.key, required this.data, this.isDiscount = true});

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
                    imageUrl: data.gambar?.first.toString(),
                    id: data.id.toString(),
                  )),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        width: 150,
        height: 300,
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
                image: data.gambar!.first.toString(),
                fit: BoxFit.cover,
                height: 150,
                width: 150,
                imageErrorBuilder: (BuildContext context, Object error,
                    StackTrace? stackTrace) {
                  return Container(
                    height: 150,
                    width: 150,
                    color: Colors.grey,
                    child: const Center(
                      child: Icon(Icons.error),
                    ),
                  );
                },
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
                      data.namaProduk.toString(),
                      style: poppins.copyWith(
                          overflow: TextOverflow.ellipsis,
                          fontWeight: semiBold,
                          color: backgroundColor1,
                          fontSize: 18),
                      maxLines: 2,
                    ),
                    Text(
                      "Rp. ${isDiscount == true ? data.hargaDiskon.toString() : data.harga.toString()}",
                      style: poppins.copyWith(
                          fontWeight: medium, color: backgroundColor3),
                    ),
                    if (isDiscount)
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              "Rp. ${data.harga.toString()}",
                              maxLines: 1,
                              style: poppins.copyWith(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 10,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough),
                            ),
                          ),
                          Text(
                            " ${data.diskon}%",
                            style: poppins.copyWith(
                              fontSize: 10,
                              fontWeight: bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.star,
                          size: 20,
                          color: Colors.yellow,
                        ),
                        Text(
                          "${data.rating}",
                          style: poppins.copyWith(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: semiBold),
                        ),
                      ],
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

class CardSectionVertical extends StatelessWidget {
  final String headerText;
  final ProductModel.ProductModel? productItem;
  const CardSectionVertical(
      {super.key, required this.productItem, required this.headerText});

  @override
  Widget build(BuildContext context) {
    print("ProductItem.data :  ${productItem?.data?.first.namaProduk}");
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: double.infinity,
              child: Text(
                headerText,
                style: poppins.copyWith(
                    fontSize: 24,
                    fontWeight: semiBold,
                    color: backgroundColor1),
              ),
            ),
            if (productItem?.data != null)
              for (var i in productItem!.data!)
                DynamicCardVertical(
                  data: i,
                  isDiscount: i.diskon != 0 && i.diskon != null,
                )
            else
              SizedBox(),
          ],
        ));
  }
}

class DynamicCardVertical extends StatelessWidget {
  final ProductModel.Data data;
  final bool isDiscount;
  const DynamicCardVertical(
      {super.key, required this.data, this.isDiscount = true});

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
                    imageUrl: data.gambar!.first.toString(),
                    id: data.id.toString(),
                  )),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 4,
                  offset: const Offset(0, 0))
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: data.gambar!.first.toString(),
                  fit: BoxFit.cover,
                  height: 125,
                  width: 125,
                  imageErrorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) {
                    return Container(
                      height: 125,
                      width: 125,
                      color: Colors.grey,
                      child: const Center(
                        child: Icon(Icons.error),
                      ),
                    );
                  }),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.namaProduk.toString(),
                      style: poppins.copyWith(
                          overflow: TextOverflow.ellipsis,
                          fontWeight: semiBold,
                          fontSize: 18,
                          color: backgroundColor1),
                      maxLines: 2,
                    ),
                    Text(
                      "Rp. ${isDiscount == true ? data.hargaDiskon.toString() : data.harga.toString()}",
                      style: poppins.copyWith(
                          fontWeight: regular, color: backgroundColor3),
                    ),
                    if (isDiscount)
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              "Rp.${data.harga}",
                              maxLines: 1,
                              style: poppins.copyWith(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 10,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough),
                            ),
                          ),
                          Text(
                            " ${data.diskon}%",
                            style: poppins.copyWith(
                                fontSize: 10,
                                color: Colors.red,
                                fontWeight: bold),
                          ),
                        ],
                      ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.star,
                          size: 20,
                          color: Colors.yellow,
                        ),
                        Text(
                          "${data.rating}",
                          style: poppins.copyWith(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: semiBold),
                        ),
                      ],
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
