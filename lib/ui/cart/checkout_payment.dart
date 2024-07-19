import 'package:e_shop/models/product/product_category_tree_model.dart';
import 'package:e_shop/models/settings/payment_model.dart';
import 'package:e_shop/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../provider/auth_provider.dart';
import '../../provider/cart_provider.dart';
import '../../provider/settings_provider.dart';
import '../../theme/theme.dart';

class CheckoutPayment extends StatefulWidget {
  final Map<String, Object?>? mapData;
  const CheckoutPayment({super.key, required this.mapData});

  @override
  State<CheckoutPayment> createState() => _CheckoutPaymentState();
}

class _CheckoutPaymentState extends State<CheckoutPayment> {
  bool isLoading = false;
  String? bankData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print("Checkout Payment ${widget.mapData}");
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    CartProvider cartProduct = Provider.of<CartProvider>(context);
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    ProductProvider productProvider = Provider.of<ProductProvider>(context);

    Widget cartDynamicCard(int methodIndex, int paymentIndex) {
      var data = settingsProvider
          .paymentList!.paymentData![methodIndex].child?[paymentIndex];
      return GestureDetector(
        onTap: () {
          settingsProvider.selectedPayment = data?.nama;
          bankData = data?.metode;
          print("Selected Payment ${settingsProvider.selectedPayment}");
          print("Payment Method ${widget.mapData?["metode_pembayaran"]}");

          setState(() {});
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: data?.nama == settingsProvider.selectedPayment
                      ? backgroundColor1
                      : Colors.transparent),
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
                value: data?.nama == settingsProvider.selectedPayment
                    ? true
                    : false,
                activeColor: backgroundColor1,
                onChanged: (value) async {
                  print("Checkbox tapped $value");
                  settingsProvider.selectedPayment = data?.nama;
                  setState(() {});
                },
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                clipBehavior: Clip.antiAlias,
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: "${data?.image}",
                  fit: BoxFit.fitHeight,
                  height: 40,
                  width: 100,
                  imageErrorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) {
                    return Container(
                      height: 40,
                      width: 100,
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "${data?.nama}",
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
        bottom: true,
        left: true,
        right: true,
        child: Container(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                color: backgroundColor3,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const SizedBox(
                        width: 20, //MediaQuery.of(context).size.width * 0.1,
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      "Pembayaran",
                      style: poppins.copyWith(
                          fontSize: 20,
                          fontWeight: semiBold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListView(
                    children: [
                      Text(
                        "Pilih Metode Pembayaran",
                        style: poppins.copyWith(
                            fontSize: 16,
                            fontWeight: regular,
                            color: Colors.black),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      for (int i = 0;
                          i < settingsProvider.paymentList!.paymentData!.length;
                          i++) ...[
                        Text(
                          "${settingsProvider.paymentList!.paymentData![i].kategori}",
                          style: poppins.copyWith(
                              fontSize: 16,
                              fontWeight: regular,
                              color: Colors.black),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        for (int x = 0;
                            x <
                                settingsProvider
                                    .paymentList!.paymentData![i].child!.length;
                            x++) ...[
                          cartDynamicCard(i, x),
                        ],
                      ],
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(
                color: Colors.grey,
                height: 0.5,
                thickness: 1,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Harga",
                          style: poppins.copyWith(
                            fontWeight: bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Rp. ${widget.mapData?["total_belanja"]}",
                          style: poppins.copyWith(
                              color: backgroundColor1, fontWeight: bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: SizedBox(
                          height: 50,
                          width: 250,
                          child: ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });

                              if (settingsProvider.selectedPayment != null) {
                                if (bankData != null && bankData!.isNotEmpty) {
                                  widget.mapData?["metode_pembayaran"] =
                                      bankData;
                                  if (bankData == "cod") {
                                    print("cod");
                                    widget.mapData?.addAll({
                                      "bank_transfer": "",
                                      "norekening_transfer": "",
                                    });
                                  } else {
                                    print("non cod");
                                    // widget.mapData?.remove("norekening");
                                    widget.mapData?.addAll({
                                      "bank_transfer":
                                          settingsProvider.selectedPayment,
                                      "norekening_transfer": "",
                                    });
                                  }
                                }
                                print(
                                    "Konfirmasi Transaksi : ${widget.mapData.toString()}");
                              }

                              var data = await authProvider.getLoginData();
                              var message =
                                  await productProvider.addTransaction(
                                      data: widget.mapData,
                                      token: data!.token.toString());

                              setState(() {
                                isLoading = false;
                              });

                              if (message != "") {
                                showToast(message);
                              } else {
                                showToast("Berhasil Menambahkan Transaksi");
                                if (context.mounted) {
                                  Navigator.pushNamedAndRemoveUntil(context,
                                      "/home", (Route<dynamic> route) => false);
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                shape: StadiumBorder(
                                    side: BorderSide(
                                        width: 1, color: backgroundColor3)),
                                backgroundColor:
                                    (settingsProvider.selectedPayment != null)
                                        ? backgroundColor3
                                        : Colors.grey),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                isLoading == true
                                    ? Container(
                                        margin: EdgeInsets.only(right: 10),
                                        width: 20,
                                        height: 20,
                                        child: const CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.shopping_cart_outlined,
                                        color: Colors.white,
                                      ),
                                Text(
                                  ' Konfirmasi Transaksi',
                                  style: poppins.copyWith(
                                      fontWeight: semiBold,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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
