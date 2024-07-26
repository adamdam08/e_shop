import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_shop/provider/auth_provider.dart';
import 'package:e_shop/provider/cart_provider.dart';
import 'package:e_shop/provider/page_provider.dart';
import 'package:e_shop/provider/product_provider.dart';
import 'package:e_shop/provider/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:solar_icons/solar_icons.dart';
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
  int totalCart = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getDetailItem();

    _getTotalCart();
  }

  // Load Banner
  void _getDetailItem() async {
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
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    CartProvider cartProduct = Provider.of<CartProvider>(context);
    PageProvider pageProvider = Provider.of<PageProvider>(context);
    ProductProvider productProvider = Provider.of<ProductProvider>(context);
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);

    Widget showMultiSatuan(
        int index, String? multisatuanUnit, String? multisatuanJumlah, List<dynamic>? jumlahMultisatuan,) {
      var multisatuanList = multisatuanUnit!.split("/");
      var multisatuanJumlahList = multisatuanJumlah!.split("/");
      var jumlahItemSelected = [];

      for (var i = 0; i < multisatuanJumlahList.length; i++) {
        jumlahItemSelected.add(0);
      }

      if(jumlahMultisatuan != null){
        jumlahItemSelected = jumlahMultisatuan;
      }

      bool isLoading = false;

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        color: Colors.white,
        child: StatefulBuilder(
            builder: (BuildContext context, StateSetter stateSetter) {
          TextEditingController descriptionTextController =
              TextEditingController();

          CartProvider cartProduct = Provider.of<CartProvider>(context);
          print("Catatan : ${descriptionTextController.text}");
          // print("Total Item : ${totalItem}");

          descriptionTextController.text = cartProduct.cartNote;
          descriptionTextController.selection = TextSelection.collapsed(
              offset: descriptionTextController.text.length);

          return KeyboardVisibilityBuilder(
              builder: (context, isKeyboardVisible) {
            // Keyboard Dismiss
            if (isKeyboardVisible == false) {
              Future.delayed(Duration.zero, () async {
                cartProduct.cartUpdate = parameterCart(
                    note: descriptionTextController.text, total: 0);
              });
            }

            return ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Pilih Satuan",
                        style: poppins.copyWith(
                            fontSize: 18,
                            fontWeight: semiBold,
                            color: backgroundColor1),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      for (var i = 0;
                          i < multisatuanJumlahList.length;
                          i++) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${multisatuanList[i]} (${multisatuanJumlahList[i]} Pcs)",
                              style: poppins.copyWith(
                                  fontSize: 14,
                                  fontWeight: regular,
                                  color: backgroundColor1),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ClipOval(
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      color: backgroundColor2,
                                    ),
                                    child: InkWell(
                                      onTap: () async {
                                        if (jumlahItemSelected[i] >= 1) {
                                          stateSetter(() {
                                            jumlahItemSelected[i] -= 1;
                                          });
                                          print(
                                              "${multisatuanList[i]} : ${jumlahItemSelected[i]}");
                                        }
                                      },
                                      child: const Icon(
                                        Icons.remove,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Text(
                                    jumlahItemSelected[i].toString(),
                                    style: poppins.copyWith(
                                        fontWeight: bold,
                                        color: backgroundColor3,
                                        overflow: TextOverflow.ellipsis),
                                    maxLines: 2,
                                  ),
                                ),
                                ClipOval(
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      color: backgroundColor3,
                                    ),
                                    child: InkWell(
                                      onTap: () async {
                                        var jumlahTemp = 0;

                                        for (var x = 0;
                                            x < jumlahItemSelected.length;
                                            x++) {
                                          if (i == x) {
                                            var total = ((jumlahItemSelected[x]
                                                    as int?)! +
                                                1);
                                            jumlahTemp += (total *
                                                int.parse(
                                                    multisatuanJumlahList[x]));
                                          } else {
                                            var total = ((jumlahItemSelected[x]
                                                as int?)!);
                                            jumlahTemp += (total *
                                                int.parse(
                                                    multisatuanJumlahList[x]));
                                          }
                                        }

                                        var stok = int.parse(productProvider
                                            .detailProduct!
                                            .data!
                                            .stok!
                                            .first
                                            .stok
                                            .toString());

                                        print(
                                            "Stok Total: ${jumlahTemp} ${stok}");

                                        stateSetter(() {
                                          if (jumlahTemp <= (stok)) {
                                            jumlahItemSelected[i] += 1;
                                          } else {
                                            showToast(
                                                "Melebihi batas stok tersedia");
                                          }
                                        });
                                      },
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                      if (isLoading) ...[
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              shape: StadiumBorder(
                                side: BorderSide(
                                    width: 1, color: backgroundColor3),
                              ),
                              backgroundColor: backgroundColor1),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              isLoading
                                  ? Container(
                                      width: 15,
                                      height: 15,
                                      margin: const EdgeInsets.only(
                                          top: 10, bottom: 10),
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ] else ...[
                        ElevatedButton(
                          onPressed: () async {
                            stateSetter(() {
                              isLoading = true;
                            });

                            if( (jumlahItemSelected.reduce((a, b) => a + b)) == 0){
                              if(productProvider.detailProduct!.data!.keranjang != null){
                                var message = await cartProduct.deleteCart(
                                    cuid: "${productProvider.detailProduct!.data!.keranjang?.sId}",
                                    token:authProvider.user.token.toString());
                                if (message != "") {
                                  showToast(message);
                                } else {
                                  showToast("Menghapus item dari keranjang");
                                }
                              }
                            }else{
                              var checkJumlah =
                              jumlahItemSelected.reduce((a, b) => a + b);
                              if (checkJumlah != 0) {
                                var data = {
                                  "cabang_id":
                                  authProvider.user.data.cabangId?.toInt(),
                                  "produk_id": int.tryParse(widget.id),
                                  "multisatuan_jumlah": multisatuanJumlahList,
                                  "multisatuan_unit": multisatuanList,
                                  "jumlah_multisatuan": jumlahItemSelected
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
                              } else {
                                showToast("Barang belum terpilih");
                              }

                              stateSetter(() {
                                isLoading = false;
                              });
                            }

                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                              shape: StadiumBorder(
                                side: BorderSide(
                                    width: 1, color: ((jumlahItemSelected
                                    .reduce((a, b) => a + b)) ==
                                    0) && productProvider.detailProduct!.data!.keranjang != null
                                    ? Colors.red
                                    : backgroundColor3),
                              ),
                              backgroundColor: ((jumlahItemSelected
                                  .reduce((a, b) => a + b)) ==
                                  0) && productProvider.detailProduct!.data!.keranjang != null
                                  ? Colors.red
                                  : backgroundColor1),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                ((jumlahItemSelected
                                    .reduce((a, b) => a + b)) ==
                                    0) && productProvider.detailProduct!.data!.keranjang != null
                                    ? Icons.delete
                                    : Icons.shopping_cart,
                                color: Colors.white,
                              ),
                              Text(
                                ((jumlahItemSelected
                                    .reduce((a, b) => a + b)) ==
                                    0) && productProvider.detailProduct!.data!.keranjang != null
                                    ? ' Hapus dari keranjang'
                                    : ' Tambahkan ke keranjang',
                                style: poppins.copyWith(
                                    fontWeight: semiBold, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            );
          });
        }),
      );
    }

    Widget showSatuan(int? jumlah) {
      var jumlahItemSelected = 0;
      bool isLoading = false;

      // Check Jumlah
      if(jumlah != null && jumlah != 0){
        jumlahItemSelected = jumlah;
      }

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        color: Colors.white,
        child: StatefulBuilder(
            builder: (BuildContext context, StateSetter stateSetter) {
          TextEditingController descriptionTextController =
              TextEditingController();

          CartProvider cartProduct = Provider.of<CartProvider>(context);
          print("Catatan : ${descriptionTextController.text}");
          // print("Total Item : ${totalItem}");

          descriptionTextController.text = cartProduct.cartNote;
          descriptionTextController.selection = TextSelection.collapsed(
              offset: descriptionTextController.text.length);

          return KeyboardVisibilityBuilder(
              builder: (context, isKeyboardVisible) {
            // Keyboard Dismiss
            if (isKeyboardVisible == false) {
              Future.delayed(Duration.zero, () async {
                cartProduct.cartUpdate = parameterCart(
                    note: descriptionTextController.text, total: 0);
              });
            }

            return ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Pilih Satuan",
                        style: poppins.copyWith(
                            fontSize: 18,
                            fontWeight: semiBold,
                            color: backgroundColor1),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${productProvider.detailProduct!.data!.satuanProduk}",
                            style: poppins.copyWith(
                                fontSize: 14,
                                fontWeight: regular,
                                color: backgroundColor1),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipOval(
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    color: backgroundColor2,
                                  ),
                                  child: InkWell(
                                    onTap: () async {
                                      if (jumlahItemSelected >= 1) {
                                        stateSetter(() {
                                          jumlahItemSelected -= 1;
                                        });
                                        print("$jumlahItemSelected");
                                      }
                                    },
                                    child: const Icon(
                                      Icons.remove,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Text(
                                  jumlahItemSelected.toString(),
                                  style: poppins.copyWith(
                                      fontWeight: bold,
                                      color: backgroundColor3,
                                      overflow: TextOverflow.ellipsis),
                                  maxLines: 2,
                                ),
                              ),
                              ClipOval(
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    color: backgroundColor3,
                                  ),
                                  child: InkWell(
                                    onTap: () async {
                                      var stok = int.parse(productProvider
                                          .detailProduct!.data!.stok!.first.stok
                                          .toString());

                                      print(
                                          "Stok Total: $jumlahItemSelected $stok");

                                      stateSetter(() {
                                        if ((jumlahItemSelected + 1) <=
                                            (stok)) {
                                          jumlahItemSelected += 1;
                                        } else {
                                          showToast(
                                              "Melebihi batas stok tersedia");
                                        }
                                      });
                                    },
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      // Text(
                      //   "* Stok Tersedia : ${productProvider.detailProduct!.data!}",
                      //   style: poppins.copyWith(
                      //       fontSize: 14, fontWeight: thin, color: Colors.red),
                      // ),
                      if (isLoading) ...[
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              shape: StadiumBorder(
                                side: BorderSide(
                                    width: 1, color: backgroundColor3),
                              ),
                              backgroundColor: backgroundColor1),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              isLoading
                                  ? Container(
                                      width: 15,
                                      height: 15,
                                      margin: const EdgeInsets.only(
                                          top: 10, bottom: 10),
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ] else ...[
                        ElevatedButton(
                          onPressed: () async {
                            stateSetter(() {
                              isLoading = true;
                            });

                            if (jumlahItemSelected != 0) {
                              var data = {
                                "cabang_id":
                                    authProvider.user.data.cabangId?.toInt(),
                                "produk_id": int.tryParse(widget.id),
                                "jumlah": jumlahItemSelected
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
                            } else {
                              if(productProvider.detailProduct!.data!.keranjang != null){
                                var message = await cartProduct.deleteCart(
                                    cuid: "${productProvider.detailProduct!.data!.keranjang?.sId}",
                                    token:authProvider.user.token.toString());
                                if (message != "") {
                                  showToast(message);
                                } else {
                                  showToast("Menghapus item dari keranjang");
                                }
                              }
                            }
                            stateSetter(() {
                              isLoading = false;
                            });

                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                              shape: StadiumBorder(
                                side: BorderSide(
                                    width: 1, color: ((jumlahItemSelected) == 0 && productProvider.detailProduct!.data!.keranjang != null) ? Colors.red :backgroundColor1),
                              ),
                              backgroundColor:  ((jumlahItemSelected) == 0 && productProvider.detailProduct!.data!.keranjang != null) ? Colors.red :backgroundColor1),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                               Icon(
                                 ((jumlahItemSelected) == 0 && productProvider.detailProduct!.data!.keranjang != null)
                                    ? Icons.delete
                                    : Icons.shopping_cart,
                                color: Colors.white,
                              ),
                              Text(
                                ((jumlahItemSelected) == 0 && productProvider.detailProduct!.data!.keranjang != null) ? ' Hapus dari keranjang' :' Tambahkan ke keranjang',
                                style: poppins.copyWith(
                                    fontWeight: semiBold, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            );
          });
        }),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          top: true,
          left: true,
          right: true,
          bottom: true,
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                color: Colors.white,
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
                        child: Stack(
                          children: <Widget>[
                            Icon(
                              SolarIconsBold.cartLarge,
                              size: 30,
                              color: backgroundColor1,
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
                                    '$totalCart',
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
                    ),
                  ],
                ),
              ),
              isLoading
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
                  : Expanded(
                      child: Stack(
                        children: [
                          ListView(
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
                                color: Colors.white,
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
                                padding: const EdgeInsets.only(top: 30),
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(30))),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
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
                                          Text(
                                            "Rp. ${productProvider.detailProduct?.data?.harga?.first.diskon != 0 ? productProvider.detailProduct?.data?.harga?.first.hargaDiskon : productProvider.detailProduct?.data?.harga?.first.harga}",
                                            style: poppins.copyWith(
                                              fontWeight: semiBold,
                                              color: Colors.red,
                                              fontSize: 18,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              // Harga Sebeum Diskon
                                              if (productProvider
                                                      .detailProduct
                                                      ?.data
                                                      ?.harga
                                                      ?.first
                                                      .diskon !=
                                                  null)
                                                Flexible(
                                                  child: Text(
                                                    "Rp.${productProvider.detailProduct?.data?.harga?.first.harga}",
                                                    maxLines: 1,
                                                    style: poppins.copyWith(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontSize: 12,
                                                        color: Colors.grey,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough),
                                                  ),
                                                ),

                                              // Diskon
                                              if (productProvider
                                                      .detailProduct
                                                      ?.data
                                                      ?.harga
                                                      ?.first
                                                      .diskon !=
                                                  null) ...[
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 5,
                                                      vertical: 3),
                                                  decoration: BoxDecoration(
                                                      color: Colors.red
                                                          .withOpacity(0.4),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.pink
                                                                .withOpacity(
                                                                    0.2),
                                                            blurRadius: 4,
                                                            offset:
                                                                const Offset(
                                                                    0, 0))
                                                      ]),
                                                  child: Text(
                                                    "${productProvider.detailProduct?.data?.harga?.first.diskon}%",
                                                    style: poppins.copyWith(
                                                        fontSize: 12,
                                                        color: Colors.pink,
                                                        fontWeight: bold),
                                                  ),
                                                ),
                                              ]
                                            ],
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.star,
                                                size: 20,
                                                color: Colors.yellow,
                                              ),
                                              Text(
                                                "${productProvider.detailProduct?.data?.rating}",
                                                style: poppins.copyWith(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontWeight: regular),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Divider(
                                        height: 1,
                                        thickness: 1,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10, bottom: 10),
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
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    "Merk",
                                                    style: poppins.copyWith(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Satuan",
                                                    style: poppins.copyWith(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Kategori",
                                                    style: poppins.copyWith(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                width: 30,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${productProvider.detailProduct?.data?.merkProduk.toString()}",
                                                    style: poppins.copyWith(
                                                      color: backgroundColor1,
                                                    ),
                                                  ),
                                                  Text(
                                                    productProvider
                                                                .detailProduct
                                                                ?.data
                                                                ?.multisatuanUnit !=
                                                            null
                                                        ? "${productProvider.detailProduct?.data?.multisatuanUnit.toString()}"
                                                        : "${productProvider.detailProduct?.data?.satuanProduk.toString()}",
                                                    style: poppins.copyWith(
                                                      color: backgroundColor1,
                                                    ),
                                                  ),
                                                  Text(
                                                    "${productProvider.detailProduct?.data?.kat1.toString()} \n${productProvider.detailProduct?.data?.kat2.toString()} \n${productProvider.detailProduct?.data?.kat3.toString()}",
                                                    style: poppins.copyWith(
                                                      color: backgroundColor1,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10),
                                            child: Text(
                                              "Deskripsi produk",
                                              style: poppins.copyWith(
                                                  fontWeight: semiBold,
                                                  color: backgroundColor1,
                                                  fontSize: 18),
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
                                              color: productProvider
                                                          .detailProduct
                                                          ?.data
                                                          ?.deskripsiProduk ==
                                                      null
                                                  ? Colors.grey
                                                  : Colors.black,
                                            ),
                                            trimLines: 3,
                                            colorClickableText:
                                                backgroundColor3,
                                            trimMode: TrimMode.Length,
                                            trimCollapsedText:
                                                ' Baca Selengkapnya',
                                            trimExpandedText:
                                                ' Tampilkan Lebih Sedikit ',
                                            textAlign: TextAlign.justify,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(top: 10),
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
              if (!isLoading) ...[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Center(
                    child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (productProvider
                                  .detailProduct!.data!.multisatuanJumlah !=
                              null) {
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20))),
                                backgroundColor: Colors.white,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                builder: (BuildContext context) {
                                  return Padding(
                                    padding: MediaQuery.of(context).viewInsets,
                                    child: showMultiSatuan(
                                        int.parse(widget.id),
                                        productProvider.detailProduct!.data!
                                            .multisatuanUnit,
                                        productProvider.detailProduct!.data!
                                            .multisatuanJumlah,
                                        productProvider.detailProduct!.data!.keranjang?.jumlahMultisatuan,),
                                  );
                                }).then((value) => setState(() async {
                                  _getDetailItem();
                                  _getTotalCart();
                                }));
                            // showToast("Multisatuan");
                          } else {
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20))),
                                backgroundColor: Colors.white,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                builder: (BuildContext context) {
                                  return Padding(
                                    padding: MediaQuery.of(context).viewInsets,
                                    child: showSatuan(productProvider.detailProduct!.data!.keranjang?.jumlah),
                                  );
                                }).then((value) => setState(() {
                                  _getDetailItem();
                                  _getTotalCart();
                                }));
                            // showToast("Multisatuan");
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
            ],
          )),
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
