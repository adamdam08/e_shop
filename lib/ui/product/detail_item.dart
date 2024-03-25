import 'package:e_shop/main.dart';
import 'package:e_shop/provider/auth_provider.dart';
import 'package:e_shop/provider/cart_provider.dart';
import 'package:e_shop/provider/page_provider.dart';
import 'package:e_shop/provider/product_provider.dart';
import 'package:e_shop/provider/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

import '../../theme/theme.dart';

class DetailItem extends StatefulWidget {
  final String imageUrl;
  final String id;
  const DetailItem({super.key, required this.imageUrl, required this.id});

  @override
  State<DetailItem> createState() => _DetailItemState();
}

class _DetailItemState extends State<DetailItem> {
  double headerAlpha = 0.0;

  bool isLoading = false;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      isLoading = false;
    });

    print("ImageUrl : ${widget.imageUrl}");

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);

    Future.delayed(Duration.zero, () async {
      setState(() {
        isLoading = true;
      });

      // Get data from SharedPref
      var data = await authProvider.getLoginData();

      if (data?.token != null) {
        // Check Detail Product
        if (await productProvider.getDetailProduct(
            id: widget.id,
            token: data!.token.toString(),
            cabang: settingsProvider.storeLocation.data!.first.namaCabang
                .toString())) {
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

      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
        child: isLoading == false ? Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  NotificationListener<ScrollUpdateNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
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
                      return false;
                    },
                    child: ListView(
                      children: [
                        Stack(
                          children: [
                            Image.network(
                              widget.imageUrl,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 400,
                                  width: double.infinity,
                                  color: Colors.grey,
                                  child: const Center(
                                    child: Icon(Icons.error),
                                  ),
                                );
                              },
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                  top: 30, left: 30, right: 30),
                              margin: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.width * 0.8),
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
                                    "Rp. ${productProvider.detailProduct?.data!.harga!.first.diskon != 0 ? productProvider.detailProduct?.data!.harga!.first.hargaDiskon : productProvider.detailProduct!.data!.harga!.first.harga}",
                                    style: poppins.copyWith(
                                      fontWeight: semiBold,
                                      color: backgroundColor1,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      // Harga Sebeum Diskon
                                      if (productProvider.detailProduct!.data!
                                              .harga!.first.diskon !=
                                          0)
                                        Flexible(
                                          child: Text(
                                            "Rp.${productProvider.detailProduct!.data!.harga!.first.harga}",
                                            maxLines: 1,
                                            style: poppins.copyWith(
                                                overflow: TextOverflow.ellipsis,
                                                fontSize: 14,
                                                color: Colors.grey,
                                                decoration:
                                                    TextDecoration.lineThrough),
                                          ),
                                        ),

                                      // Diskon
                                      if (productProvider.detailProduct!.data!
                                              .harga!.first.diskon !=
                                          0)
                                        Text(
                                          " ${productProvider.detailProduct!.data!.harga!.first.diskon}%",
                                          style: poppins.copyWith(
                                              fontSize: 12,
                                              color: Colors.red,
                                              fontWeight: bold),
                                        ),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
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
                                      productProvider
                                          .detailProduct!.data!.namaProduk
                                          .toString(),
                                      style: poppins.copyWith(
                                        fontWeight: bold,
                                        fontSize: 18,
                                        color: backgroundColor1,
                                      ),
                                      textAlign: TextAlign.justify,
                                    ),
                                  ),
                                  ReadMoreText(
                                    productProvider
                                        .detailProduct!.data!.deskripsiProduk
                                        .toString(),
                                    style: poppins.copyWith(
                                      fontWeight: regular,
                                      fontSize: 14,
                                      color: Colors.black,
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
                                        "Kondisi",
                                        style: poppins.copyWith(
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        "Data",
                                        style: poppins.copyWith(
                                          color: backgroundColor1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
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
                                        "Minimal pembelian",
                                        style: poppins.copyWith(
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        "Data",
                                        style: poppins.copyWith(
                                          color: backgroundColor1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
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
                                        "Kategori",
                                        style: poppins.copyWith(
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        "Data",
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
                      ],
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    padding: (headerAlpha > 0.0)
                        ? const EdgeInsets.symmetric(horizontal: 10)
                        : const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                    color: Colors.white.withAlpha((headerAlpha * 255).round()),
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              Navigator.pop(context);
                            });
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
                            setState(() {
                              pageProvider.currentIndex = 4;
                            });
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const BottomNavigationBarExample()),
                                (route) => false);
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
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Center(
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        Map<dynamic, dynamic> myProducts = cartProduct
                            .myProducts
                            .firstWhere((element) => element["id"] == widget.id,
                                orElse: () => {});

                        if (myProducts.isEmpty) {
                          print(
                              "image : ${productProvider.detailProduct!.data!.gambar1}");
                          cartProduct.myProducts.add({
                            "id": widget.id,
                            "img": widget.imageUrl,
                            "name":
                                productProvider.detailProduct!.data!.namaProduk,
                            "price": productProvider.detailProduct!.data!.harga!
                                        .first.diskon !=
                                    0
                                ? productProvider.detailProduct!.data!.harga!
                                    .first.hargaDiskon
                                : productProvider
                                    .detailProduct!.data!.harga!.first.harga,
                            "amount": 1
                          });
                        } else {
                          myProducts["amount"] = myProducts["amount"] += 1;
                        }
                      });
                      final snackBar = SnackBar(
                        content: const Text(
                            'Berhasil menambahkan item ke keranjang!'),
                        duration: const Duration(seconds: 1),
                        action: SnackBarAction(
                          label: 'Menuju Keranjang',
                          onPressed: () {
                            // Some code to undo the change.
                            setState(() {
                              pageProvider.currentIndex = 4;
                            });
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const BottomNavigationBarExample()),
                                (route) => false);
                          },
                        ),
                      );

                      // Find the ScaffoldMessenger in the widget tree
                      // and use it to show a SnackBar.
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(
                            side:
                                BorderSide(width: 1, color: backgroundColor3)),
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
        ) : Container(
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
}
