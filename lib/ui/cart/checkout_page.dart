import 'package:e_shop/models/settings/shipping_model.dart';
import 'package:e_shop/provider/cart_provider.dart';
import 'package:e_shop/provider/customer_provider.dart';
import 'package:e_shop/provider/settings_provider.dart';
import 'package:e_shop/theme/theme.dart';
import 'package:e_shop/ui/cart/address_search.dart';
import 'package:e_shop/ui/cart/shipping_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../provider/auth_provider.dart';
import '../product/detail_item.dart';
import 'cart.dart';
import 'customer_search.dart';

class CheckoutPage extends StatefulWidget {
  CheckoutPage({Key? key}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String selectedCustomer = "Pilih customer";
  String selectedAddress = "Pilih Alamat";
  String? customerID;
  int _totalData = 0;
  String selectedShip = "Pilih Metode Pengiriman";
  String selectedShipPrice = "-";
  String? shipId;

  @override
  void initState() {
    super.initState();

    _setCustomerData();

    _getTotalData();
  }

  void _setCustomerData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final customerProvider =
        Provider.of<CustomerProvider>(context, listen: false);

    List<Map<dynamic, dynamic>> customerListFiltered = [];
    customerListFiltered = customerProvider.myCustomer;
    customerListFiltered = customerListFiltered
        .where((element) =>
            element["id"] == customerProvider.selectCustomer.toString())
        .toList();

    //Jika list customer kosong
    if (customerProvider.myCustomer.isEmpty) {
      selectedCustomer = "Pilih customer";
    } else {
      if (customerListFiltered.isNotEmpty) {
        if (await customerProvider.getListCustomerAddress(
            id: customerID.toString(),
            token: authProvider.user.token.toString())) {
          customerID = customerListFiltered.first["id"]; // Set Customer ID

          if (customerProvider.customerAddressList!.addressData!.isEmpty) {
            selectedAddress = "Pilih Alamat";
            // selectedCustomer = customerListFiltered.first["nama_lengkap"];
            selectedCustomer = "-";
          } else {
            if (customerProvider.selectAddress != null) {
              var selectedData = customerProvider
                  .customerAddressList!.addressData!
                  .where((element) =>
                      element.id == customerProvider.selectAddress);
              selectedAddress = selectedData.first.alamatLengkap.toString();
              selectedCustomer = selectedData.first.namaAlamat.toString();
            } else {
              customerProvider.selectAddress =
                  customerProvider.customerAddressList!.addressData!.first.id;
              selectedAddress = customerProvider
                  .customerAddressList!.addressData!.first.alamatLengkap
                  .toString();
              selectedCustomer = customerProvider
                  .customerAddressList!.addressData!.first.namaAlamat
                  .toString();
            }
          }
        } else {
          selectedAddress = "-";
          selectedCustomer = "-";
        }
      } else {
        selectedCustomer = "-";
      }

      //reset customer state
      if (customerProvider.customerAddressList!.addressData!.isEmpty &&
          customerProvider.selectAddress != null) {
        customerProvider.selectAddress = null;
        setState(() {});
      } else {
        setState(() {});
      }

      print(
          "Selected Address isEmpty : ${customerProvider.customerAddressList!.addressData!.isEmpty}");
      print("Selected Address : ${customerProvider.selectAddress}");
    }
  }

  void _getTotalData() {
    CartProvider cartProduct =
        Provider.of<CartProvider>(context, listen: false);
    var data = cartProduct.selectedProducts;
    for (int i = 0; i < cartProduct.selectedProducts.length; i++) {
      var data2 = data[i];
      _totalData = _totalData + int.tryParse(data2["total_harga"].toString())!;
    }
    print("Total data : ${_totalData}");
  }

  void _setShipData() async {
    final settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);
    final customerProvider =
        Provider.of<CustomerProvider>(context, listen: false);

    shipId = settingsProvider.selectedShip.toString();

    List<ShipData>? checkShipData = settingsProvider.shippingList?.shipData
        ?.where((element) => element.id.toString() == shipId)
        .toList();

    if (checkShipData != null && customerProvider.selectAddress != null) {
      selectedShip = checkShipData.first.namaKurir.toString();
      selectedShipPrice = "15000";
    } else {
      selectedShip = "Pilih Metode Pengiriman";
      selectedShipPrice = "-";
      shipId = null;
    }

