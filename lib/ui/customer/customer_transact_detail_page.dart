import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:e_shop/models/product/transaction_history_model.dart';
import 'package:e_shop/provider/auth_provider.dart';
import 'package:e_shop/provider/customer_provider.dart';
import 'package:e_shop/provider/settings_provider.dart';
import 'package:e_shop/theme/theme.dart';
import 'package:e_shop/ui/customer/payment_information_page.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';
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
  // Printer Thermal
  bool connected = false;
  List availableBluetoothDevices = [];

  @override
  void initState() {
    super.initState();
  }

  void _getPaymentInfo() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);
    var data = await authProvider.getLoginData();

    var kode = "${widget.data!.metodePembayaran}${widget.data!.bankTransfer}";

    if (await settingsProvider.getPaymentInfo(
        token: data!.token.toString(),
        cabangId: widget.data!.cabangId.toString(),
        kode: kode)) {
      print("HTML : ${settingsProvider.paymentInfo?.PaymentData}");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PaymentInformationPage(
                  paymentInfo:
                      "${settingsProvider.paymentInfo?.PaymentData}")));
    } else {}
  }

  Future<void> getBluetooth() async {
    connected = false;
    final List? bluetooths = await BluetoothThermalPrinter.getBluetooths;
    print("List Bluetooth : $bluetooths");
    setState(() {
      availableBluetoothDevices = bluetooths!;
    });
  }

  Future<bool> setConnect(String mac) async {
    try {
      await PrintBluetoothThermal.disconnect;
      print("state connected $mac");
      final bool results =
          await PrintBluetoothThermal.connect(macPrinterAddress: mac);

      print("state connected $results pbt");

      if (results) {
        Navigator.pop(context);
        setState(() {
          showToast("Cetak resi dimulai");
          connected = true;
          printTicket();
          print("Printer connected : ${connected}");
        });
        return true;
      } else {
        showToast("Cetak resi gagal, cek kembali perangkat anda");
        await getBluetooth();
        setState(() {});
        return false;
      }
    } catch (e) {
      setConnect("");
      print("Error : ${e}");
      showToast("Cetak resi gagal, cek kembali perangkat anda");
      setState(() {});
      return false;
    }
  }

  Future<List<int>> getTicket() async {
    List<int> bytes = [];
    CapabilityProfile profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);

    bytes += generator.text("Toko SM",
        styles: const PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);

    bytes += generator.text("Cabang Pusat",
        styles: const PosStyles(align: PosAlign.center));

    bytes += generator.text("No. Invoice",
        styles: const PosStyles(align: PosAlign.center));

    bytes += generator.text(widget.data!.noInvoice.toString(),
        styles: const PosStyles(align: PosAlign.center));

    bytes += generator.hr();

    for (int i = 0; i < widget.data!.produk!.length; i++) {
      var produkData = widget.data!.produk![i];

      // Pack State
      var packString = "";
      if (produkData.jumlahMultisatuan!.isNotEmpty) {
        for (var i = 0; i < produkData.jumlahMultisatuan!.length; i++) {
          var jumlah = produkData.jumlahMultisatuan?[i];
          var unit = produkData.multisatuanUnit?[i];

          print("PackString : $jumlah");
          print("PackString : $unit");

          if (jumlah! > 0) {
            packString += "(${jumlah} ${unit})".toUpperCase();
          }
        }
      }

      bytes += generator.text("${produkData.namaProduk}");
      bytes += generator.row([
        PosColumn(
            text: "${produkData.jumlah} x Rp.${produkData.harga}",
            width: 6,
            styles: const PosStyles(
              align: PosAlign.center,
            )),
        PosColumn(
          text: "Rp.${produkData.totalHarga}",
          width: 6,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
      if (produkData.jumlahMultisatuan!.isNotEmpty) {
        bytes += generator.text("${packString}");
      }

      bytes += generator.emptyLines(1);
    }

    bytes += generator.hr();

    bytes += generator.text("Total Harga",
        styles: PosStyles(align: PosAlign.left, bold: true));
    bytes += generator.text("Rp.${widget.data!.totalHarga}",
        styles: PosStyles(align: PosAlign.right, bold: true));

    bytes += generator.text("Total Ongkir",
        styles: PosStyles(align: PosAlign.left, bold: true));
    bytes += generator.text("Rp.${widget.data!.totalOngkosKirim}",
        styles: PosStyles(align: PosAlign.right, bold: true));

    bytes += generator.hr();

    bytes += generator.text("Total Belanja",
        styles: PosStyles(align: PosAlign.left, bold: true));
    bytes += generator.text("Rp.${widget.data!.totalBelanja}",
        styles: PosStyles(align: PosAlign.right, bold: true));

    bytes += generator.hr(ch: '=', linesAfter: 1);

    // ticket.feed(2);
    bytes += generator.text('Terimakasih!',
        styles: PosStyles(align: PosAlign.center, bold: true));

    bytes += generator.text("TOKO SM ONLINE",
        styles: PosStyles(align: PosAlign.center), linesAfter: 1);

    bytes += generator.cut();

    return bytes;
  }

  Future<void> printTicket() async {
    bool isConnected = await PrintBluetoothThermal
        .connectionStatus; //BluetoothThermalPrinter.connectionStatus;
    if (isConnected) {
      List<int> bytes = await getTicket();
      final result = await PrintBluetoothThermal.writeBytes(
          bytes); // BluetoothThermalPrinter.writeBytes(bytes);
      print("Print $result");
    } else {
      //Hadnle Not Connected Senario
    }
  }

  Widget cartDynamicCard(Produk data) {
    // Pack State
    var packString = "";
    if (data.jumlahMultisatuan!.isNotEmpty) {
      for (var i = 0; i < data.jumlahMultisatuan!.length; i++) {
        var jumlah = data.jumlahMultisatuan?[i];
        var unit = data.multisatuanUnit?[i];

        print("PackString : $jumlah");
        print("PackString : $unit");

        if (jumlah! > 0) {
          packString += "(${jumlah} ${unit})".toUpperCase();
        }
      }
    }

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
                image: data.imageUrl.toString().replaceAll(
                    "https://tokosm.online", "http://103.127.132.116"),
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
                    if (data.multisatuanUnit!.isNotEmpty) ...[
                      Text(
                        packString,
                        style: poppins.copyWith(
                            fontSize: 10,
                            fontWeight: regular,
                            color: Colors.grey,
                            overflow: TextOverflow.ellipsis),
                        maxLines: 2,
                      ),
                    ],
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
                "${data!.metodePembayaran}".toUpperCase(),
                style: poppins.copyWith(
                  color: backgroundColor1,
                ),
              ),
            ],
          ),

          if ("${data.bankTransfer}" != "") ...[
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
                  "${data.bankTransfer}",
                  style: poppins.copyWith(
                    color: backgroundColor1,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                width: double.infinity,
                child: GestureDetector(
                  onTap: () async {
                    _getPaymentInfo();
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(
                        Icons.info_rounded,
                        color: Colors.grey,
                        size: 15,
                      ),
                      Text(
                        ' Lihat Cara Bayar',
                        style: poppins.copyWith(
                            fontSize: 12,
                            fontWeight: semiBold,
                            color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],

          // const SizedBox(
          //   height: 10,
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Text(
          //       "No Rekening",
          //       style: poppins.copyWith(
          //         color: Colors.black,
          //       ),
          //     ),
          //     Text(
          //       "${data!.norekeningTransfer}",
          //       style: poppins.copyWith(
          //         color: backgroundColor1,
          //       ),
          //     ),
          //   ],
          // ),
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

  Widget showPrintOption() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      color: Colors.white,
      child: StatefulBuilder(
          builder: (BuildContext context, StateSetter stateSetter) {
        return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
          // Keyboard Dismiss
          if (isKeyboardVisible == false) {}

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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Pilih Printer",
                          style: poppins.copyWith(
                              fontSize: 18,
                              fontWeight: semiBold,
                              color: backgroundColor1),
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          color: backgroundColor3,
                          iconSize: 18.0, // You can adjust the size if needed
                          onPressed: () async {
                            await getBluetooth();
                            stateSetter(() {});
                          },
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    if (availableBluetoothDevices.isNotEmpty) ...[
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        height: 200,
                        child: ListView.builder(
                          itemCount: availableBluetoothDevices.isNotEmpty
                              ? availableBluetoothDevices.length
                              : 0,
                          itemBuilder: (context, index) {
                            return ListTile(
                              onTap: () async {
                                if (availableBluetoothDevices.isNotEmpty) {
                                  String select =
                                      availableBluetoothDevices[index];
                                  List list = select.split("#");
                                  String name = list[0];
                                  String mac = list[1];
                                  print("mac address BLE : ${mac} : ${name}");
                                  setConnect(mac);
                                  // Navigator.pop(context);
                                  showToast(
                                      "Membuat koneksi ke ${availableBluetoothDevices[index]}");
                                }
                              },
                              title:
                                  Text('${availableBluetoothDevices[index]}'),
                              subtitle: const Text("Klik untuk cetak resi"),
                            );
                          },
                        ),
                      ),
                    ] else ...[
                      Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'Tidak ada perangkat terkoneksi, hidupkan bluetooth untuk melakukan koneksi dengan printer.',
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: semiBold,
                                    color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: backgroundColor3,
                              ),
                              onPressed: () async {
                                await getBluetooth();
                                stateSetter(() {});
                              },
                              child: const Text(
                                'Refresh',
                                style: TextStyle(color: Colors.white),
                              ),
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

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Izin diperlukan'),
          content: Text(
              'Aplikasi ini perlu mengakses fitur nearby devices untuk melakukan koneksi dengan printer. Izinkan aplikasi untuk mengakses nearby devices.'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await openAppSettings();
              },
              child: Text('Buka Pengaturan'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batalkan'),
            ),
          ],
        );
      },
    );
  }

  void showToast(String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.lightGreen,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Center(
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (await Permission.bluetoothScan
                                    .request()
                                    .isGranted &&
                                await Permission.bluetoothConnect
                                    .request()
                                    .isGranted) {
                              print("Bluetooth permission Ok");
                              await getBluetooth();
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
                                      child: showPrintOption(),
                                    );
                                  }).then((value) => setState(() {
                                    // _getCartList();
                                  }));
                            } else {
                              // Handle the case where permissions are denied
                              print("Bluetooth permission denied");
                              _showPermissionDialog();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              shape: StadiumBorder(
                                  side: BorderSide(
                                      width: 1, color: backgroundColor3)),
                              backgroundColor: backgroundColor3),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.print,
                                color: Colors.white,
                              ),
                              Text(
                                ' Cetak Resi',
                                style: poppins.copyWith(
                                    fontWeight: semiBold, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (widget.data?.pembatalan != 1 &&
                      widget.data?.status == 0) ...[
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 10, left: 20, right: 20),
                      child: Center(
                        child: SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    titleTextStyle: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    title: const Text('Transaksi'),
                                    content: const Text(
                                        'Yakin membatalkan transaksi?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                          // await openAppSettings();
                                          var token =
                                              await authProvider.getLoginData();
                                          if (await settingsProvider
                                              .updateTransaksi(
                                                  noinvoice: widget
                                                      .data!.noInvoice
                                                      .toString(),
                                                  status: "5",
                                                  token: token.toString())) {
                                            showToast(
                                                "Pembatalan Transaksi berhasil diajukan");
                                            Navigator.pop(context);
                                          } else {
                                            showToast(
                                                "Pembatalan Transaksi gagal");
                                          }
                                        },
                                        child: const Text('Iya'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Tidak'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(
                                    side: BorderSide(
                                        width: 1, color: Colors.red)),
                                backgroundColor: Colors.red),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  SolarIconsBold.trashBin2,
                                  color: Colors.white,
                                ),
                                Text(
                                  ' Batalkan Transaksi',
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
