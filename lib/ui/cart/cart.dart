import 'dart:ffi';

import 'package:e_shop/models/cart/cart_list_model.dart';
import 'package:e_shop/provider/auth_provider.dart';
import 'package:e_shop/provider/cart_provider.dart';
import 'package:e_shop/provider/customer_provider.dart';
import 'package:e_shop/provider/settings_provider.dart';
import 'package:e_shop/theme/theme.dart';
import 'package:e_shop/ui/cart/customer_search.dart';
import 'package:e_shop/ui/customer/add_customer_page.dart';
import 'package:e_shop/ui/product/detail_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class Cart extends StatefulWidget {
  final int index;
  const Cart({super.key, this.index = 0});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  String? selectedValue;
  final TextEditingController textEditingController = TextEditingController();
  bool _isLoading = false;

  // Is Selected
  bool? isSelected;

  @override
  void initState() {
    super.initState();

    _getCartList();
  }

  void _getCartList() async {
    setState(() {
      _isLoading = true;
    });

    setState(() {
      isSelected = true;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    if (await cartProvider.getCartList(
        token: authProvider.user.token.toString())) {
      if (mounted) {
        setState(() {});
        if (cartProvider.cartList.listData!.isNotEmpty) {
          print("${cartProvider.cartList.listData!.first.cartData!.length}");
        }
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    CartProvider cartProduct = Provider.of<CartProvider>(context);
    CustomerProvider customerProvider = Provider.of<CustomerProvider>(context);
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);

    int countItem = 0;
    int subTotal = 0;

    String selectedCustomer = "Pilih customer";

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
      } else {
        selectedCustomer = "Pilih customer";
      }
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

    Widget bottomSheetDialog(int index) {
      var satuan =
          (cartProduct.cartList.listData!.first.cartData![index].diskon != null
              ? cartProduct
                  .cartList.listData!.first.cartData![index].hargaDiskon
              : cartProduct.cartList.listData!.first.cartData![index].harga);
      var totalItem = cartProduct.cartTotal;
      subTotal = (satuan! * totalItem);

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
          print("Total Item : ${totalItem}");

          descriptionTextController.text = cartProduct.cartNote;
          descriptionTextController.selection = TextSelection.collapsed(
              offset: descriptionTextController.text.length);

          return KeyboardVisibilityBuilder(
              builder: (context, isKeyboardVisible) {
            // Keyboard Dismiss
            if (isKeyboardVisible == false) {
              Future.delayed(Duration.zero, () async {
                cartProduct.cartUpdate = parameterCart(
                    note: descriptionTextController.text,
                    total: totalItem ?? 0);
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
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(vertical: 10),
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              clipBehavior: Clip.antiAlias,
                              // borderRadius: BorderRadius.circular(8),
                              child: FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image:
                                    "http://103.127.132.116/uploads/images/${cartProduct.cartList.listData!.first.cartData![index].imageUrl.toString()}",
                                fit: BoxFit.cover,
                                height: 125,
                                width: 125,
                                imageErrorBuilder: (BuildContext context,
                                    Object error, StackTrace? stackTrace) {
                                  return Container(
                                    height: 125,
                                    width: 125,
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "${cartProduct.cartList.listData!.first.cartData![index].namaProduk}",
                                      style: poppins.copyWith(
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: semiBold,
                                          fontSize: 18,
                                          color: backgroundColor1),
                                      maxLines: 2,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      CurrencyFormat.convertToIdr(
                                              (cartProduct
                                                              .cartList
                                                              .listData!
                                                              .first
                                                              .cartData![index]
                                                              .diskon !=
                                                          0 ||
                                                      cartProduct
                                                              .cartList
                                                              .listData!
                                                              .first
                                                              .cartData![index]
                                                              .diskon !=
                                                          null)
                                                  ? cartProduct
                                                      .cartList
                                                      .listData!
                                                      .first
                                                      .cartData![index]
                                                      .hargaDiskon
                                                  : cartProduct
                                                      .cartList
                                                      .listData!
                                                      .first
                                                      .cartData![index]
                                                      .harga,
                                              2)
                                          .toString(),
                                      style: poppins.copyWith(
                                          fontWeight: regular,
                                          color: backgroundColor3,
                                          overflow: TextOverflow.ellipsis),
                                      maxLines: 2,
                                    ),
                                    if (cartProduct.cartList.listData!.first
                                            .cartData![index].diskon !=
                                        null) ...[
                                      Row(
                                        children: [
                                          Text(
                                            CurrencyFormat.convertToIdr(
                                                    cartProduct
                                                        .cartList
                                                        .listData!
                                                        .first
                                                        .cartData![index]
                                                        .harga,
                                                    2)
                                                .toString(),
                                            style: poppins.copyWith(
                                                overflow: TextOverflow.ellipsis,
                                                fontSize: 10,
                                                color: Colors.grey,
                                                decoration:
                                                    TextDecoration.lineThrough),
                                            maxLines: 2,
                                          ),
                                          Text(
                                            " ${cartProduct.cartList.listData!.first.cartData![index].diskon}%",
                                            style: poppins.copyWith(
                                                fontSize: 10,
                                                color: Colors.red,
                                                fontWeight: bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "Catatan pemesanan",
                        style: poppins.copyWith(
                            fontSize: 14,
                            fontWeight: semiBold,
                            color: backgroundColor1),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: descriptionTextController,
                        textInputAction: TextInputAction.newline,
                        obscureText: false,
                        keyboardType: TextInputType.multiline,
                        cursorColor: Colors.grey,
                        maxLines: null,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide:
                                BorderSide(color: Colors.white, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            borderSide:
                                BorderSide(color: backgroundColor3, width: 1),
                          ),
                          hintText: "Tambahkan Catatan Disini...",
                          hintStyle: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.normal),
                          alignLabelWithHint: true,
                        ),
                        onChanged: (value) => {
                          cartProduct.cartUpdate =
                              parameterCart(note: value, total: totalItem)
                        },
                      ),
                      const SizedBox(
                        height: 5,
                      ),
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
                            // Navigator.pop(context);
                            stateSetter(() {
                              isLoading = true;
                            });

                            final authProvider = Provider.of<AuthProvider>(
                                context,
                                listen: false);
                            // Get data from SharedPref
                            var data = await authProvider.getLoginData();

                            // Get Best Seller
                            if (data!.token != null) {
                              var message = await cartProduct.updateCart(
                                  cuid: cartProduct.cartList.listData!.first
                                      .cartData![index].sId
                                      .toString(),
                                  data: {
                                    "jumlah": cartProduct.cartTotal,
                                    "catatan": cartProduct.cartNote,
                                  },
                                  token: data.token.toString());

                              if (message != "") {
                                showToast(message);
                              } else {
                                showToast("Berhasil Memperbarui Pesanan");
                                if (context.mounted) {
                                  setState(() {
                                    print("Berhasil memperbarui");
                                    _getCartList();
                                  });
                                  Navigator.pop(context);
                                }
                              }
                            }

                            stateSetter(() {
                              isLoading = false;
                            });
                          },
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
                              const Icon(
                                Icons.refresh,
                                color: Colors.white,
                              ),
                              Text(
                                ' Perbarui Pesanan',
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

    Widget showMultiSatuan(
      int index,
      List<String>? multisatuanUnit,
      List<String>? multisatuanJumlah,
      List<int>? jumlahMultisatuan,
    ) {
      var multisatuanList = multisatuanUnit!;
      var multisatuanJumlahList = multisatuanJumlah!;
      var jumlahItemSelected = jumlahMultisatuan;

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
                                        if (jumlahItemSelected![i] >= 1) {
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
                                    jumlahItemSelected![i].toString(),
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

                                        var stok = int.parse(cartProduct
                                            .cartList
                                            .listData!
                                            .first
                                            .cartData![index]
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
                      Text(
                        "* Stok Tersedia : ${cartProduct.cartList.listData!.first.cartData![index].stok}",
                        style: poppins.copyWith(
                            fontSize: 14, fontWeight: thin, color: Colors.red),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
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

                            final authProvider = Provider.of<AuthProvider>(
                                context,
                                listen: false);
                            // Get data from SharedPref
                            var data = await authProvider.getLoginData();
                            var jumlah = cartProduct.cartList.listData!.first
                                .cartData![index].jumlah;

                            var stok = cartProduct
                                .cartList.listData!.first.cartData![index].stok;

                            print("Stok : ${stok}");
                            // && jumlah! < stok!

                            if (data!.token != null) {
                              print("Data : ${{
                                "jumlah": cartProduct.cartTotal + 1,
                                "catatan": cartProduct.cartNote,
                              }}");

                              var checkJumlah =
                                  jumlahItemSelected.reduce((a, b) => a + b);
                              print("Check Jumlah : ${checkJumlah}");
                              print("Check Jumlah : ${checkJumlah == 0}");
                              if (checkJumlah == 0) {
                                var message = await cartProduct.deleteCart(
                                    cuid: cartProduct.cartList.listData!.first
                                        .cartData![index].sId
                                        .toString(),
                                    token: data.token.toString());
                                if (message != "") {
                                  showToast(message);
                                } else {
                                  if (cartProduct.selectedProducts
                                      .where((element) =>
                                          element["id"].toString() ==
                                          cartProduct.cartList.listData!.first
                                              .cartData![index].produkId
                                              .toString())
                                      .isNotEmpty) {
                                    //Remove data
                                    cartProduct.selectedProducts.removeWhere(
                                        (element) =>
                                            element["id"].toString() ==
                                            cartProduct.cartList.listData!.first
                                                .cartData![index].produkId
                                                .toString());
                                  }
                                  setState(() {
                                    _getCartList();
                                  });
                                }
                              } else {
                                var message = await cartProduct.updateCart(
                                    cuid: cartProduct.cartList.listData!.first
                                        .cartData![index].sId
                                        .toString(),
                                    data: {
                                      "multisatuan_jumlah":
                                          multisatuanJumlahList,
                                      "multisatuan_unit": multisatuanList,
                                      "jumlah_multisatuan": jumlahItemSelected,
                                      "catatan": cartProduct.cartList.listData!
                                          .first.cartData![index].catatan,
                                    },
                                    token: data.token.toString());

                                if (message != "") {
                                  showToast(message);
                                } else {
                                  showToast("Berhasil Memperbarui Pesanan");
                                  setState(() {
                                    _getCartList();
                                  });
                                }
                              }

                              // Find the ScaffoldMessenger in the widget tree
                              // and use it to show a SnackBar.

                              stateSetter(() {
                                isLoading = false;
                              });

                              Navigator.pop(context);
                            } else {
                              stateSetter(() {
                                isLoading = false;
                              });
                              showToast("Melebihi batas stok tersedia : $stok");
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              shape: StadiumBorder(
                                side: BorderSide(
                                    width: 1,
                                    color: (jumlahItemSelected!
                                                .reduce((a, b) => a + b)) ==
                                            0
                                        ? Colors.red
                                        : backgroundColor3),
                              ),
                              backgroundColor: (jumlahItemSelected!
                                          .reduce((a, b) => a + b)) ==
                                      0
                                  ? Colors.red
                                  : backgroundColor1),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                (jumlahItemSelected!.reduce((a, b) => a + b)) ==
                                        0
                                    ? Icons.delete
                                    : Icons.shopping_cart,
                                color: Colors.white,
                              ),
                              Text(
                                (jumlahItemSelected.reduce((a, b) => a + b)) ==
                                        0
                                    ? ' Hapus dari keranjang'
                                    : ' Perbarui keranjang',
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

    Widget showSatuan(
      int index,
      CartData dataCart,
    ) {
      bool isLoading = false;
      var jumlahItemSelected = dataCart.jumlah ?? 0;

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
                            "${dataCart.satuanProduk}",
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
                                      var jumlahTemp = 0;
                                      var stok = int.parse(cartProduct.cartList
                                          .listData!.first.cartData![index].stok
                                          .toString());

                                      print(
                                          "Stok Total: ${jumlahTemp} ${stok}");

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
                      Text(
                        "* Stok Tersedia : ${cartProduct.cartList.listData!.first.cartData![index].stok}",
                        style: poppins.copyWith(
                            fontSize: 14, fontWeight: thin, color: Colors.red),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
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

                            final authProvider = Provider.of<AuthProvider>(
                                context,
                                listen: false);
                            // Get data from SharedPref
                            var data = await authProvider.getLoginData();
                            var jumlah = cartProduct.cartList.listData!.first
                                .cartData![index].jumlah;

                            var stok = cartProduct
                                .cartList.listData!.first.cartData![index].stok;

                            print("Stok : ${stok}");

                            if (data!.token != null) {
                              print("Data : ${{
                                "jumlah": cartProduct.cartTotal + 1,
                                "catatan": cartProduct.cartNote,
                              }}");

                              var checkJumlah = jumlahItemSelected;
                              print("Check Jumlah : ${checkJumlah}");
                              print("Check Jumlah : ${checkJumlah == 0}");
                              if (checkJumlah == 0) {
                                var message = await cartProduct.deleteCart(
                                    cuid: cartProduct.cartList.listData!.first
                                        .cartData![index].sId
                                        .toString(),
                                    token: data.token.toString());
                                if (message != "") {
                                  showToast(message);
                                } else {
                                  if (cartProduct.selectedProducts
                                      .where((element) =>
                                          element["id"].toString() ==
                                          cartProduct.cartList.listData!.first
                                              .cartData![index].produkId
                                              .toString())
                                      .isNotEmpty) {
                                    //Remove data
                                    cartProduct.selectedProducts.removeWhere(
                                        (element) =>
                                            element["id"].toString() ==
                                            cartProduct.cartList.listData!.first
                                                .cartData![index].produkId
                                                .toString());
                                  }
                                  setState(() {
                                    _getCartList();
                                  });
                                }
                              } else {
                                var message = await cartProduct.updateCart(
                                    cuid: cartProduct.cartList.listData!.first
                                        .cartData![index].sId
                                        .toString(),
                                    data: {
                                      "jumlah": jumlahItemSelected,
                                      "catatan": cartProduct.cartList.listData!
                                          .first.cartData![index].catatan,
                                    },
                                    token: data.token.toString());

                                if (message != "") {
                                  showToast(message);
                                } else {
                                  showToast("Berhasil Memperbarui Pesanan");
                                  setState(() {
                                    _getCartList();
                                  });
                                }
                              }

                              // Find the ScaffoldMessenger in the widget tree
                              // and use it to show a SnackBar.

                              stateSetter(() {
                                isLoading = false;
                              });

                              Navigator.pop(context);
                            } else {
                              stateSetter(() {
                                isLoading = false;
                              });
                              showToast("Melebihi batas stok tersedia : $stok");
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              shape: StadiumBorder(
                                side: BorderSide(
                                    width: 1,
                                    color: (jumlahItemSelected) == 0
                                        ? Colors.red
                                        : backgroundColor3),
                              ),
                              backgroundColor: (jumlahItemSelected) == 0
                                  ? Colors.red
                                  : backgroundColor1),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                (jumlahItemSelected) == 0
                                    ? Icons.delete
                                    : Icons.shopping_cart,
                                color: Colors.white,
                              ),
                              Text(
                                (jumlahItemSelected) == 0
                                    ? ' Hapus dari keranjang'
                                    : ' Perbarui keranjang',
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

    Widget cartDynamicCard(int index) {
      print(
          "Multi Satuan : ${cartProduct.cartList.listData!.first.cartData![index].jumlahMultisatuan!.length}");
      print(
          "Multi Satuan : ${cartProduct.cartList.listData!.first.cartData![index].multisatuanUnit!.length}");

      if (cartProduct.selectedProducts
          .where((element) =>
              element["id"].toString() ==
              cartProduct.cartList.listData!.first.cartData![index].produkId
                  .toString())
          .isNotEmpty) {
        for (int i = 0; i < cartProduct.selectedProducts.length; i++) {
          if (cartProduct.selectedProducts[i]["id"].toString() ==
              cartProduct.cartList.listData!.first.cartData![index].produkId
                  .toString()) {
            print("Found at index ${i}");

            // Append New Data
            int? totalHarga;
            var data = cartProduct.cartList.listData!.first.cartData![index];
            if (data.diskon != null) {
              totalHarga = data.hargaDiskon!.toInt() * data.jumlah!.toInt();
            } else {
              totalHarga = data.harga!.toInt() * data.jumlah!.toInt();
            }

            if (cartProduct.cartList.listData!.first.cartData![index]
                .multisatuanUnit!.isNotEmpty) {
              print("Data After : Multilist");
              cartProduct.selectedProducts[i] = {
                "id": data.produkId,
                "nama_produk": data.namaProduk.toString(),
                "image_url":
                    "http://103.127.132.116/uploads/images/${cartProduct.cartList.listData!.first.cartData![index].imageUrl.toString()}",
                "harga": data.diskon != null ? data.hargaDiskon : data.harga,
                "jumlah": data.jumlah,
                "total_harga": totalHarga,
                "catatan": data.catatan,
                "jumlah_multisatuan": data.jumlahMultisatuan,
                "multisatuan_jumlah": data.multisatuanJumlah,
                "multisatuan_unit": data.multisatuanUnit,
                "golongan_produk": data.golonganProduk,
                "kategori": data.kategori,
                "kategori_slug": data.kategoriSlug,
                "satuan_produk": data.satuanProduk
              };
            } else {
              cartProduct.selectedProducts[i] = {
                "id": data.produkId,
                "nama_produk": data.namaProduk.toString(),
                "image_url":
                    "http://103.127.132.116/uploads/images/${cartProduct.cartList.listData!.first.cartData![index].imageUrl.toString()}",
                "harga": data.diskon != null ? data.hargaDiskon : data.harga,
                "jumlah": data.jumlah,
                "total_harga": totalHarga,
                "catatan": data.catatan,
                "golongan_produk": data.golonganProduk,
                "kategori": data.kategori,
                "kategori_slug": data.kategoriSlug,
                "satuan_produk": data.satuanProduk
              };
            }

            print("Data After : ${cartProduct.selectedProducts.toString()}");
            break;
          }
        }
      }

      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailItem(
                    imageUrl: cartProduct
                        .cartList.listData!.first.cartData![index].imageUrl
                        .toString(),
                    id: cartProduct
                        .cartList.listData!.first.cartData![index].produkId
                        .toString())),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(vertical: 10),
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Checkbox(
                value: cartProduct.selectedProducts
                        .where((element) =>
                            element["id"].toString() ==
                            cartProduct.cartList.listData!.first
                                .cartData![index].produkId
                                .toString())
                        .isNotEmpty
                    ? true
                    : false,
                activeColor: backgroundColor1,
                onChanged: (value) async {
                  print("Checkbox tapped $value");
                  var data =
                      cartProduct.cartList.listData!.first.cartData![index];
                  if (value == true) {
                    int? totalHarga;
                    if (data.diskon != null) {
                      totalHarga =
                          data.hargaDiskon!.toInt() * data.jumlah!.toInt();
                    } else {
                      totalHarga = data.harga!.toInt() * data.jumlah!.toInt();
                    }

                    print(
                        "Checkbox tapped ${cartProduct.cartList.listData!.first.cartData![index].multisatuanUnit}");
                    print(
                        "Checkbox tappped ${cartProduct.cartList.listData!.first.cartData![index].multisatuanUnit != null}");

                    print(
                        "Checkbox tapped ${cartProduct.cartList.listData!.first.cartData![index].kategori}");

                    print(
                        "Checkbox tapped ${cartProduct.cartList.listData!.first.cartData![index].kategoriSlug}");

                    if (cartProduct.cartList.listData!.first.cartData![index]
                            .multisatuanUnit !=
                        null) {
                      cartProduct.selectedProducts.add({
                        "id": data.produkId,
                        "nama_produk": data.namaProduk.toString(),
                        "image_url":
                            "http://103.127.132.116/uploads/images/${cartProduct.cartList.listData!.first.cartData![index].imageUrl.toString()}",
                        "harga":
                            data.diskon != null ? data.hargaDiskon : data.harga,
                        "jumlah": data.jumlah,
                        "total_harga": totalHarga,
                        "catatan": data.catatan,
                        "jumlah_multisatuan": cartProduct.cartList.listData!
                            .first.cartData![index].jumlahMultisatuan,
                        "multisatuan_jumlah": cartProduct.cartList.listData!
                            .first.cartData![index].multisatuanJumlah,
                        "multisatuan_unit": cartProduct.cartList.listData!.first
                            .cartData![index].multisatuanUnit,
                        "golongan_produk": cartProduct.cartList.listData!.first
                            .cartData![index].golonganProduk
                            .toString(),
                        "kategori": cartProduct
                            .cartList.listData!.first.cartData![index].kategori,
                        "kategori_slug": cartProduct.cartList.listData!.first
                            .cartData![index].kategoriSlug,
                        "satuan_produk": cartProduct.cartList.listData!.first
                            .cartData![index].satuanProduk,
                      });
                    } else {
                      cartProduct.selectedProducts.add({
                        "id": data.produkId,
                        "nama_produk": data.namaProduk.toString(),
                        "image_url":
                            "http://103.127.132.116/uploads/images/${cartProduct.cartList.listData!.first.cartData![index].imageUrl.toString()}",
                        "harga":
                            data.diskon != null ? data.hargaDiskon : data.harga,
                        "jumlah": data.jumlah,
                        "total_harga": totalHarga,
                        "catatan": data.catatan,
                        "golongan_produk": cartProduct.cartList.listData!.first
                            .cartData![index].golonganProduk,
                        "kategori": cartProduct
                            .cartList.listData!.first.cartData![index].kategori,
                        "kategori_slug": cartProduct.cartList.listData!.first
                            .cartData![index].kategoriSlug,
                        "satuan_produk": cartProduct.cartList.listData!.first
                            .cartData![index].satuanProduk,
                      });
                    }
                    print(
                        "Data After : ${cartProduct.selectedProducts.toString()}");
                  } else {
                    cartProduct.selectedProducts.removeWhere((element) =>
                        element["id"].toString() ==
                        cartProduct
                            .cartList.listData!.first.cartData![index].produkId
                            .toString());
                  }

                  setState(() {
                    isSelected = value;
                  });
                },
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                clipBehavior: Clip.antiAlias,
                // borderRadius: BorderRadius.circular(8),
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image:
                      "http://103.127.132.116/uploads/images/${cartProduct.cartList.listData!.first.cartData![index].imageUrl.toString()}",
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
                  },
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "${cartProduct.cartList.listData!.first.cartData![index].namaProduk}",
                        style: poppins.copyWith(
                            overflow: TextOverflow.ellipsis,
                            fontWeight: semiBold,
                            fontSize: 18,
                            color: backgroundColor1),
                        maxLines: 2,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        CurrencyFormat.convertToIdr(
                                (cartProduct.cartList.listData!.first
                                                .cartData![index].diskon !=
                                            0 ||
                                        cartProduct.cartList.listData!.first
                                                .cartData![index].diskon !=
                                            null)
                                    ? cartProduct.cartList.listData!.first
                                        .cartData![index].hargaDiskon
                                    : cartProduct.cartList.listData!.first
                                        .cartData![index].harga,
                                2)
                            .toString(),
                        style: poppins.copyWith(
                            fontWeight: regular,
                            color: backgroundColor3,
                            overflow: TextOverflow.ellipsis),
                        maxLines: 2,
                      ),
                      if (cartProduct.cartList.listData!.first.cartData![index]
                              .diskon !=
                          null) ...[
                        Row(
                          children: [
                            Text(
                              CurrencyFormat.convertToIdr(
                                      cartProduct.cartList.listData!.first
                                          .cartData![index].harga,
                                      2)
                                  .toString(),
                              style: poppins.copyWith(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 10,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough),
                              maxLines: 2,
                            ),
                            Text(
                              " ${cartProduct.cartList.listData!.first.cartData![index].diskon}%",
                              style: poppins.copyWith(
                                  fontSize: 10,
                                  color: Colors.red,
                                  fontWeight: bold),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(
                        height: 5,
                      ),
                      if (cartProduct.cartList.listData!.first.cartData![index]
                          .multisatuanUnit!.isNotEmpty) ...[
                        for (var i = 0;
                            i <
                                cartProduct.cartList.listData!.first
                                    .cartData![index].jumlahMultisatuan!.length;
                            i++) ...[
                          if (cartProduct.cartList.listData!.first
                                      .cartData![index].jumlahMultisatuan![i] >
                                  0 &&
                              cartProduct.cartList.listData!.first
                                      .cartData![index].multisatuanUnit?[i] !=
                                  "pcs")
                            Text(
                              "${cartProduct.cartList.listData!.first.cartData![index].jumlahMultisatuan?[i]} ${cartProduct.cartList.listData!.first.cartData![index].multisatuanUnit?[i]} (Isi ${cartProduct.cartList.listData!.first.cartData![index].multisatuanJumlah?[i]})",
                              style: poppins.copyWith(
                                  fontSize: 10,
                                  fontWeight: regular,
                                  color: Colors.grey,
                                  overflow: TextOverflow.ellipsis),
                              maxLines: 2,
                            ),
                        ],
                      ],
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipOval(
                            child: Container(
                              height: 25,
                              width: 25,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              child: InkWell(
                                onTap: () {
                                  // Data Cart
                                  cartProduct.cartUpdate = parameterCart(
                                      note: cartProduct.cartList.listData!.first
                                          .cartData![index].catatan
                                          .toString(),
                                      total: cartProduct.cartList.listData!
                                              .first.cartData![index].jumlah ??
                                          0);

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
                                          padding:
                                              MediaQuery.of(context).viewInsets,
                                          child: bottomSheetDialog(index),
                                        );
                                      }).then((value) => setState(() {
                                        _getCartList();
                                      }));
                                },
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          ClipOval(
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                color: (cartProduct.cartList.listData!.first
                                            .cartData![index].jumlah!) >
                                        1
                                    ? backgroundColor2
                                    : Colors.red,
                              ),
                              child: InkWell(
                                onTap: () async {
                                  if (cartProduct
                                          .cartList
                                          .listData!
                                          .first
                                          .cartData![index]
                                          .jumlahMultisatuan!
                                          .isNotEmpty &&
                                      (cartProduct.cartList.listData!.first
                                              .cartData![index].jumlah!) >
                                          1) {
                                    var dataCart = cartProduct.cartList
                                        .listData!.first.cartData![index];
                                    print(
                                        "Datacart : ${dataCart.jumlahMultisatuan.toString()}");
                                    showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(20))),
                                        backgroundColor: Colors.white,
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        builder: (BuildContext context) {
                                          return Padding(
                                            padding: MediaQuery.of(context)
                                                .viewInsets,
                                            child: showMultiSatuan(
                                                index,
                                                dataCart.multisatuanUnit,
                                                dataCart.multisatuanJumlah,
                                                dataCart.jumlahMultisatuan),
                                          );
                                        }).then((value) => setState(() {
                                          _getCartList();
                                        }));
                                  } else {
                                    var dataCart = cartProduct.cartList
                                        .listData!.first.cartData![index];
                                    showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(20))),
                                        backgroundColor: Colors.white,
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        builder: (BuildContext context) {
                                          return Padding(
                                            padding: MediaQuery.of(context)
                                                .viewInsets,
                                            child: showSatuan(
                                              index,
                                              dataCart,
                                            ),
                                          );
                                        }).then((value) => setState(() {
                                          _getCartList();
                                        }));
                                  }
                                },
                                child: Icon(
                                  (cartProduct.cartList.listData!.first
                                              .cartData![index].jumlah!) >
                                          1
                                      ? Icons.remove
                                      : Icons.delete,
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
                              cartProduct.cartList.listData!.first
                                  .cartData![index].jumlah
                                  .toString(),
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
                                  var dataCart = cartProduct.cartList.listData!
                                      .first.cartData![index];
                                  print(
                                      "Datacart : ${dataCart.jumlahMultisatuan.toString()}");
                                  if (cartProduct
                                      .cartList
                                      .listData!
                                      .first
                                      .cartData![index]
                                      .jumlahMultisatuan!
                                      .isNotEmpty) {
                                    showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(20))),
                                        backgroundColor: Colors.white,
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        builder: (BuildContext context) {
                                          return Padding(
                                            padding: MediaQuery.of(context)
                                                .viewInsets,
                                            child: showMultiSatuan(
                                                index,
                                                dataCart.multisatuanUnit,
                                                dataCart.multisatuanJumlah,
                                                dataCart.jumlahMultisatuan),
                                          );
                                        }).then((value) => setState(() {
                                          _getCartList();
                                        }));
                                  } else {
                                    var dataCart = cartProduct.cartList
                                        .listData!.first.cartData![index];
                                    showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(20))),
                                        backgroundColor: Colors.white,
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        builder: (BuildContext context) {
                                          return Padding(
                                            padding: MediaQuery.of(context)
                                                .viewInsets,
                                            child: showSatuan(
                                              index,
                                              dataCart,
                                            ),
                                          );
                                        }).then((value) => setState(() {
                                          _getCartList();
                                        }));
                                  }
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
                      const SizedBox(
                        height: 5,
                      ),
                      if (cartProduct.cartList.listData!.first.cartData![index]
                              .catatan !=
                          "")
                        Text(
                          "' ${cartProduct.cartList.listData!.first.cartData![index].catatan} '",
                          style: poppins.copyWith(
                              fontSize: 10,
                              fontWeight: regular,
                              color: backgroundColor3,
                              overflow: TextOverflow.ellipsis),
                          maxLines: 2,
                        ),
                      const SizedBox(
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

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        left: true,
        right: true,
        bottom: true,
        child: Container(
          padding: const EdgeInsets.only(bottom: 10),
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
                          "Keranjang anda",
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
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CustomerSearch()),
                        ).then((value) => () {
                              setState(() {
                                print("Selected Value");
                              });
                            });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: Colors.grey,
                              width: 1,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: double.infinity,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.person,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            SizedBox(
                              child: Text(
                                selectedCustomer,
                                // "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque laoreet a tellus eget dapibus.",
                                style: poppins.copyWith(
                                    fontWeight: regular,
                                    fontSize: 14,
                                    overflow: TextOverflow.ellipsis),
                                maxLines: 2,
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.arrow_forward_ios,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              if (_isLoading) ...[
                Expanded(
                    child: Center(
                        child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _isLoading
                        ? Container(
                            width: 40,
                            margin: const EdgeInsets.only(top: 10, bottom: 10),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : Container(),
                    Text(
                      "Loading data",
                      style:
                          poppins.copyWith(fontWeight: regular, fontSize: 20),
                    ),
                  ],
                )))
              ] else ...[
                if (cartProduct.cartList.listData!.isEmpty) ...[
                  Expanded(
                      child: Center(
                          child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.shopping_cart,
                        size: 48,
                      ),
                      Text(
                        "Keranjang Kosong",
                        style:
                            poppins.copyWith(fontWeight: regular, fontSize: 20),
                      ),
                    ],
                  )))
                ] else ...[
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 20),
                      children: [
                        for (int i = 0;
                            i <
                                cartProduct
                                    .cartList.listData!.first.cartData!.length;
                            i++)
                          cartDynamicCard(i)
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
                          onPressed: () {
                            // Reset data
                            settingsProvider.selectedShip = null;
                            // customerProvider.selectAddress = null;
                            if (cartProduct.cartList.listData!.isNotEmpty &&
                                customerListFiltered.isNotEmpty &&
                                cartProduct.selectedProducts.isNotEmpty) {
                              print(
                                  "selectedProducts : ${cartProduct.selectedProducts.toString()}");

                              Navigator.pushNamed(context, '/checkout_summary');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              shape: StadiumBorder(
                                  side: BorderSide(
                                      width: 1, color: backgroundColor3)),
                              backgroundColor: (cartProduct
                                          .cartList.listData!.isNotEmpty &&
                                      customerListFiltered.isNotEmpty &&
                                      cartProduct.selectedProducts.isNotEmpty)
                                  ? backgroundColor3
                                  : Colors.grey),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.shopping_cart_outlined,
                                color: Colors.white,
                              ),
                              Text(
                                ' Lanjutkan Transaksi',
                                style: poppins.copyWith(
                                    fontWeight: semiBold, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ]
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class CurrencyFormat {
  static String convertToIdr(dynamic number, int decimalDigit) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: decimalDigit,
    );
    return currencyFormatter.format(number);
  }
}
