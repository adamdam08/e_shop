import 'package:e_shop/customer_information.dart';
import 'package:e_shop/provider/customer_provider.dart';
import 'package:e_shop/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rounded_image_with_textbg/rounded_image_with_textbg.dart';

class Customer extends StatefulWidget {
  const Customer({super.key});

  @override
  State<Customer> createState() => _CustomerState();
}

class _CustomerState extends State<Customer> {
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
    customerList = customerProvider.myCustomer;
    customerListFiltered = customerProvider.myCustomer;

    // customerList = dummyCustomer;
    // customerListFiltered = dummyCustomer;

    Widget customerDynamicCardVertical(Map<dynamic, dynamic> myCustomer) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CustomerInformation(
                      data: myCustomer,
                      isEditable: false,
                    )),
          );
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
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.78,
              height: 50,
              decoration: const BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
              ),
              child: TextField(
                textInputAction: TextInputAction.search,
                obscureText: false,
                cursorColor: Colors.grey,
                maxLines: 1,
                // focusNode: searchBarFocusNode,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  prefixIconColor: Colors.grey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide: BorderSide(color: Colors.white, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide: BorderSide(color: Colors.green, width: 1),
                  ),
                  hintText: "Cari pelanggan disini...",
                  hintStyle:
                      TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                  alignLabelWithHint: true,
                ),
                onChanged: (query) {
                  setState(() {
                    customerListFiltered.clear();

                    // List<Map<dynamic, dynamic>> filterList = customerList
                    //     .where((element) => element["name"]
                    //         .toLowerCase()
                    //         .contains(query.toLowerCase()))
                    //     .toList();

                    // print("SET DATA " + filterList.toString());
                    print("SET DATA " + customerList.toString());

                    // print("SET DATA TESTING" +
                    //     customerList[0]["name"]
                    //         .toLowerCase()
                    //         .contains(query.toLowerCase().toString()));

                    // customerListFiltered = customerList
                    //     .where((element) => element["name"]
                    //         .toLowerCase()
                    //         .contains(query.toLowerCase()))
                    //     .toList();
                  });
                },
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CustomerInformation(
                            data: {},
                            isEditable: true,
                          )),
                ).then((value) => setState(() {}));
              },
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                width: MediaQuery.of(context).size.width * 0.05,
                child: const Icon(
                  Icons.person_add,
                ),
              ),
            ),
          ],
        ),
      );
    }

    print("SET INIT raw" + customerProvider.myCustomer.toString());
    print("SET INIT Data" + customerList.toString());
    print("SET INIT Filter" + customerListFiltered.toString());

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
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
                  style: poppins.copyWith(fontWeight: regular, fontSize: 20),
                ),
              ],
            )))
          ] else ...[
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                children: [
                  for (int i = 0; i < customerListFiltered.length; i++)
                    customerDynamicCardVertical(customerListFiltered[i])
                ],
              ),
            )
          ]
        ],
      ),
    );
  }
}