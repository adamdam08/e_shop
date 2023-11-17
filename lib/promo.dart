import 'package:e_shop/home.dart';
import 'package:e_shop/search_list.dart';
import 'package:e_shop/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';

import 'category.dart';

class Promo extends StatefulWidget {
  const Promo({super.key});

  @override
  State<Promo> createState() => _PromoState();
}

class _PromoState extends State<Promo> {
  List<String> myCategoryFiltered = [];
  List<String> myCategory = ["Tepung", "Kecap", "Sambal", "Beras", "Mie"];

  FocusNode searchBarFocusNode = FocusNode();
  TextEditingController searchTextController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchBarFocusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      print("Searchbar Clicked ${searchBarFocusNode.hasFocus}");
    });
  }

  @override
  void dispose() {
    super.dispose();
    searchBarFocusNode.removeListener(_onFocusChange);
    searchBarFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print("Searchbar Clicked ${searchBarFocusNode.hasFocus}");
        searchBarFocusNode.removeListener(() {});
        return true;
      },
      child: Container(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
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
                          "Promo",
                          style: poppins.copyWith(
                              fontSize: 20,
                              fontWeight: semiBold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  searchbar()
                ],
              ),
            ),
            if (searchBarFocusNode.hasFocus) ...[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SuggestionListView(
                      myCategory: myCategoryFiltered,
                      searchTextController: searchTextController),
                ),
              )
            ] else ...[
              Expanded(
                child: ListView(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  children: [
                    for (int i = 0; i <= 20; i++)
                      const DynamicCardVertical(text: "1")
                  ],
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget searchbar() {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Colors.white),
      child: TextFormField(
        textInputAction: TextInputAction.search,
        obscureText: false,
        cursorColor: Colors.grey,
        maxLines: 1,
        controller: searchTextController,
        focusNode: searchBarFocusNode,
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
          hintText: "Cari disini...",
          hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
          alignLabelWithHint: true,
        ),
        onFieldSubmitted: (value) {
          if (value != "") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchList(text: value)),
            );
          }
        },
        onChanged: (query) {
          setState(() {
            myCategoryFiltered.clear();
            myCategoryFiltered = myCategory
                .where((element) =>
                    element.toLowerCase().contains(query.toLowerCase()))
                .toList();
          });
        },
      ),
    );
  }
}
