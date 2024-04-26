import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_shop/main.dart';
import 'package:e_shop/provider/auth_provider.dart';
import 'package:e_shop/provider/cart_provider.dart';
import 'package:e_shop/provider/page_provider.dart';
import 'package:e_shop/provider/product_provider.dart';
import 'package:e_shop/provider/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../theme/theme.dart';

class DetailItem extends StatefulWidget {
  final String? imageUrl;
  final String id;
  const DetailItem({super.key, required this.imageUrl, required this.id});

  @override
  State<DetailItem> createState() => _DetailItemState();
}

class _DetailItemState extends State<DetailItem> {
  double headerAlpha = 0.0;
  int carouselIndex = 0;
  bool isLoading = false;
  final List<String> imgList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (context.mounted) {
      setState(() {
        isLoading = true;
      });
    }

    print("ImageUrl : ${widget.imageUrl}");

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);

    Future.delayed(Duration.zero, () async {
      // Get data from SharedPref
      var data = await authProvider.getLoginData();

      if (data?.token != null) {
        // Check Detail Product
        if (await productProvider.getDetailProduct(
            id: widget.id,
            token: data!.token.toString(),
            cabang: settingsProvider.storeLocation.data!.first.namaCabang
                .toString())) {
          imgList.addAll(
              productProvider.detailProduct?.data!.gambar?.toList() ?? []);
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                backgroundColor: Colors.red,
                content: Text(
                  'Gagal Mendapatkan Detail Produk!',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
        }

        if (await productProvider.getCategoryProduct(
            bearerToken: data.token.toString())) {
          if (context.mounted) {
            setState(() {});
          }
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                backgroundColor: Colors.red,
                content: Text(
                  'Gagal Mendapatkan Kategori Produk!',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
        }
      }

      if (context.mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });


  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    CartProvider cartProduct = Provider.of<CartProvider>(context);
    PageProvider pageProvider = Provider.of<PageProvider>(context);
    ProductProvider productProvider = Provider.of<ProductProvider>(context);
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      body: SafeArea(
        top: true,
        left: true,
        right: true,
        bottom: true,
        child: isLoading == false
            ? Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        NotificationListener<ScrollUpdateNotification>(
                          onNotification: (ScrollNotification scrollInfo) {
                            if (scrollInfo.metrics.axis == Axis.vertical &&
                                context.mounted) {
                              setState(() {
                                double newAlpha = 0.0 +
                                    (scrollInfo.metrics.pixels /
                                        scrollInfo.metrics.maxScrollExtent);
                                print("MASUK $newAlpha");
                                // print("MASUK ${}");
                                print(
                                    "MASUK ${scrollInfo.metrics.pixels / scrollInfo.metrics.maxScrollExtent}");
                                if (newAlpha > 0.0) {
                                  headerAlpha = 1;
                                } else {
                                  headerAlpha = 0;
                                }
                              });
                            }

                            return false;
                          },
                          child: ListView(
                            children: [
                              CarouselSlider(
                                items: [
                                  for (var sliderItem in imgList)
                                    FadeInImage.memoryNetwork(
                                      placeholder: kTransparentImage,
                                      image: sliderItem,
                                      fit: BoxFit.cover,
                                      imageErrorBuilder: (BuildContext context,
                                          Object error,
                                          StackTrace? stackTrace) {
                                        return Container(
                                          color: Colors.white,
                                          child: const Center(
                                            child: Icon(Icons.error),
                                          ),
                                        );
                                      },
                                    ),
                                ],
                                options: CarouselOptions(
                                  viewportFraction: 1,
                                  autoPlay: false,
                                  autoPlayCurve: Curves.linear,
                                  reverse: false,
                                  autoPlayInterval: const Duration(seconds: 5),
                                  initialPage: carouselIndex,
                                  scrollDirection: Axis.horizontal,
                                  enableInfiniteScroll: false,
                                  onPageChanged: (index, reason) {
                                    if (context.mounted) {
                                      setState(() {
                                        carouselIndex = index;
                                      });
                                    }
                                  },
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: backgroundColor3,
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                        " ${carouselIndex + 1}/${imgList.length}",
                                        style: poppins.copyWith(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                    top: 30, left: 30, right: 30),
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(30))),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Rp. ${productProvider.detailProduct?.data?.harga?.first.diskon != 0 ? productProvider.detailProduct?.data?.harga?.first.hargaDiskon : productProvider.detailProduct?.data?.harga?.first.harga}",
                                      style: poppins.copyWith(
                                        fontWeight: semiBold,
                                        color: backgroundColor1,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        // Harga Sebeum Diskon
                                        if (productProvider.detailProduct?.data
                                                ?.harga?.first.diskon !=
                                            null)
                                          Flexible(
                                            child: Text(
                                              "Rp.${productProvider.detailProduct?.data?.harga?.first.harga}",
                                              maxLines: 1,
                                              style: poppins.copyWith(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontSize: 14,
                                                  color: Colors.grey,
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                            ),
                                          ),

                                        // Diskon
                                        if (productProvider.detailProduct?.data
                                                ?.harga?.first.diskon !=
                                            null)
                                          Text(
                                            " ${productProvider.detailProduct?.data?.harga?.first.diskon}%",
                                            style: poppins.copyWith(
                                                fontSize: 12,
                                                color: Colors.red,
                                                fontWeight: bold),
                                          ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
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
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        "${productProvider.detailProduct?.data?.namaProduk}",
                                        style: poppins.copyWith(
                                          fontWeight: bold,
                                          fontSize: 18,
                                          color: backgroundColor1,
                                        ),
                                        textAlign: TextAlign.justify,
                                      ),
                                    ),
                                    ReadMoreText(
                                      productProvider.detailProduct?.data
                                                  ?.deskripsiProduk ==
                                              null
                                          ? "Deskripsi Tidak Tersedia"
                                          : "${productProvider.detailProduct?.data?.deskripsiProduk}",
                                      style: poppins.copyWith(
                                        fontWeight: regular,
                                        fontSize: 14,
                                        color: productProvider.detailProduct
                                                    ?.data?.deskripsiProduk ==
                                                null
                                            ? Colors.grey
                                            : Colors.black,
                                      ),
                                      trimLines: 3,
                                      colorClickableText: Colors.grey,
                                      trimMode: TrimMode.Line,
                                      trimCollapsedText: ' Show more',
                                      trimExpandedText: ' Show less ',
                                      textAlign: TextAlign.justify,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 20, bottom: 10),
                                      child: Text(
                                        "Detail produk",
                                        style: poppins.copyWith(
                                            fontWeight: semiBold,
                                            color: backgroundColor1,
                                            fontSize: 18),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Merk",
                                          style: poppins.copyWith(
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          "${productProvider.detailProduct?.data?.merkProduk.toString()}",
                                          style: poppins.copyWith(
                                            color: backgroundColor1,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Divider(
                                        height: 1,
                                        thickness: 1,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Satuan",
                                          style: poppins.copyWith(
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          "${productProvider.detailProduct?.data?.satuanProduk.toString()}",
                                          style: poppins.copyWith(
                                            color: backgroundColor1,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Divider(
                                        height: 1,
                                        thickness: 1,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Golongan",
                                          style: poppins.copyWith(
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          "${productProvider.detailProduct?.data?.golonganProduk.toString()}",
                                          style: poppins.copyWith(
                                            color: backgroundColor1,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: Divider(
                                        height: 1,
                                        thickness: 1,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Stok",
                                          style: poppins.copyWith(
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          "${productProvider.detailProduct?.data?.golonganProduk.toString()}",
                                          style: poppins.copyWith(
                                            color: backgroundColor1,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: Divider(
                                        height: 1,
                                        thickness: 1,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 100),
                          padding: (headerAlpha > 0.0)
                              ? const EdgeInsets.symmetric(horizontal: 10)
                              : const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                          color: Colors.white
                              .withAlpha((headerAlpha * 255).round()),
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (context.mounted) {
                                    setState(() {
                                      Navigator.pop(context);
                                    });
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.arrow_back,
                                    size: 30,
                                    color: backgroundColor1,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Some code to undo the change.
                                  if (context.mounted) {
                                    Navigator.pushNamed(context, '/cart');
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.shopping_cart,
                                    size: 30,
                                    color: backgroundColor1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Center(
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            var data = {
                              "cabang_id":
                                  authProvider.user.data.cabangId?.toInt(),
                              "produk_id": int.tryParse(widget.id),
                            };

                            var message = await cartProduct.addCart(
                              data: data,
                              token: authProvider.user.token.toString(),
                            );

                            if (message != "") {
                              showToast("Gagal Menambahkan Barang");
                            } else {
                              final snackBar = SnackBar(
                                backgroundColor: backgroundColor1,
                                showCloseIcon: true,
                                content: const Text(
                                    'Berhasil menambahkan item ke keranjang!'),
                                duration: const Duration(seconds: 1),
                                action: SnackBarAction(
                                  label: 'Menuju Keranjang',
                                  textColor: Colors.white,
                                  backgroundColor: backgroundColor2,
                                  onPressed: () {
                                    if (context.mounted) {
                                      Navigator.pushNamed(context, '/cart');
                                    }
                                  },
                                ),
                              );

                              // Find the ScaffoldMessenger in the widget tree
                              // and use it to show a SnackBar.
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              shape: StadiumBorder(
                                  side: BorderSide(
                                      width: 1, color: backgroundColor3)),
                              backgroundColor: backgroundColor1),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.shopping_cart,
                                color: Colors.white,
                              ),
                              Text(
                                ' Tambahkan ke keranjang',
                                style: poppins.copyWith(
                                    fontWeight: semiBold, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Container(
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
      ),
    );
  }

  void showToast(String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
