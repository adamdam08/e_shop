import 'package:e_shop/provider/auth_provider.dart';
import 'package:e_shop/provider/customer_provider.dart';
import 'package:e_shop/ui/customer/add_customer_page.dart';
import 'package:e_shop/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:rounded_image_with_textbg/rounded_image_with_textbg.dart';
import 'package:solar_icons/solar_icons.dart';

import 'customer_transact_page.dart';

class Customer extends StatefulWidget {
  const Customer({super.key});

  @override
  State<Customer> createState() => _CustomerState();
}

class _CustomerState extends State<Customer> {
  List<Map<dynamic, dynamic>> _customerList = [];
  List<Map<dynamic, dynamic>> customerListFiltered = [];
  TextEditingController searchTextController = TextEditingController();
  bool isLoading = false;
  String _sortData = "nama";
  String _filterData = "asc";

  @override
  void initState() {
    super.initState();

    // Get Customer List
    _getCustomer();
  }

  void _getCustomer() async {
    setState(() {
      isLoading = true;
    });

    print("Filter data $_filterData");
    print("Sort data $_sortData");

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final customerProvider =
        Provider.of<CustomerProvider>(context, listen: false);
    // Get data from SharedPref
    var data = await authProvider.getLoginData();
    if (data?.token != null) {
      if (await customerProvider.getListCustomerData(
        token: data!.token.toString(),
        sort: _sortData,
        order: _filterData,
      )) {
        _customerList.clear();
        _customerList = customerProvider.myCustomer;
        customerListFiltered = _customerList;
        print("Customer Refreshesed");
        if (context.mounted) {
          setState(() {});
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
              backgroundColor: Colors.red,
              content: Text(
                'Gagal Mendapatkan Daftar Pelanggan!',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  DateTime? lastPressed;
  Future<bool> onWillPop() async {
    final now = DateTime.now();
    final maxDuration = Duration(seconds: 2);

    if (lastPressed == null || now.difference(lastPressed!) > maxDuration) {
      lastPressed = now;
      Fluttertoast.showToast(
        msg: 'Tekan sekali lagi untuk keluar',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
      );
      return Future.value(false);
    }
    return Future.value(true);
  }

  Future<void> _handleRefresh() async {
    // Simulate network fetch or database query
    // await Future.delayed(Duration(seconds: 2));
    // Update the list of items and refresh the UI
    setState(() {
      isLoading = true;
    });

    // Get Customer List
    _getCustomer();
  }

  @override
  Widget build(BuildContext context) {
    CustomerProvider customerProvider = Provider.of<CustomerProvider>(context);
    print("Customer Length : ${customerListFiltered.length}");

    Widget customerDynamicCardVertical(Map<dynamic, dynamic> myCustomer) {
      print("Update Customer ${myCustomer}");
      return GestureDetector(
        onTap: () {
          print("Data Customer clicked : ${myCustomer}");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CustomerTransactPage(
                        myCustomer: myCustomer,
                      )));
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
                        myCustomer["nama_lengkap"],
                        style: poppins.copyWith(
                            fontWeight: regular,
                            color: backgroundColor3,
                            overflow: TextOverflow.ellipsis),
                        maxLines: 2,
                      ),
                      Text(
                        myCustomer["telp"],
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
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          height: 50,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.white,
          ),
          child: TextFormField(
            controller: searchTextController,
            textInputAction: TextInputAction.search,
            obscureText: false,
            cursorColor: Colors.grey,
            maxLines: 1,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              prefixIconColor: Colors.grey,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Colors.white, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: backgroundColor3, width: 1),
              ),
              hintText: "Cari pelanggan disini...",
              hintStyle:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
              alignLabelWithHint: true,
            ),
            onChanged: (query) {
              if (context.mounted) {
                setState(() {
                  customerListFiltered = _customerList
                      .where((element) => element["nama_lengkap"]
                          .toLowerCase()
                          .contains(query.toLowerCase()))
                      .toList();
                  print("Search Customer q : ${_customerList}");
                });
              }
            },
          ),
        ),
      );
    }