    setState(() {});
  }

  void _getShippingList() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);

    final customerProvider =
        Provider.of<CustomerProvider>(context, listen: false);

    var data = await authProvider.getLoginData();
    if (await settingsProvider.getShippingList(
        token: data!.token.toString(),
        cabangId: authProvider.user.data.cabangId.toString())) {
      print("Shipping list ${settingsProvider.shippingList.toString()}");

      if (customerProvider.selectAddress != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ShippingSearch()),
        ).then((value) {
          _setShipData();
        });
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    CartProvider cartProduct = Provider.of<CartProvider>(context);
    CustomerProvider customerProvider = Provider.of<CustomerProvider>(context);
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);

    Widget cartDynamicCard(int index) {
      var data = cartProduct.selectedProducts[index];
      return GestureDetector(
        onTap: () {},
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
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
                  image: data["image_url"],
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
                        data["nama_produk"].toString(),
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
                        "${data["jumlah"].toString()} x Rp.${data["harga"].toString()}",
                        style: poppins.copyWith(
                            fontWeight: regular,
                            color: backgroundColor3,
                            overflow: TextOverflow.ellipsis),
                        maxLines: 2,
                      ),
                      Text(
                        "Total : Rp.${data["total_harga"]}",
                        style: poppins.copyWith(
                            fontWeight: regular,
                            color: backgroundColor3,
                            overflow: TextOverflow.ellipsis),
                        maxLines: 2,
                      ),
                      if (data["catatan"] != "")
                        Text(
                          "Catatan : ' ${cartProduct.cartList.listData!.first.cartData![index].catatan} '",
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

    Widget selectAddressCard() {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddressSearch()),
          ).then((value) {
            shipId = null;
            _setCustomerData();
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Alamat Pengiriman",
                style: poppins.copyWith(
                    fontWeight: regular,
                    fontSize: 16,
                    overflow: TextOverflow.ellipsis),
                maxLines: 1,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    color: Colors.grey, width: 1, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(10),
              ),
              width: double.infinity,
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          selectedAddress,
                          style: poppins.copyWith(
                              fontWeight: regular,
                              fontSize: 14,
                              overflow: TextOverflow.ellipsis),
                          maxLines: 1,
                        ),
                        Text(
                          selectedCustomer,
                          style: poppins.copyWith(
                              fontWeight: thin,
                              fontSize: 10,
                              overflow: TextOverflow.ellipsis),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget selectKurirCard() {
      return GestureDetector(
        onTap: () {
          _getShippingList();

          print("customer select address ${customerProvider.selectAddress}");
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Pilih Pengiriman",
                style: poppins.copyWith(
                    fontWeight: regular,
                    fontSize: 16,
                    overflow: TextOverflow.ellipsis),
                maxLines: 1,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    color: Colors.grey, width: 1, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(10),
              ),
              width: double.infinity,
              child: Row(
                children: [
                  const Icon(
                    Icons.local_shipping,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          selectedShip,
                          style: poppins.copyWith(
                              fontWeight: regular,
                              fontSize: 14,
                              overflow: TextOverflow.ellipsis),
                          maxLines: 1,
                        ),
                        Text(
                          "Rp. $selectedShipPrice",
                          style: poppins.copyWith(
                              fontWeight: thin,
                              fontSize: 10,
                              overflow: TextOverflow.ellipsis),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                  ),
                ],
              ),
            ),
          ],
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
                  "Total Item",
                  style: poppins.copyWith(
                    color: Colors.black,
                  ),
                ),
                Text(
                  "${cartProduct.selectedProducts.length} Item",
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
                  "Rp. $_totalData",
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
                  settingsProvider.selectedShip != null
                      ? "Rp. $selectedShipPrice "
                      : "Rp. -",
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
                  "Rp. ${_totalData + 15000}",
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
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              color: backgroundColor3,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                    "Pengiriman",
                    style: poppins.copyWith(
                        fontSize: 20,
                        fontWeight: semiBold,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  selectAddressCard(),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Data Pembelian",
                      style: poppins.copyWith(
                          fontSize: 16,
                          fontWeight: regular,
                          color: Colors.black),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  for (int i = 0;
                      i < cartProduct.selectedProducts.length;
                      i++) ...[
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: cartDynamicCard(i),
                    )
                  ],
                  selectKurirCard(),
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
                  cartSummaryCard(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Center(
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            String? selectedName;
                            String? selectedAddress;

                            if (customerProvider.selectAddress != null) {
                              var selectedData = customerProvider
                                  .customerAddressList!.addressData!
                                  .where((element) =>
                                      element.id ==
                                      customerProvider.selectAddress);
                              selectedAddress =
                                  selectedData.first.alamatLengkap.toString();
                              selectedName =
                                  selectedData.first.namaPenerima.toString();
                            } else {
                              customerProvider.selectAddress = customerProvider
                                  .customerAddressList!.addressData!.first.id;
                              selectedAddress = customerProvider
                                  .customerAddressList!
                                  .addressData!
                                  .first
                                  .alamatLengkap
                                  .toString();
                              selectedName = customerProvider
                                  .customerAddressList!
                                  .addressData!
                                  .first
                                  .namaPenerima
                                  .toString();
                            }

                            // Ship ID
                            List<ShipData>? checkShipData = settingsProvider
                                .shippingList?.shipData
                                ?.where((element) =>
                                    element.id.toString() == shipId)
                                .toList();

                            var data = {
                              "pelanggan_id": customerID,
                              "cabang_id": authProvider.user.data.cabangId,
                              "kurir_id": shipId,
                              "pengiriman_id": customerProvider
                                  .selectAddress, // id alamat pengiriman
                              "nama_kurir":
                                  checkShipData!.first.namaKurir.toString(),
                              "total_harga": _totalData,
                              "total_ongkos_kirim": 15000,
                              "total_belanja": _totalData + 15000,
                              "metode_pembayaran": "cash",
                              "nama_penerima":
                                  selectedName, // nama dari id alamat pengiriman
                              "alamat_penerima":
                                  selectedAddress, // alamat dari id alamat pengiriman
                              "produk": cartProduct.selectedProducts.toString()
                            };
                            print(data);
                          },
                          style: ElevatedButton.styleFrom(
                              shape: StadiumBorder(
                                  side: BorderSide(
                                      width: 1, color: backgroundColor3)),
                              backgroundColor:
                                  (customerProvider.selectAddress != null &&
                                          customerProvider.customerAddressList!
                                              .addressData!.isNotEmpty &&
                                          settingsProvider.selectedShip != null)
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
                                ' Pilih Pembayaran',
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
