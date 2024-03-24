import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:e_shop/models/promo_product_model.dart' as ProductModel;
import 'package:e_shop/models/user_model.dart';
import 'package:e_shop/provider/auth_provider.dart';
import 'package:e_shop/provider/page_provider.dart';
import 'package:e_shop/provider/product_provider.dart';
import 'package:e_shop/provider/settings_provider.dart';
import 'package:e_shop/theme/theme.dart';
import 'package:e_shop/ui/product/detail_item.dart';
import 'package:flutter/material.dart';
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
  List<int> text = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  final List<String> imgList = [
    "https://picsum.photos/id/100/1920/1080",
    "https://picsum.photos/id/101/1920/1080",
    "https://picsum.photos/id/102/1920/1080",
    "https://picsum.photos/id/103/1920/1080",
    "https://picsum.photos/id/104/1920/1080",
    "https://picsum.photos/id/109/1920/1080",
    "https://picsum.photos/id/106/1920/1080",
    "https://picsum.photos/id/107/1920/1080",
    "https://picsum.photos/id/108/1920/1080"
  ];
  int carouselIndex = 0;

  // Location Coordinate
  late LocationPermission permission;
  String _latitude = '';
  String _longitude = '';

  @override
  void initState() {
    super.initState();

    // Get LatLong
    _getLocation();

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    // Get Profile
    Future.delayed(Duration.zero, () async {
      // Get data from SharedPref
      var data = await authProvider.getLoginData();

      // Check Latest Profil
      if (data?.token != null) {
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
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    ProductProvider productProvider = Provider.of<ProductProvider>(context);
    PageProvider pageProvider = Provider.of(context);

    UserModel loginData = authProvider.user;

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 10),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    pageProvider.currentIndex = 1;
                  });
                },
                child: Icon(
                  Icons.view_list,
                  size: 30,
                  color: backgroundColor3,
                ),
              ),
              Column(
                children: [
                  Text(
                    loginData.data.namaLengkap.toString(),
                    style: poppins.copyWith(
                        color: backgroundColor1, fontWeight: semiBold),
                  ),
                  Text(
                    loginData.data.alamat.toString(),
                    style: poppins.copyWith(
                        color: backgroundColor2, fontWeight: medium),
                  )
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/profile');
                },
                child: Icon(
                  SolarIconsBold.user,
                  size: 30,
                  color: backgroundColor3,
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: [
                CarouselSlider(
                  items: [
                    for (var sliderItem in imgList)
                      FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: sliderItem,
                        fit: BoxFit.cover,
                        imageErrorBuilder: (BuildContext context, Object error,
                            StackTrace? stackTrace) {
                          return Container(
                            color: Colors.grey,
                            child: const Center(
                              child: Icon(Icons.error),
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
                    autoPlayInterval: const Duration(seconds: 5),
                    initialPage: carouselIndex,
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (index, reason) {
                      setState(() {
                        carouselIndex = index;
                      });
                    },
                  ),
                ),
                Positioned(
                  bottom: 5,
                  left: 0,
                  right: 0,
                  child: DotsIndicator(
                    dotsCount: imgList.length,
                    position: carouselIndex,
                    decorator: DotsDecorator(
                      color: Colors.black38, // Inactive color
                      activeColor: backgroundColor2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        CardSectionHorizontal(
          text: text,
          headerText: "Promo",
          productItem: productProvider.promoProduct,
        ),
        CardSectionHorizontal(
          text: text,
          headerText: "Diskon",
          productItem: productProvider.promoProduct,
        ),
        CardSectionVertical(
          text: text,
          headerText: "Produk terlaku",
          productItem: productProvider.promoProduct,
        ),
      ],
    );
  }
}

class CardSectionHorizontal extends StatelessWidget {
  final List<int> text;
  final String headerText;
  final ProductModel.PromoProductModel? productItem;
  const CardSectionHorizontal({
    super.key,
    required this.text,
    required this.headerText,
    required this.productItem,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                headerText,
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
                  if (productItem?.data != null)
                    for (var i in productItem!.data!)
                      DynamicCardHorizontal(
                        data: i,
                        isDiscount: i.diskon != 0,
                      )
                  else
                    SizedBox(),
                ],
              ),
            ),
          ],
        ));
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
                    imageUrl: data.gambar1.toString(),
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
                image: data.gambar1.toString(),
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
                          " Cabang ${settingsProvider.storeLocation.data?.first.namaCabang}",
                          style: poppins.copyWith(
                            fontSize: 12,
                            fontWeight: semiBold,
                            color: backgroundColor2,
                          ),
                        ),
                      ],
                    )
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
  final List<int> text;
  final String headerText;
  final ProductModel.PromoProductModel? productItem;
  const CardSectionVertical(
      {super.key,
      required this.text,
      required this.productItem,
      required this.headerText});

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
                  isDiscount: i.diskon != 0,
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
                    imageUrl: data.gambar1.toString(),
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
                  image: data.gambar1.toString(),
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.location_city,
                          color: Colors.orange,
                          size: 12,
                        ),
                        Text(
                          " Cabang ${settingsProvider.storeLocation.data?.first.namaCabang}",
                          style: poppins.copyWith(
                            fontSize: 12,
                            fontWeight: semiBold,
                            color: backgroundColor2,
                          ),
                        ),
                      ],
                    )
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
