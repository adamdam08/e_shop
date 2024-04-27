import 'package:e_shop/models/product/transaction_history_model.dart';
import 'package:e_shop/provider/auth_provider.dart';
import 'package:e_shop/provider/customer_provider.dart';
import 'package:e_shop/provider/product_provider.dart';
import 'package:e_shop/ui/customer/customer_transact_detail_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../theme/theme.dart';

class CustomerTransactPage extends StatefulWidget {
  final Map myCustomer;
  const CustomerTransactPage({required this.myCustomer, super.key});

  @override
  State<CustomerTransactPage> createState() => _CustomerTransactPageState();
}

class _CustomerTransactPageState extends State<CustomerTransactPage> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

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
        status: "0")) {
    } else {}
    ;

    setState(() {
      isLoading = false;
    });
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
                    image: data.produk!.first.imageUrl.toString(),
                    fit: BoxFit.cover,
                    height: 75,
                    width: 75,
                  ),
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
                    child: productProvider
                            .transactionHistory!.listTransaksi!.isNotEmpty
                        ? ListView(
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
                                ],
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
                                "Riwayat Transaksi Tidak Tersedia",
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
