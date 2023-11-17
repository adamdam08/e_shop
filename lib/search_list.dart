import 'dart:math';

import 'package:e_shop/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import 'category.dart';
import 'detail_item.dart';

class SearchList extends StatefulWidget {
  final String text;
  const SearchList({super.key, required this.text});

  @override
  State<SearchList> createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  List<String> myCategoryFiltered = [];
  List<String> myCategory = ["Tepung", "Kecap", "Sambal", "Beras", "Mie"];

  FocusNode searchBarFocusNode = FocusNode();
  TextEditingController searchTextController = TextEditingController();

  @override
  initState() {
    super.initState();
    searchTextController.text = widget.text;
    searchBarFocusNode.addListener(() {
      print("Clicked");
      print("Clicked : ${searchBarFocusNode.hasFocus}");
    });
  }

  final List<Map> myProducts =
      List.generate(10, (index) => {"id": index, "name": "Product $index"})
          .toList();

  @override
  Widget build(BuildContext context) {
    Widget searchBar() {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (searchBarFocusNode.hasFocus == false) ...[
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: SizedBox(
                  child: Icon(
                    Icons.arrow_back,
                    color: backgroundColor1,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
            Expanded(
              child: Container(
                height: 50,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: TextField(
                  textInputAction: TextInputAction.search,
                  controller: searchTextController,
                  focusNode: searchBarFocusNode,
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
                    hintText: "Cari disini...",
                    hintStyle:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                    alignLabelWithHint: true,
                  ),
                  onSubmitted: (value) {
                    if (value != "") {
                      FocusScope.of(context).unfocus();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchList(text: value)),
                      );
                    }
                  },
                  onChanged: (query) {
                    setState(() {
                      myCategoryFiltered.clear();
                      myCategoryFiltered = myCategory
                          .where((element) => element
                              .toLowerCase()
                              .contains(query.toLowerCase()))
                          .toList();
                    });
                  },
                  onTap: () {
                    print("Focus : ${searchBarFocusNode.hasFocus}");
                  },
                ),
              ),
            ),
          ],
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                searchBar(),
                RichText(
                  text: TextSpan(
                    text: 'Hasil Pencarian : ',
                    style: poppins.copyWith(color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                          text: widget.text,
                          style: poppins.copyWith(color: backgroundColor1)),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (searchBarFocusNode.hasFocus == false) ...[
                  if (myProducts.isEmpty) ...[
                    Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.report_problem,
                          size: 48,
                        ),
                        Text(
                          "Products Not Found",
                          style: poppins.copyWith(
                              fontWeight: regular, fontSize: 20),
                        ),
                      ],
                    ))
                  ] else ...[
                    Expanded(child: GridBuilder(myProducts: myProducts))
                  ]
                ] else ...[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: SuggestionListView(
                          myCategory: myCategoryFiltered,
                          searchTextController: searchTextController),
                    ),
                  )
                ],
              ],
            ),
          )),
    );
  }
}

class GridBuilder extends StatelessWidget {
  final List<Map<dynamic, dynamic>> myProducts;
  const GridBuilder({super.key, required this.myProducts});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            mainAxisExtent: 300,
            crossAxisSpacing: 25,
            mainAxisSpacing: 10),
        itemCount: myProducts.length,
        itemBuilder: (BuildContext ctx, index) {
          return const SearchDynamicCard(text: "1");
        });
  }
}

class SearchDynamicCard extends StatelessWidget {
  final String text;
  final bool isDiscount;
  const SearchDynamicCard(
      {super.key, required this.text, this.isDiscount = true});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailItem(
                    imageUrl:
                        "https://picsum.photos/300?image=${(int.tryParse(text)! * Random().nextInt(10))}",
                  )),
        );
      },
      child: Container(
        width: 150,
        height: 300,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 4,
                  offset: const Offset(0, 0))
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image:
                    "https://picsum.photos/300?image=${(int.tryParse(text)! * Random().nextInt(10))}",
                fit: BoxFit.cover,
                height: 175,
                width: 175,
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Lorem ipsum dolor sit ametasdasdasd",
                      style: poppins.copyWith(
                          overflow: TextOverflow.ellipsis,
                          fontWeight: semiBold,
                          color: backgroundColor1,
                          fontSize: 18),
                      maxLines: 2,
                    ),
                    Text(
                      "Rp.100.000",
                      style: poppins.copyWith(
                          fontWeight: medium, color: backgroundColor3),
                    ),
                    if (this.isDiscount)
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              "Rp.100.000.000",
                              maxLines: 1,
                              style: poppins.copyWith(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 10,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough),
                            ),
                          ),
                          Text(
                            " 50%",
                            style: poppins.copyWith(
                              fontSize: 10,
                              fontWeight: bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.location_city,
                          color: Colors.orange,
                          size: 12,
                        ),
                        Text(
                          " Cab.Trenggalek",
                          style: poppins.copyWith(
                            fontSize: 12,
                            fontWeight: semiBold,
                            color: backgroundColor2,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