    Widget filter() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                print("Showdialog : $_sortData");
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const SizedBox(height: 10),
                          Text(
                            'Urutkan $_sortData berdasarkan',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                              height:
                                  10), // Add some spacing between text and buttons
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  _filterData = "asc";
                                  Navigator.pop(context);
                                  setState(() {
                                    _handleRefresh();
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: StadiumBorder(
                                    side: BorderSide(
                                      width: 1,
                                      color: backgroundColor3,
                                    ),
                                  ),
                                  backgroundColor: _filterData == "asc"
                                      ? backgroundColor1
                                      : backgroundColor3,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      SolarIconsOutline.sortFromTopToBottom,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      ' Terkecil - Terbesar',
                                      style: poppins.copyWith(
                                          fontWeight: semiBold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  _filterData = "desc";
                                  Navigator.pop(context);
                                  setState(() {
                                    _handleRefresh();
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: StadiumBorder(
                                    side: BorderSide(
                                      width: 1,
                                      color: backgroundColor3,
                                    ),
                                  ),
                                  backgroundColor: _filterData == "desc"
                                      ? backgroundColor1
                                      : backgroundColor3,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      SolarIconsOutline.sortFromBottomToTop,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      ' Terbesar - Terkecil',
                                      style: poppins.copyWith(
                                          fontWeight: semiBold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: backgroundColor3,
                ),
                width: MediaQuery.of(context).size.width * 0.1,
                height: MediaQuery.of(context).size.width * 0.1,
                child: Icon(
                  _filterData == "desc"
                      ? SolarIconsOutline.sortFromBottomToTop
                      : SolarIconsOutline.sortFromTopToBottom,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.02,
            ),
            Container(
              // padding: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width * 0.78,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          setState(() {
                            _sortData = "nama";
                            _handleRefresh();
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          alignment: Alignment.center,
                          color: _sortData == "nama"
                              ? backgroundColor1
                              : backgroundColor3,
                          child: Text(
                            "Nama",
                            style: TextStyle(
                              fontWeight: semiBold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          setState(() {
                            _sortData = "transaksi";
                            _handleRefresh();
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          alignment: Alignment.center,
                          color: _sortData == "transaksi"
                              ? backgroundColor1
                              : backgroundColor3,
                          child: Text(
                            "Transaksi",
                            style: TextStyle(
                              fontWeight: semiBold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          setState(() {
                            _sortData = "nominal";
                            _handleRefresh();
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          alignment: Alignment.center,
                          color: _sortData == "nominal"
                              ? backgroundColor1
                              : backgroundColor3,
                          child: Text(
                            "Nominal",
                            style: TextStyle(
                              fontWeight: semiBold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return WillPopScope(
      onWillPop: onWillPop,
      child: Container(
          padding: const EdgeInsets.only(bottom: 10),
          child: isLoading
              ? Container(
                  width: double.infinity,
                  height: double.infinity,
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
                )
              : Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      color: backgroundColor3,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Pelanggan",
                                  style: poppins.copyWith(
                                      fontSize: 20,
                                      fontWeight: semiBold,
                                      color: Colors.white),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      customerProvider.selectedCity = "-";
                                    });
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const CustomerInformation(
                                                data: {},
                                                isEditable: true,
                                              )),
                                    ).then((value) => setState(() {
                                          _getCustomer();
                                        }));
                                  },
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.05,
                                    child: const Icon(
                                      SolarIconsOutline.userPlus,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          searchbar()
                        ],
                      ),
                    ),
                    if (customerListFiltered.isEmpty) ...[
                      Expanded(
                          child: RefreshIndicator(
                        onRefresh: _handleRefresh,
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
                              style: poppins.copyWith(
                                  fontWeight: regular, fontSize: 20),
                            ),
                          ],
                        )),
                      ))
                    ] else ...[
                      filter(),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: _handleRefresh,
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            itemCount: customerListFiltered.length,
                            itemBuilder: (BuildContext context, int index) {
                              return customerDynamicCardVertical(
                                  customerListFiltered[index]);
                            },
                          ),
                        ),
                      ),
                    ]
                  ],
                )),
    );
  }
}
