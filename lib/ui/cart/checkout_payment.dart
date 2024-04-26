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

    Widget cartDynamicCard(int index) {
      var data = settingsProvider.paymentList!.paymentData![index];
      return GestureDetector(
        onTap: () {
          settingsProvider.selectedPayment = data.id;
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
                  color: data.id == settingsProvider.selectedPayment
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
                value:
                    data.id == settingsProvider.selectedPayment ? true : false,
                activeColor: backgroundColor1,
                onChanged: (value) async {
                  print("Checkbox tapped $value");
                  settingsProvider.selectedPayment = data.id;
                  setState(() {});
                },
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                clipBehavior: Clip.antiAlias,
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: data.logoBank.toString(),
                  fit: BoxFit.fitHeight,
                  height: 75,
                  width: 100,
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
                        data.namaBank.toString(),
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
                        data.noRekening.toString(),
                        style: poppins.copyWith(
                            fontWeight: regular,
                            color: backgroundColor3,
                            overflow: TextOverflow.ellipsis),
                        maxLines: 2,
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

    Widget cartSummaryCard() {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              color: Colors.grey, width: 1, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total Item",
                  style: poppins.copyWith(
                    color: Colors.black,
                  ),
                ),
                Text(
                  " ${cartProduct.selectedProducts.length} Item",
                  style: poppins.copyWith(
                    color: backgroundColor1,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total Harga",
                  style: poppins.copyWith(
                    color: Colors.black,
                  ),
                ),
                Text(
                  "Rp. ${widget.mapData?["total_harga"]}",
                  style: poppins.copyWith(
                    color: backgroundColor1,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total Ongkir",
                  style: poppins.copyWith(
                    color: Colors.black,
                  ),
                ),
                Text(
                  "Rp. ${widget.mapData?["total_ongkos_kirim"]}",
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
                  "Total Harga + Ongkir",
                  style: poppins.copyWith(
                    fontWeight: bold,
                    color: Colors.black,
                  ),
                ),
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
          ],
        ),
      );
    }

    return Scaffold(
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
                      "Pilih Metode Pembayaran",
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
                      "Metode Pembayaran Tersedia",
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
                        i++) ...[cartDynamicCard(i)],
                    Text(
                      "Ringkasan Pembelian",
                      style: poppins.copyWith(
                          fontSize: 16,
                          fontWeight: regular,
                          color: Colors.black),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    cartSummaryCard(),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });

                              if (settingsProvider.selectedPayment != null) {
                                var bankData = settingsProvider
                                    .paymentList!.paymentData
                                    ?.where((element) =>
                                        element.id ==
                                        settingsProvider.selectedPayment);
                                print(
                                    "bankData : ${settingsProvider.selectedPayment}");
                                print(
                                    "bankData : ${settingsProvider.paymentList!.paymentData?.first.id}");

                                if (bankData != null || bankData!.isNotEmpty) {
                                  widget.mapData?["metode_pembayaran"] =
                                      "transfer";
                                  widget.mapData?.addAll({
                                    "bank_transfer": bankData.first.namaBank,
                                    "norekening_transfer":
                                        bankData.first.noRekening
                                  });
                                }
                                print(
                                    "selectedProducts : ${widget.mapData.toString()}");
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
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
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
              )),
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
