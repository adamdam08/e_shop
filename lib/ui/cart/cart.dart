import 'package:e_shop/provider/auth_provider.dart';
import 'package:e_shop/provider/cart_provider.dart';
import 'package:e_shop/provider/customer_provider.dart';
import 'package:e_shop/provider/product_provider.dart';
import 'package:e_shop/provider/settings_provider.dart';
import 'package:e_shop/theme/theme.dart';
import 'package:e_shop/ui/cart/customer_search.dart';
import 'package:e_shop/ui/product/detail_item.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();

    _getCartList();
  }

  void _getCartList() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    if (await cartProvider.getCartList(
        token: authProvider.user.token.toString())) {
      setState(() {});
      print("${cartProvider.cartList.listData!.first.cartData!.length}");
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    CartProvider cartProduct = Provider.of<CartProvider>(context);
    CustomerProvider customerProvider = Provider.of<CustomerProvider>(context);

    int countItem = 0;
    int subTotal = 0;

    String selectedCustomer = "Pilih customer";

//dummy data
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

    Widget bottomSheetDialog() {
      String selectedCustomer = "Pilih customer";

      List<Map<dynamic, dynamic>> customerListFiltered = [];
      customerListFiltered = customerProvider.myCustomer;
      customerListFiltered = customerListFiltered
          .where((element) =>
              element["id"] == customerProvider.selectCustomer.toString())
          .toList();

      if (customerProvider.myCustomer.isEmpty) {
        selectedCustomer = "Select customer";
      } else {
        // selectedCustomer = "Select customer";
        selectedCustomer = customerListFiltered.first["nama_lengkap"];
      }

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        color: Colors.white,
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter stateSetter) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pilih Customer",
                  style: poppins.copyWith(
                      fontSize: 24,
                      fontWeight: semiBold,
                      color: backgroundColor1),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CustomerSearch()),
                    ).then((value) => stateSetter(() {
                          Navigator.pop(context);
                          showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20))),
                              backgroundColor: Colors.white,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              builder: (BuildContext context) {
                                return bottomSheetDialog();
                              });
                        }));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
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
                Text(
                  "Ringkasan Pembelian",
                  style: poppins.copyWith(
                      fontSize: 24,
                      fontWeight: semiBold,
                      color: backgroundColor1),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total item",
                      style: poppins.copyWith(
                        color: backgroundColor1,
                      ),
                    ),
                    Text(
                      countItem.toString(),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Biaya Pengiriman",
                      style: poppins.copyWith(
                        color: backgroundColor1,
                      ),
                    ),
                    Text(
                      "Rp.0",
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Promo",
                      style: poppins.copyWith(
                        color: backgroundColor1,
                      ),
                    ),
                    Text(
                      "Rp.0",
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Jumlah Total",
                      style: poppins.copyWith(
                        color: backgroundColor1,
                      ),
                    ),
                    Text(
                      "${CurrencyFormat.convertToIdr(subTotal, 2)}",
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
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      cartProduct.myProducts.clear();
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(
                        side: BorderSide(width: 1, color: backgroundColor3),
                      ),
                      backgroundColor: backgroundColor3),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                      ),
                      Text(
                        ' Buat Pesanan',
                        style: poppins.copyWith(
                            fontWeight: semiBold, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );
    }

    Widget cartDynamicCard(int index) {
      print("Data : ${cartProduct.cartList.listData!.first.cartData![index]}");

      // // subtotal
      // subTotal +=
      //     int.parse(cartProduct.myProducts[index]["amount"].toString()) *
      //         int.parse(cartProduct.myProducts[index]["price"].toString());

      // // count item
      // countItem +=
      //     int.parse(cartProduct.myProducts[index]["amount"].toString());

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
          ).then((value) => setState(() {
                _getCartList();
              }));
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
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                clipBehavior: Clip.antiAlias,
                // borderRadius: BorderRadius.circular(8),
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image:
                      "https://tokosm.online/uploads/images/${cartProduct.cartList.listData!.first.cartData![index].imageUrl.toString()}",
                  fit: BoxFit.cover,
                  height: 125,
                  width: 125,
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                cartProduct.cartList.listData!.first
                                            .cartData![index].diskon !=
                                        0
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipOval(
                                  child: Container(
                                    height: 25,
                                    width: 25,
                                    decoration: BoxDecoration(
                                      color: backgroundColor3,
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          // cartProduct.myProducts[index]
                                          //     ["amount"] += 1;
                                          // print(cartProduct.myProducts[index]
                                          //         ["amount"]
                                          //     .toString());
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
                                    height: 25,
                                    width: 25,
                                    decoration: BoxDecoration(
                                      color: backgroundColor2,
                                    ),
                                    child: InkWell(
                                      onTap: () async {
                                        if (context.mounted) {
                                          setState(() {});
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
                              ],
                            ),
                          ),
                          ClipOval(
                            child: Container(
                              height: 25,
                              width: 25,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                              ),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    // cartProduct.myProducts.removeAt(index);
                                  });
                                },
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      ClipOval(
                        child: Container(
                          height: 25,
                          width: 25,
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                          ),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                // cartProduct.myProducts[index]["amount"] += 1;
                                print(cartProduct.myProducts[index]["amount"]
                                    .toString());
                              });
                            },
                            child: const Icon(
                              Icons.edit_note,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
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

    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            color: backgroundColor3,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Keranjang anda",
                      style: poppins.copyWith(
                          fontSize: 20,
                          fontWeight: semiBold,
                          color: Colors.white),
                    ),
                    InkWell(
                      onTap: () {
                        if (cartProduct.myProducts.isNotEmpty) {
                          showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20))),
                              backgroundColor: Colors.white,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              builder: (BuildContext context) {
                                return bottomSheetDialog();
                              });
                        }
                      },
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                        child: Icon(
                          Icons.shopping_cart_checkout,
                          color: cartProduct.myProducts.isNotEmpty
                              ? Colors.white
                              : Colors.grey,
                        ),
                      ),
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
                    ).then((value) => {print("Selected Value")});
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
                  style: poppins.copyWith(fontWeight: regular, fontSize: 20),
                ),
              ],
            )))
          ] else ...[
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                children: [
                  for (int i = 0;
                      i < cartProduct.cartList.listData!.first.cartData!.length;
                      i++)
                    cartDynamicCard(i)
                ],
              ),
            )
          ]
        ],
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
