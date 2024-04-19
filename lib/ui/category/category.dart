import 'dart:ffi';

import 'package:e_shop/provider/product_provider.dart';
import 'package:e_shop/theme/theme.dart';
import 'package:e_shop/ui/home/search_list.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  final List<Map> myProducts =
      List.generate(99, (index) => {"id": index, "name": "Product $index"})
          .toList();

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
    if (context.mounted) {
      setState(() {
        print("Searchbar Clicked");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider = Provider.of<ProductProvider>(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          Container(
            color: backgroundColor3,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: Text(
                "Kategori",
                style: poppins.copyWith(
                    fontSize: 24, fontWeight: semiBold, color: Colors.white),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: productProvider.categoryTree!.data!.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    kat1ExpansionTile(
                        title: productProvider.categoryTree?.data![index].kat1
                                .toString() ??
                            "",
                        index: index),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget kat1ExpansionTile({required String title, required int index}) {
    ProductProvider productProvider = Provider.of<ProductProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: ExpandableNotifier(
          child: ScrollOnExpand(
        child: ExpandablePanel(
            header: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            collapsed: const Divider(),
            expanded: Column(
              children: [
                for (var i = 0;
                    i <
                        productProvider
                            .categoryTree!.data![index].child!.length;
                    i++)
                  kat2ExpansionTile(
                    title: productProvider
                        .categoryTree!.data![index].child![i].kat2
                        .toString(),
                    kat1index: index,
                    kat2index: i,
                  ),
              ],
            )),
      )),
    );
  }

  Widget kat2ExpansionTile({
    required String title,
    required int kat1index,
    required int kat2index,
  }) {
    ProductProvider productProvider = Provider.of<ProductProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ExpandableNotifier(
          child: ScrollOnExpand(
        child: ExpandablePanel(
          header: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w400),
            ),
          ),
          collapsed: const Divider(),
          expanded: Column(
            children: [
              for (var i = 0;
                  i <
                      productProvider.categoryTree!.data![kat1index]
                          .child![kat2index].kat2Child!.length;
                  i++)
                GestureDetector(
                  onTap: () {
                    String kat1 =
                        "${productProvider.categoryTree?.data?[kat1index].kat1Slug}";
                    String kat2 =
                        "${productProvider.categoryTree?.data?[kat1index].child?[kat2index].kat2Slug}";
                    String kat3 =
                        "${productProvider.categoryTree?.data?[kat1index].child?[kat2index].kat2Child?[i].kat3Slug}";
                    print("Category Selected $kat1,$kat2,$kat3");

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchList(
                          text: "",
                          cat: "$kat1,$kat2,$kat3",
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 30,
                          child: Text(
                            productProvider.categoryTree!.data![kat1index]
                                .child![kat2index].kat2Child![i].kat3
                                .toString(),
                            style: const TextStyle(fontWeight: FontWeight.w300),
                          ),
                        ),
                        const Divider(),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      )),
    );
  }

  Widget searchbar() {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: TextField(
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
        onSubmitted: (value) {
          if (value != "") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchList(text: value)),
            );
          }
        },
        onChanged: (query) {
          if (context.mounted) {
            setState(() {
              myCategoryFiltered.clear();
              myCategoryFiltered = myCategory
                  .where((element) =>
                      element.toLowerCase().contains(query.toLowerCase()))
                  .toList();
            });
          }
        },
      ),
    );
  }

  Widget suggestionListview(List<String> myCategory) {
    return ListView(
        children: myCategory
            .map((data) => searchTextController.text == ""
                ? const SizedBox()
                : GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchList(text: data)),
                      );
                    },
                    child: Container(
                        color: Colors.white,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.search,
                                    color: Colors.grey,
                                    size: 18,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                      data,
                                      style: poppins.copyWith(
                                        fontWeight: light,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  const Icon(
                                    Icons.call_made,
                                    color: Colors.grey,
                                    size: 18,
                                  )
                                ],
                              ),
                            ),
                            const Divider(
                              color: Colors.grey,
                              thickness: 1,
                            )
                          ],
                        ))))
            .toList());
  }
}

class SuggestionListView extends StatelessWidget {
  final List<String> myCategory;
  final TextEditingController searchTextController;
  final bool isPromo;

  const SuggestionListView({
    super.key,
    required this.myCategory,
    required this.searchTextController,
    this.isPromo = false
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
        shrinkWrap: true,
        children: myCategory
            .map((data) => searchTextController.text == ""
                ? const SizedBox()
                : GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchList(text: data, isPromo: isPromo,)),
                      );
                    },
                    child: Container(
                        color: Colors.white,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.search,
                                    color: Colors.grey,
                                    size: 18,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                      data,
                                      style: poppins.copyWith(
                                        fontWeight: light,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  const Icon(
                                    Icons.call_made,
                                    color: Colors.grey,
                                    size: 18,
                                  )
                                ],
                              ),
                            ),
                            const Divider(
                              color: Colors.grey,
                              thickness: 1,
                            )
                          ],
                        ))))
            .toList());
  }

  Widget ExpansionTile({
    required String title,
  }) {
    return Container();
  }
}

class ExpansionTileBuilder extends StatelessWidget {
  final String title;
  final List<Map<dynamic, dynamic>> myProducts;
  const ExpansionTileBuilder({
    super.key,
    required this.myProducts,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ExpandableNotifier(
          child: ScrollOnExpand(
        child: ExpandablePanel(
          header: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          collapsed: const SizedBox(),
          expanded: const Wrap(
            spacing: 5,
            runSpacing: 10,
            children: [
              // for (var i = 0; i < 5; i++)
              // const ExpansionCarditem(itemTitle: "Test 1"),
            ],
          ),
        ),
      )),
    );
  }
}
