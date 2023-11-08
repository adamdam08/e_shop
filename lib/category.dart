import 'dart:math';

import 'package:e_shop/search_list.dart';
import 'package:e_shop/theme/theme.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

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
    setState(() {
      print("Searchbar Clicked");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          searchbar(),
          if (searchBarFocusNode.hasFocus) ...[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SuggestionListView(
                    myCategory: myCategoryFiltered,
                    searchTextController: searchTextController),
              ),
            ),
          ] else ...[
            Expanded(
              child: ListView(
                children: [
                  ExpansionTileBuilder(
                      title: "Collapsible 1", myProducts: myProducts),
                  ExpansionTileBuilder(
                      title: "Collapsible 2", myProducts: myProducts),
                  ExpansionTileBuilder(
                      title: "Collapsible 3", myProducts: myProducts),
                  ExpansionTileBuilder(
                      title: "Collapsible 4", myProducts: myProducts),
                  ExpansionTileBuilder(
                      title: "Collapsible 5", myProducts: myProducts),
                  ExpansionTileBuilder(
                      title: "Collapsible 1", myProducts: myProducts),
                  ExpansionTileBuilder(
                      title: "Collapsible 2", myProducts: myProducts),
                  ExpansionTileBuilder(
                      title: "Collapsible 3", myProducts: myProducts),
                  ExpansionTileBuilder(
                      title: "Collapsible 4", myProducts: myProducts),
                  ExpansionTileBuilder(
                      title: "Collapsible 5", myProducts: myProducts),
                ],
              ),
            ),
          ]
        ],
      ),
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

  const SuggestionListView({
    super.key,
    required this.myCategory,
    required this.searchTextController,
  });

  @override
  Widget build(BuildContext context) {
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
                  child: Text(title, style: const TextStyle(fontWeight: FontWeight.w500),),
                ),
                collapsed: const SizedBox(),
                expanded: Wrap(
                spacing: 5,
                runSpacing: 10,
                children: [
                  for (var i = 0; i < 5; i++)
                    const ExpansionCarditem(itemTitle: "Test 1"),
                  ],
                ),
            ),
          )
      ),
    );

    // return Container(
    //   padding: const EdgeInsets.symmetric(vertical: 5),
    //   child: Theme(
    //     data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
    //     child: ExpansionTile(
    //       maintainState: true,
    //       expandedCrossAxisAlignment: CrossAxisAlignment.start,
    //       backgroundColor: Colors.white,
    //       collapsedBackgroundColor: Colors.white60,
    //       title: Text(
    //         title,
    //         style: const TextStyle(fontWeight: FontWeight.w500),
    //       ),
    //       children: [
    //         Wrap(
    //           spacing: 10,
    //           runSpacing: 10,
    //           children: [
    //             for (var i = 0; i < 3; i++)
    //               const ExpansionCarditem(itemTitle: "Test 1"),
    //           ],
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }
}

class ExpansionCarditem extends StatelessWidget {
  final String itemTitle;
  const ExpansionCarditem({super.key, required this.itemTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: 75,
      height: 75,
      child: Card(
          elevation: 2,
          shadowColor: Colors.grey,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Icon(Icons.message, size: 24, color: Colors.black),
              Text(
                itemTitle,
                style: const TextStyle(color: Colors.black),
              ),
            ],
          )),
    );
  }
}
