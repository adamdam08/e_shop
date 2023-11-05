import 'package:e_shop/provider/customer_provider.dart';
import 'package:e_shop/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rounded_image_with_textbg/rounded_image_with_textbg.dart';

class CustomerSearch extends StatefulWidget {
  const CustomerSearch({Key? key}) : super(key: key);

  @override
  State<CustomerSearch> createState() => _CustomerSearchState();
}

class _CustomerSearchState extends State<CustomerSearch> {
  //dummy data
  List<Map> dummyCustomer = [
    {
      "id": 1,
      "name": "User 1",
      "phone": "0888888888",
      "address": "Testing alamat"
    },
    {
      "id": 2,
      "name": "User dua",
      "phone": "0888888878",
      "address": "Testing alamat 2"
    }
  ];

  FocusNode searchBarFocusNode = FocusNode();
  List<Map<dynamic, dynamic>> customerListFiltered = [];
  List<Map<dynamic, dynamic>> customerList = [];

  @override
  void initState() {
    super.initState();
    searchBarFocusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      print("Searchbar Clicked");
    });
  }

  @override
  Widget build(BuildContext context) {
    CustomerProvider customerProvider = Provider.of<CustomerProvider>(context);

    // customerProvider.myCustomer.addAll(dummyCustomer);
    // customerList =  customerProvider.myCustomer;
    // customerListFiltered = customerProvider.myCustomer;

    customerList = dummyCustomer;
    customerListFiltered = dummyCustomer;

    Widget customerDynamicCardVertical(Map<dynamic, dynamic> myCustomer) {
      return GestureDetector(
        onTap: () {
          print((myCustomer["id"] is int));
          // customerProvider.selectCustomer = 1; // myCustomer["id"];
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
                    uniqueId: myCustomer["name"],
                    image: '',
                    text: myCustomer["name"],
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
                        myCustomer["name"],
                        style: poppins.copyWith(
                            overflow: TextOverflow.ellipsis,
                            fontWeight: semiBold,
                            fontSize: 18,
                            color: backgroundColor1),
                        maxLines: 2,
                      ),
                      Text(
                        myCustomer["address"],
                        style: poppins.copyWith(
                            fontWeight: regular,
                            color: backgroundColor3,
                            overflow: TextOverflow.ellipsis),
                        maxLines: 2,
                      ),
                      Text(
                        myCustomer["phone"],
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
      return const SizedBox(
        width: 500,
        child: TextField(
          textInputAction: TextInputAction.search,
          obscureText: false,
          cursorColor: Colors.grey,
          maxLines: 1,
          // focusNode: searchBarFocusNode,
          decoration: InputDecoration(
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
              if (customerProvider.myCustomer.isEmpty) ...[
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
                      "Customer Not Found",
                      style:
                          poppins.copyWith(fontWeight: regular, fontSize: 20),
                    ),
                  ],
                )))
              ] else ...[
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    children: [
                      for (int i = 0;
                          i < customerProvider.myCustomer.length;
                          i++)
                        customerDynamicCardVertical(
                            customerProvider.myCustomer[i])
                    ],
                  ),
                )
              ],
            ],
          ),
        ),
      ),
    );
  }
}
