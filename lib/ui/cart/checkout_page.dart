import 'package:e_shop/provider/cart_provider.dart';
import 'package:e_shop/provider/customer_provider.dart';
import 'package:e_shop/theme/theme.dart';
import 'package:e_shop/ui/cart/address_search.dart';
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

  @override
  void initState() {
    super.initState();

    _setCustomerData();

    _getTotalData();
  }

  void _setCustomerData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final customerProvider = Provider.of<CustomerProvider>(context, listen: false);

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
        customerID = customerListFiltered.first["id"];
        if(await customerProvider.getListCustomerAddress(id: customerID.toString(), token: authProvider.user.token.toString())){
          print("Customer List Data ${customerProvider.customerAddressList?.addressData?.first}");
          if(customerProvider.customerAddressList!.addressData!.isEmpty){
            selectedAddress = "Pilih Alamat";
          }else{
            if(customerProvider.selectAddress != null){
              var selectedData = customerProvider.customerAddressList!.addressData!.where((element) => element.id == customerProvider.selectAddress);
              selectedAddress = selectedData.first.alamatLengkap.toString();
              selectedCustomer = selectedData.first.namaAlamat.toString();
            }else{
              selectedAddress = customerProvider.customerAddressList!.addressData!.first.alamatLengkap.toString();
              selectedCustomer = customerProvider.customerAddressList!.addressData!.first.namaAlamat.toString();
            }
            setState(() {});
          }
        }else{
          selectedAddress = "Pilih Alamat";
        }
      } else {
        selectedCustomer = "Pilih customer";
      }
    }
  }

  void _getTotalData() {
    CartProvider cartProduct = Provider.of<CartProvider>(context, listen: false);
    var data = cartProduct.selectedProducts;
    for (int i = 0; i < cartProduct.selectedProducts.length; i++){
      var data2 = data[i];
      _totalData = _totalData + int.tryParse(data2["total_harga"].toString())!;
    }
    print("Total data : ${_totalData}");
  }

  @override
  Widget build(BuildContext context) {
    CartProvider cartProduct = Provider.of<CartProvider>(context);

    Widget cartDynamicCard(int index) {
      var data = cartProduct.selectedProducts[index];
      return GestureDetector(
        onTap: () {},
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
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
                  "https://tokosm.online/uploads/images/${data["image_url"]}",
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

    Widget selectAddressCard(){
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AddressSearch()),
          ).then((value) => () {
            _setCustomerData();
            setState(() {
              print("BO Full Servis 3 Jam ${selectedAddress}");
            });
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

    Widget cartSummaryCard(){
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              color: Colors.grey,
              width: 1,
              style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              crossAxisAlignment:
              CrossAxisAlignment.start,
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
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              crossAxisAlignment:
              CrossAxisAlignment.start,
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
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  "Total Ongkir",
                  style: poppins.copyWith(
                    color: Colors.black,
                  ),
                ),
                Text(
                  "Rp. 15000",
                  style: poppins.copyWith(
                    color: backgroundColor1,
                  ),
                ),
              ],
            ),
            const Padding(
              padding:
              EdgeInsets.symmetric(vertical: 10),
              child: Divider(
                height: 1,
                thickness: 1,
                color: Colors.grey,
              ),
            ),
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              crossAxisAlignment:
              CrossAxisAlignment.start,
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
                    color: backgroundColor1,
                    fontWeight: bold
                  ),
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
                      width:
                          20, //MediaQuery.of(context).size.width * 0.1,
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
                          fontSize: 16, fontWeight: regular, color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  for (int i = 0; i < cartProduct.selectedProducts.length; i++)...[
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: cartDynamicCard(i),
                    )
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
                  cartSummaryCard()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
