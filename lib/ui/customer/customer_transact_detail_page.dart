import 'package:e_shop/models/product/transaction_history_model.dart';
import 'package:e_shop/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:transparent_image/transparent_image.dart';

class CustomerTransactionDetailPage extends StatefulWidget {
  final ListTransaksi? data;
  const CustomerTransactionDetailPage({required this.data, super.key});

  @override
  State<CustomerTransactionDetailPage> createState() =>
      _CustomerTransactionDetailPageState();
}

class _CustomerTransactionDetailPageState
    extends State<CustomerTransactionDetailPage> {
  Widget cartDynamicCard(Produk data) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                image: data.imageUrl.toString(),
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
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      data.namaProduk.toString(),
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
                      "${data.jumlah.toString()} x Rp.${data.harga.toString()}",
                      style: poppins.copyWith(
                          fontWeight: regular,
                          color: backgroundColor3,
                          overflow: TextOverflow.ellipsis),
                      maxLines: 2,
                    ),
                    Text(
                      "Total : Rp.${data.totalHarga}",
                      style: poppins.copyWith(
                          fontWeight: regular,
                          color: backgroundColor3,
                          overflow: TextOverflow.ellipsis),
                      maxLines: 2,
                    ),
                    if (data.catatan != "")
                      Text(
                        "Catatan : ' ${data.catatan} '",
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

  Widget cartSummaryCard(ListTransaksi? data) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border:
            Border.all(color: Colors.grey, width: 1, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Metode Pembayaran",
                style: poppins.copyWith(
                  color: Colors.black,
                ),
              ),
              Text(
                "${data!.metodePembayaran}",
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
                "Bank",
                style: poppins.copyWith(
                  color: Colors.black,
                ),
              ),
              Text(
                "${data!.bankTransfer}",
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
                "No Rekening",
                style: poppins.copyWith(
                  color: Colors.black,
                ),
              ),
              Text(
                "${data!.norekeningTransfer}",
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
                "Total Item",
                style: poppins.copyWith(
                  color: Colors.black,
                ),
              ),
              Text(
                "${data!.produk!.length} Item",
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
                "Rp. ${data.totalHarga}",
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
                "Rp. ${data.totalOngkosKirim}",
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
                "Rp. ${data.totalBelanja}",
                style:
                    poppins.copyWith(color: backgroundColor1, fontWeight: bold),
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

  Widget dataPembelianCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Data Pembelian",
            style: poppins.copyWith(
                fontSize: 16, fontWeight: regular, color: Colors.black),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Status Pembayaran ",
                    style: poppins.copyWith(
                        fontSize: 12, fontWeight: regular, color: Colors.black),
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: widget.data!.status == 0
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
                      widget.data!.status == 0 ? "Belum Dibayar" : "Selesai",
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
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Nomor Invoice ",
                    style: poppins.copyWith(
                        fontSize: 12, fontWeight: regular, color: Colors.black),
                  ),
                  Text(
                    widget.data!.noInvoice.toString(),
                    style: poppins.copyWith(
                        fontSize: 12, fontWeight: regular, color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget dataAlamatCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Info Pengiriman",
            style: poppins.copyWith(
                fontSize: 16, fontWeight: regular, color: Colors.black),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Metode Pengiriman ",
                    style: poppins.copyWith(
                        fontSize: 12, fontWeight: regular, color: Colors.black),
                  ),
                  Text(
                    widget.data!.namaKurir.toString(),
                    style: poppins.copyWith(
                        fontSize: 12, fontWeight: regular, color: Colors.black),
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
                    "Alamat Pengiriman",
                    style: poppins.copyWith(
                        fontSize: 12, fontWeight: regular, color: Colors.black),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "${widget.data!.alamatPenerima} (${widget.data!.namaPenerima})",
                          style: poppins.copyWith(
                              fontSize: 12,
                              fontWeight: regular,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: true,
        left: true,
        right: true,
        child: Column(
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
                        "Detail Transaksi Pelanggan",
                        style: poppins.copyWith(
                            fontSize: 20,
                            fontWeight: semiBold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  dataPembelianCard(),
                  dataAlamatCard(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Daftar Produk",
                      style: poppins.copyWith(
                          fontSize: 16,
                          fontWeight: regular,
                          color: Colors.black),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  for (int i = 0; i < widget.data!.produk!.length; i++) ...[
                    cartDynamicCard(widget.data!.produk![i])
                  ],
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Total Belanja",
                      style: poppins.copyWith(
                          fontWeight: regular,
                          color: Colors.black,
                          fontSize: 18),
                    ),
                  ),
                  cartSummaryCard(widget.data),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
