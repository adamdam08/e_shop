import 'package:e_shop/models/customer/customer_address_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rounded_image_with_textbg/rounded_image_with_textbg.dart';

import '../../provider/auth_provider.dart';
import '../../provider/customer_provider.dart';
import '../../theme/theme.dart';
import '../customer/customer_information.dart';

class AddressSearch extends StatefulWidget {
  const AddressSearch({super.key});

  @override
  State<AddressSearch> createState() => _AddressSearchState();
}

class _AddressSearchState extends State<AddressSearch> {
  //dummy data
  CustomerAddressModel? customerListFiltered ;
  TextEditingController searchTextController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CustomerProvider customerProvider = Provider.of<CustomerProvider>(context, listen: false);
    _getCustomerList();
  }
  void _getCustomerList() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    CustomerProvider customerProvider = Provider.of<CustomerProvider>(context, listen: false);
    var data = await authProvider.getLoginData();
    if (await customerProvider.getListCustomerAddress(id: customerProvider.selectCustomer.toString(), token:  data!.token.toString())) {} else {}
  }

  @override
  Widget build(BuildContext context) {
    CustomerProvider customerProvider = Provider.of<CustomerProvider>(context);

    if(customerProvider.customerAddressList != null){
      customerListFiltered = customerProvider.customerAddressList;
      customerListFiltered?.addressData = customerListFiltered?.addressData?.where((element) => element.namaAlamat.toString().toLowerCase().contains(searchTextController.text.toLowerCase())).toList();
    }

    Widget customerDynamicCardVertical(AddressData myCustomer) {
      return GestureDetector(
        onTap: () {
          customerProvider.selectAddress = myCustomer.id;
          print("customerId nya adalah: ${customerProvider.selectAddress}");
          Navigator.pop(context);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: ClipOval(
                  clipBehavior: Clip.antiAlias,
                  // borderRadius: BorderRadius.circular(8),
                  child: RoundedImageWithTextAndBG(
                    radius: 20,
                    uniqueId: myCustomer.namaPenerima,
                    image: '',
                    text: myCustomer.namaPenerima.toString(),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        myCustomer.namaAlamat.toString(),
                        style: poppins.copyWith(
                            overflow: TextOverflow.ellipsis,
                            fontWeight: semiBold,
                            fontSize: 18,
                            color: backgroundColor1),
                        maxLines: 2,
                      ),
                      Text(
                        myCustomer.alamatLengkap.toString(),
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

    Widget searchbar() {
      return Container(
        height: 50,
        margin: const EdgeInsets.only(bottom: 10),
        child: TextField(
          controller: searchTextController,
          textInputAction: TextInputAction.search,
          obscureText: false,
          cursorColor: Colors.grey,
          maxLines: 1,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            prefixIconColor: Colors.grey,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              borderSide: BorderSide(color: Colors.red, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              borderSide: BorderSide(color: Colors.green, width: 1),
            ),
            hintText: "Cari alamat disini...",
            hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            alignLabelWithHint: true,
          ),
          onChanged: (query) {
            setState(() {});
          },
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        top: true,
        left: true,
        right: true,
        bottom: true,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          color: Colors.white,
          child: Column(
            children: [
              searchbar(),
              if (customerListFiltered!.addressData!.isEmpty) ...[
                Expanded(
                    child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.account_circle_outlined,
                              size: 48,
                            ),
                            Text(
                              "Pelanggan tidak ditemukan",
                              style:
                              poppins.copyWith(fontWeight: regular, fontSize: 20),
                            ),
                          ],
                        )))
              ] else ...[
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    itemCount: customerListFiltered!.addressData!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return customerDynamicCardVertical(
                          customerListFiltered!.addressData![index]);
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
