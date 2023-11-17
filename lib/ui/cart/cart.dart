import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:e_shop/provider/cart_provider.dart';
import 'package:e_shop/provider/customer_provider.dart';
import 'package:e_shop/theme/theme.dart';
import 'package:e_shop/ui/cart/customer_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../detail_item.dart';

class Cart extends StatefulWidget {
  final int index;
  const Cart({super.key, this.index = 0});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  final List<String> items = [
    'Toko Adamdam',
    'Toko Adamdam2',
    'Toko Adamdam3',
    'Toko Adamdam4',
    'Toko Adamdam5',
    'Toko Adamdam7',
    'Toko Adamdam8',
    'Jl.Bendungan Sutami GG.6 No 11, Lowokwaru, Kota Malang, Jawa Timur.',
  ];

  String? selectedValue;
  final TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CartProvider cartProduct = Provider.of<CartProvider>(context);
    CustomerProvider customerProvider = Provider.of<CustomerProvider>(context);

    int countItem = 0;
    int subTotal = 0;

    Widget listFormBuilder(
        {required List<String> items,
        required String headerText,
        required IconData icon}) {
      selectedValue = items[0];
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              headerText,
              style: poppins.copyWith(fontWeight: semiBold, fontSize: 14),
            ),
            const SizedBox(
              height: 10,
            ),
            DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                isExpanded: true,
                hint: Row(
                  children: [
                    Icon(
                      icon,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        '$selectedValue',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: regular,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                items: items
                    .map((String item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: TextStyle(
                              fontWeight: regular,
                              color: Colors.grey,
                            ),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                    .toList(),
                value: selectedValue,
                buttonStyleData: ButtonStyleData(
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 14, right: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    color: Colors.white,
                  ),
                  elevation: 1,
                ),
                iconStyleData: const IconStyleData(
                  icon: Icon(
                    Icons.arrow_forward_ios_outlined,
                  ),
                  iconSize: 14,
                  iconEnabledColor: Colors.grey,
                  iconDisabledColor: Colors.grey,
                ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  offset: const Offset(0, 0),
                  scrollbarTheme: ScrollbarThemeData(
                    thickness: MaterialStateProperty.all(6),
                    thumbVisibility: MaterialStateProperty.all(true),
                  ),
                ),
                dropdownSearchData: DropdownSearchData(
                  searchController: textEditingController,
                  searchInnerWidgetHeight: 50,
                  searchInnerWidget: Container(
                    height: 50,
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 4,
                      right: 8,
                      left: 8,
                    ),
                    child: TextFormField(
                      expands: true,
                      maxLines: null,
                      controller: textEditingController,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 2,
                          vertical: 8,
                        ),
                        hintText: 'Search customer here...',
                        hintStyle: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  searchMatchFn: (item, searchValue) {
                    return item.value.toString().contains(searchValue);
                  },
                ),
                barrierColor: Colors.grey.withOpacity(0.5),
                onChanged: (value) {
                  setState(() {
                    selectedValue = value!;
                  });
                },
              ),
            ),
          ],
        ),
      );
    }

    Widget bottomSheetDialog() {
      String selectedCustomer = "Select customer";

      if (customerProvider.myCustomer.isEmpty) {
        selectedCustomer = "Select customer";
      } else {
        selectedCustomer = customerProvider
            .myCustomer[customerProvider.selectCustomer]["name"];
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
                      fontSize: 24, fontWeight: semiBold, color: backgroundColor1),
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
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.grey, width: 1, style: BorderStyle.solid),
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
                      fontSize: 24, fontWeight: semiBold, color: backgroundColor1),
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
                        color: Colors.black,
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
                        color: Colors.black,
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
                        color: Colors.black,
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
                        color: Colors.black,
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
                          side: BorderSide(width: 1, color: backgroundColor3)),
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
      // subtotal
      subTotal +=
          int.parse(cartProduct.myProducts[index]["amount"].toString()) *
              int.parse(cartProduct.myProducts[index]["price"].toString());

      // count item
      countItem +=
          int.parse(cartProduct.myProducts[index]["amount"].toString());

      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailItem(
                      imageUrl: cartProduct.myProducts[index]["id"],
                    )),
          ).then((value) => setState(() {}));
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                clipBehavior: Clip.antiAlias,
                // borderRadius: BorderRadius.circular(8),
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: cartProduct.myProducts[index]["id"],
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
                        "${cartProduct.myProducts[index]["name"]} $index",
                        style: poppins.copyWith(
                            overflow: TextOverflow.ellipsis,
                            fontWeight: semiBold,
                            fontSize: 18,
                            color: backgroundColor1),
                        maxLines: 2,
                      ),
                      Text(
                        CurrencyFormat.convertToIdr(
                                cartProduct.myProducts[index]["price"], 2)
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
                            width: 70,
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
                                          cartProduct.myProducts[index]
                                              ["amount"] += 1;
                                          print(cartProduct.myProducts[index]
                                                  ["amount"]
                                              .toString());
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
                                Text(
                                  cartProduct.myProducts[index]["amount"]
                                      .toString(),
                                  style: poppins.copyWith(
                                      fontWeight: bold,
                                      color: backgroundColor3,
                                      overflow: TextOverflow.ellipsis),
                                  maxLines: 2,
                                ),
                                ClipOval(
                                  child: Container(
                                    height: 25,
                                    width: 25,
                                    decoration: BoxDecoration(
                                      color: backgroundColor2,
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          cartProduct.myProducts[index]
                                              ["amount"] -= 1;
                                          if (cartProduct.myProducts[index]
                                                  ["amount"] <
                                              1) {
                                            print("Index terhapus : $index");
                                            // myProducts.removeWhere((element) => element["id"] == index);
                                            cartProduct.myProducts
                                                .removeAt(index);
                                          }
                                        });
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
                                    cartProduct.myProducts.removeAt(index);
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
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Keranjang anda",
                  style: poppins.copyWith(fontSize: 20, fontWeight: semiBold),
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
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    width: MediaQuery.of(context).size.width * 0.05,
                    child: const Icon(
                      Icons.shopping_cart_checkout,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (cartProduct.myProducts.isEmpty) ...[
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
                  for (int i = 0; i < cartProduct.myProducts.length; i++)
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
