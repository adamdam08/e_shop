import 'package:e_shop/models/product/transaction_history_model.dart';
import 'package:e_shop/provider/auth_provider.dart';
import 'package:e_shop/provider/customer_provider.dart';
import 'package:e_shop/provider/product_provider.dart';
import 'package:e_shop/ui/customer/customer_transact_detail_page.dart';
import 'package:e_shop/ui/home/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme/theme.dart';

class CustomerTransactPage extends StatefulWidget {
  final Map myCustomer;
  const CustomerTransactPage({required this.myCustomer, super.key});

  @override
  State<CustomerTransactPage> createState() => _CustomerTransactPageState();
}

class _CustomerTransactPageState extends State<CustomerTransactPage> {
  bool isLoading = false;
  String _indexStatus = "0";
  TextEditingController descriptionTextController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _getRequestUpdate();

    _getTransactionHistory();
  }

  void _getTransactionHistory() async {
    setState(() {
      isLoading = true;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    var data = await authProvider.getLoginData();
    if (await productProvider.getListTransaction(
        customerId: widget.myCustomer["id"].toString(),
        token: data!.token.toString(),
        status: _indexStatus)) {
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
    ;
    print("Index History ${_indexStatus}");
  }

  void _getRequestUpdate() async {
    setState(() {
      isLoading = true;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final customerProvider =
        Provider.of<CustomerProvider>(context, listen: false);
    var data = await authProvider.getLoginData();

    if (await customerProvider.getRequestUpdateData(
        id: widget.myCustomer["id"].toString(),
        token: data!.token.toString())) {
      descriptionTextController.text =
          customerProvider.customerRequestUpdateData?.requestData?.keterangan ??
              "";
      // setState(() {
      //   isLoading = false;
      // });
      print(
          "Request Update Success ${customerProvider.customerRequestUpdateData!.requestData.toString()}");
    } else {
      print("Request Update Failed");
      // setState(() {
      //   isLoading = false;
      // });
    }
    ;
    print(
        "Request Update Loaded ${customerProvider.customerRequestUpdateData?.requestData?.keterangan}");
    print("Request Update Loaded ${descriptionTextController.text}");
  }

  static Future<void> openMap(String latitude, String longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl) != null) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  Widget transactionDynamicCard(ListTransaksi data) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    CustomerTransactionDetailPage(data: data)));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.black,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "No.Invoice",
                        style: poppins.copyWith(
                            fontWeight: bold,
                            color: Colors.black,
                            fontSize: 12,
                            overflow: TextOverflow.ellipsis),
                        maxLines: 1,
                      ),
                      Text(
                        data.noInvoice.toString(),
                        style: poppins.copyWith(
                            fontWeight: regular,
                            color: Colors.black,
                            fontSize: 12,
                            overflow: TextOverflow.ellipsis),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: data.status == 0
                          ? backgroundColor2
                          : backgroundColor3,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 4,
                            offset: const Offset(0, 0))
                      ]),
                  child: Text(
                    data.status == 0 ? "Belum Dibayar" : "Selesai",
                    style: poppins.copyWith(
                        fontWeight: regular,
                        color: Colors.white,
                        fontSize: 10,
                        overflow: TextOverflow.ellipsis),
                    maxLines: 1,
                  ),
                )
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  clipBehavior: Clip.antiAlias,
                  // borderRadius: BorderRadius.circular(8),
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: data.produk!.first.imageUrl.toString().replaceAll(
                        "https://tokosm.online", "http://103.127.132.116"),
                    fit: BoxFit.cover,
                    height: 75,
                    width: 75,
                    imageErrorBuilder: (BuildContext context, Object error,
                        StackTrace? stackTrace) {
                      return Container(
                        height: 75,
                        width: 75,
                        color: Colors.grey,
                        child: const Center(
                          child: Icon(Icons.error),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.produk!.first.namaProduk.toString(),
                        style: poppins.copyWith(
                            fontWeight: bold,
                            color: Colors.black,
                            fontSize: 18,
                            overflow: TextOverflow.ellipsis),
                        maxLines: 1,
                      ),
                      Text(
                        "1 Barang",
                        style: poppins.copyWith(
                            fontWeight: light,
                            color: Colors.grey,
                            fontSize: 10,
                            overflow: TextOverflow.ellipsis),
                        maxLines: 1,
                      ),
                      if ((data.produk!.length - 1) > 0) ...[
                        Text(
                          "+ ${data.produk!.length - 1} Produk Lainnya",
                          style: poppins.copyWith(
                              fontWeight: light,
                              color: Colors.black,
                              fontSize: 10,
                              overflow: TextOverflow.ellipsis),
                          maxLines: 1,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Belanja",
                        style: poppins.copyWith(
                            fontWeight: medium,
                            color: Colors.grey,
                            fontSize: 10,
                            overflow: TextOverflow.ellipsis),
                        maxLines: 1,
                      ),
                      Text(
                        "Rp.${data.totalBelanja}",
                        style: poppins.copyWith(
                            fontWeight: semiBold,
                            color: Colors.black,
                            fontSize: 10,
                            overflow: TextOverflow.ellipsis),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Metode Pembayaran",
                        style: poppins.copyWith(
                            fontWeight: medium,
                            color: Colors.grey,
                            fontSize: 10,
                            overflow: TextOverflow.ellipsis),
                        maxLines: 1,
                      ),
                      Text(
                        "${data.metodePembayaran.toString()} : ${data.bankTransfer} (${data.norekeningTransfer})",
                        style: poppins.copyWith(
                            fontWeight: semiBold,
                            color: Colors.black,
                            fontSize: 10,
                            overflow: TextOverflow.ellipsis),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final customerProvider = Provider.of<CustomerProvider>(context);

    var checkIsNotEmpty = 0;
    if (productProvider.transactionHistory != null) {
      for (int i = 0;
          i < productProvider.transactionHistory!.listTransaksi!.length;
          i++) {
        if (productProvider
            .transactionHistory!.listTransaksi![i].produk!.isNotEmpty) {
          checkIsNotEmpty += 1;
        }
      }
    }

    return Scaffold(
      body: SafeArea(
        top: true,
        left: true,
        right: true,
        bottom: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              color: backgroundColor3,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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
                        "Riwayat Transaksi Pelanggan",
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
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
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
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                              color: backgroundColor3, shape: BoxShape.circle),
                          margin: const EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: Text(
                              getInitials(
                                  widget.myCustomer["username"].toString()),
                              style: poppins.copyWith(
                                fontWeight: regular,
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.myCustomer["nama_lengkap"].toString(),
                                style: poppins.copyWith(
                                    fontWeight: regular,
                                    color: Colors.black,
                                    fontSize: 18,
                                    overflow: TextOverflow.ellipsis),
                                maxLines: 1,
                              ),
                              Text(
                                widget.myCustomer["telp"].toString(),
                                style: poppins.copyWith(
                                    fontWeight: regular,
                                    color: Colors.black,
                                    fontSize: 18,
                                    overflow: TextOverflow.ellipsis),
                                maxLines: 1,
                              ),
                              Text(
                                widget.myCustomer["email"].toString(),
                                style: poppins.copyWith(
                                    fontWeight: regular,
                                    color: Colors.black,
                                    fontSize: 18,
                                    overflow: TextOverflow.ellipsis),
                                maxLines: 1,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top:
                                                          Radius.circular(20))),
                                          backgroundColor: Colors.white,
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          builder: (BuildContext context) {
                                            return Padding(
                                              padding: MediaQuery.of(context)
                                                  .viewInsets,
                                              child: bottomSheetDialog(1),
                                            );
                                          });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          color: backgroundColor3,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                blurRadius: 4,
                                                offset: const Offset(0, 0))
                                          ]),
                                      child: Text(
                                        (customerProvider
                                                    .customerRequestUpdateData
                                                    ?.requestData
                                                    ?.keterangan ==
                                                "")
                                            ? "Edit Perubahan Data"
                                            : "Ajukan Perubahan Data",
                                        style: poppins.copyWith(
                                            fontSize: 13,
                                            color: Colors.white,
                                            fontWeight: semiBold),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      print(
                                          "Lat : ${widget.myCustomer["lat"]}");
                                      print(
                                          "Lon : ${widget.myCustomer["lon"]}");
                                      if (widget.myCustomer["lat"] != "" &&
                                          widget.myCustomer["lon"] != "") {
                                        await openMap(widget.myCustomer["lat"],
                                            widget.myCustomer["lon"]);
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          color: (widget.myCustomer["lat"] !=
                                                      "" &&
                                                  widget.myCustomer["lon"] !=
                                                      "")
                                              ? backgroundColor3
                                              : Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                blurRadius: 4,
                                                offset: const Offset(0, 0))
                                          ]),
                                      child: const Icon(
                                        Icons.map,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Daftar Transaksi Pelanggan",
                style: poppins.copyWith(
                    fontWeight: semiBold,
                    color: Colors.black,
                    fontSize: 18,
                    overflow: TextOverflow.ellipsis),
                maxLines: 1,
              ),
            ),
            SizedBox(
              height: 45,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: ListView(
                      padding:
                          const EdgeInsets.only(left: 30, right: 30, bottom: 5),
                      scrollDirection: Axis.horizontal,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _indexStatus = "0";
                              _getTransactionHistory();
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: _indexStatus == "0"
                                    ? backgroundColor1
                                    : backgroundColor3),
                            child: Text("Belum Dibayar",
                                style: poppins.copyWith(color: Colors.white)),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _indexStatus = "1";
                              _getTransactionHistory();
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: _indexStatus == "1"
                                    ? backgroundColor1
                                    : backgroundColor3),
                            child: Text("Diproses",
                                style: poppins.copyWith(color: Colors.white)),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _indexStatus = "2";
                              _getTransactionHistory();
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: _indexStatus == "2"
                                    ? backgroundColor1
                                    : backgroundColor3),
                            child: Text("Dikirim",
                                style: poppins.copyWith(color: Colors.white)),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _indexStatus = "3";
                              _getTransactionHistory();
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: _indexStatus == "3"
                                    ? backgroundColor1
                                    : backgroundColor3),
                            child: Text("Selesai",
                                style: poppins.copyWith(color: Colors.white)),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _indexStatus = "4";
                              _getTransactionHistory();
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: _indexStatus == "4"
                                    ? backgroundColor1
                                    : backgroundColor3),
                            child: Text("Dibatalkan",
                                style: poppins.copyWith(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            isLoading == true
                ? Expanded(
                    child: Container(
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
                    child: (productProvider.transactionHistory!.listTransaksi!
                                .isNotEmpty &&
                            checkIsNotEmpty != 0)
                        ? ListView(
                            shrinkWrap: true,
                            children: [
                              if (productProvider.transactionHistory!
                                  .listTransaksi!.isNotEmpty) ...[
                                for (int i = 0;
                                    i <
                                        productProvider.transactionHistory!
                                            .listTransaksi!.length;
                                    i++) ...[
                                  if (productProvider
                                      .transactionHistory!
                                      .listTransaksi![i]
                                      .produk!
                                      .isNotEmpty) ...[
                                    transactionDynamicCard(productProvider
                                        .transactionHistory!.listTransaksi![i])
                                  ]
                                ]
                              ] else ...[
                                Center(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.shopping_bag_outlined,
                                      size: 48,
                                    ),
                                    Text(
                                      "Riwayat Transaksi Tidak Tersedia",
                                      style: poppins.copyWith(
                                          fontWeight: regular, fontSize: 20),
                                    ),
                                  ],
                                ))
                              ],
                            ],
                          )
                        : Center(
                            child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.shopping_bag_outlined,
                                size: 48,
                              ),
                              Text(
                                "Riwayat Transaksi Tidak Tersesia",
                                style: poppins.copyWith(
                                    fontWeight: regular, fontSize: 20),
                              ),
                            ],
                          )),
                  ),
          ],
        ),
      ),
    );
  }

  Widget bottomSheetDialog(int index) {
    bool isLoading = false;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      color: Colors.white,
      child: StatefulBuilder(
          builder: (BuildContext context, StateSetter stateSetter) {
        descriptionTextController.selection = TextSelection.collapsed(
            offset: descriptionTextController.text.length);

        return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
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
                    Text(
                      "Catatan perubahan data",
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
                          borderSide: BorderSide(color: Colors.white, width: 1),
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
                      onChanged: (value) => {},
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    if (isLoading) ...[
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            shape: StadiumBorder(
                              side:
                                  BorderSide(width: 1, color: backgroundColor3),
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

                          if (descriptionTextController.text == "") {
                            showToast("Catatan Kosong");
                          } else {
                            final authProvider = Provider.of<AuthProvider>(
                                context,
                                listen: false);
                            final customerProvider =
                                Provider.of<CustomerProvider>(context,
                                    listen: false);
                            // Get data from SharedPref
                            var data = await authProvider.getLoginData();

                            // Get Best Seller
                            if (data!.token != null) {
                              var message = await customerProvider
                                  .addRequestUpdateData(data: {
                                "pelanggan_id":
                                    widget.myCustomer["id"].toString(),
                                "keterangan": descriptionTextController.text,
                              }, token: data.token.toString());

                              if (message != "") {
                                showToast(message);
                              } else {
                                showToast("Berhasil menambahkan request");
                                if (context.mounted) {
                                  setState(() {
                                    print("Berhasil memperbarui");
                                    _getRequestUpdate();
                                  });
                                  Navigator.pop(context);
                                }
                              }
                            }
                          }

                          stateSetter(() {
                            isLoading = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            shape: StadiumBorder(
                              side:
                                  BorderSide(width: 1, color: backgroundColor3),
                            ),
                            backgroundColor: backgroundColor1),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.send,
                              color: Colors.white,
                            ),
                            Text(
                              descriptionTextController.text != ""
                                  ? "Edit Perubahan Data"
                                  : ' Ajukan Perubahan Data',
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

  String getInitials(String name) {
    // Split the name into individual words
    List<String> words = name.split(' ');

    // Initialize an empty string to store initials
    String initials = '';

    // Iterate through each word and extract the first letter
    for (int i = 0; i < words.length && i < 2; i++) {
      // Get the first letter of the word and add it to the initials string
      initials += words[i][0];
    }

    // Return the initials string
    return initials;
  }
}
