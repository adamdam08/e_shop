import 'package:e_shop/provider/customer_provider.dart';
import 'package:e_shop/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rounded_image_with_textbg/rounded_image_with_textbg.dart';

import '../customer/customer_information.dart';

class CustomerSearch extends StatefulWidget {
  const CustomerSearch({Key? key}) : super(key: key);

  @override
  State<CustomerSearch> createState() => _CustomerSearchState();
}

class _CustomerSearchState extends State<CustomerSearch> {
  //dummy data
  List<Map<dynamic, dynamic>> customerListFiltered = [];
  TextEditingController searchTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CustomerProvider customerProvider = Provider.of<CustomerProvider>(context);

    customerListFiltered = customerProvider.myCustomer;
    customerListFiltered = customerListFiltered
        .where((element) => element["nama_lengkap"]
            .toString()
            .toLowerCase()
            .contains(searchTextController.text.toLowerCase()))
        .toList();

    Widget customerDynamicCardVertical(Map<dynamic, dynamic> myCustomer) {
      return GestureDetector(
        onTap: () {
          customerProvider.selectCustomer = int.tryParse(myCustomer["id"])!;
          print("customerId nya adalah: ${customerProvider.selectCustomer}");
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
                    uniqueId: myCustomer["nama_lengkap"],
                    image: '',
                    text: myCustomer["nama_lengkap"],
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
                        myCustomer["nama_lengkap"],
                        style: poppins.copyWith(
                            overflow: TextOverflow.ellipsis,
                            fontWeight: semiBold,
                            fontSize: 18,
                            color: backgroundColor1),
                        maxLines: 2,
                      ),
                      Text(
                        myCustomer["alamat"],
                        style: poppins.copyWith(
                            fontWeight: regular,
                            color: backgroundColor3,
                            overflow: TextOverflow.ellipsis),
                        maxLines: 2,
                      ),
                      Text(
                        myCustomer["tgl_lahir"],
                        style: poppins.copyWith(
                            overflow: TextOverflow.ellipsis,
                            fontWeight: semiBold,
                            color: backgroundColor2),
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
            hintText: "Cari pelanggan disini...",
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
              if (customerListFiltered.isEmpty) ...[
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
                    itemCount: customerListFiltered.length,
                    itemBuilder: (BuildContext context, int index) {
                      return customerDynamicCardVertical(
                          customerListFiltered[index]);
                    },
                  ),
                ),
              ],
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Center(
                  child: SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CustomerInformation(
                                    data: {},
                                    isEditable: true,
                                    isUpdate: false,
                                  )),
                        ).then((value) => setState(() {}));
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
                            Icons.person_add,
                            color: Colors.white,
                          ),
                          Text(
                            ' Tambah Pelanggan Baru',
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
        ),
      ),
    );
  }
}
