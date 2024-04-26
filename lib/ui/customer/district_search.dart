import 'dart:convert';

import 'package:e_shop/models/settings/district_model.dart';
import 'package:e_shop/provider/customer_provider.dart';
import 'package:e_shop/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rounded_image_with_textbg/rounded_image_with_textbg.dart';

import '../customer/add_customer_page.dart';

class DistrictSearch extends StatefulWidget {
  const DistrictSearch({Key? key}) : super(key: key);

  @override
  State<DistrictSearch> createState() => _DistrictSearchState();
}

class _DistrictSearchState extends State<DistrictSearch> {
  //dummy data

  TextEditingController searchTextController = TextEditingController();

  List<String?> districtList = [];
  List<String?> districtListFiltered = [];

  Future<List<String?>> loadDistrict() async {
    String data = await rootBundle.loadString('assets/district.json');
    print("Assets : ${json.decode(data)}");
    DistrictModel districtData = DistrictModel.fromJson(json.decode(data));
    districtList = districtData.districtData!.map((e) => e.value).toList();
    return districtData.districtData!.map((e) => e.value).toList();
  }

  void getDistrictList() async {
    var district = await loadDistrict();
    setState(() {
      districtListFiltered = district;
    });
    print("data ${district}");
  }

  @override
  void initState() {
    super.initState();

    getDistrictList();
  }

  @override
  Widget build(BuildContext context) {
    CustomerProvider customerProvider = Provider.of<CustomerProvider>(context);

    Widget DistrictDynamicCardVertical(String district) {
      return GestureDetector(
        onTap: () {
          customerProvider.selectedCity = district;
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
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        district,
                        style: poppins.copyWith(
                            overflow: TextOverflow.ellipsis,
                            fontWeight: semiBold,
                            fontSize: 15,
                            color: backgroundColor1),
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
            hintText: "Cari wilayah disini...",
            hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            alignLabelWithHint: true,
          ),
          onChanged: (query) {
            setState(() {
              setState(() {
                districtListFiltered = districtList
                    .where((element) =>
                        element!.toLowerCase().contains(query.toLowerCase()))
                    .toList();
                print("District List q : ${districtListFiltered}");
              });
            });
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
              if (districtListFiltered.isEmpty) ...[
                Expanded(
                    child: Center(
                        child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.pin_drop,
                      size: 48,
                    ),
                    Text(
                      "Wilayah tidak ditemukan",
                      style:
                          poppins.copyWith(fontWeight: regular, fontSize: 20),
                    ),
                  ],
                )))
              ] else ...[
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    itemCount: districtListFiltered.length,
                    itemBuilder: (BuildContext context, int index) {
                      return DistrictDynamicCardVertical(
                          districtListFiltered[index].toString());
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
