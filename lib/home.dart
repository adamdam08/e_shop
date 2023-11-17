import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:e_shop/detail_item.dart';
import 'package:e_shop/provider/page_provider.dart';
import 'package:e_shop/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:transparent_image/transparent_image.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<int> text = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  final List<String> imgList = [
    "https://picsum.photos/id/100/1920/1080",
    "https://picsum.photos/id/101/1920/1080",
    "https://picsum.photos/id/102/1920/1080",
    "https://picsum.photos/id/103/1920/1080",
    "https://picsum.photos/id/104/1920/1080",
    "https://picsum.photos/id/109/1920/1080",
    "https://picsum.photos/id/106/1920/1080",
    "https://picsum.photos/id/107/1920/1080",
    "https://picsum.photos/id/108/1920/1080"
  ];
  int carouselIndex = 0;

  @override
  Widget build(BuildContext context) {
    PageProvider pageProvider = Provider.of(context);
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 10),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    pageProvider.currentIndex = 1;
                  });
                },
                child: Icon(
                  Icons.view_list,
                  size: 30,
                  color: backgroundColor3,
                ),
              ),
              Column(
                children: [
                  Text(
                    "Adamdam",
                    style: poppins.copyWith(
                        color: backgroundColor1, fontWeight: semiBold),
                  ),
                  Text(
                    "Jakarta, Indonesia",
                    style: poppins.copyWith(
                        color: backgroundColor2, fontWeight: medium),
                  )
                ],
              ),
              GestureDetector(
                onTap: () {},
                child: Icon(
                  SolarIconsBold.user,
                  size: 30,
                  color: backgroundColor3,
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: [
                CarouselSlider(
                  items: [
                    for (var sliderItem in imgList)
                      FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: sliderItem,
                        fit: BoxFit.cover,
                      ),
                  ],
                  options: CarouselOptions(
                    viewportFraction: 1,
                    autoPlay: true,
                    autoPlayCurve: Curves.linear,
                    reverse: false,
                    autoPlayInterval: const Duration(seconds: 5),
                    initialPage: carouselIndex,
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (index, reason) {
                      setState(() {
                        carouselIndex = index;
                      });
                    },
                  ),
                ),
                Positioned(
                  bottom: 5,
                  left: 0,
                  right: 0,
                  child: DotsIndicator(
                    dotsCount: imgList.length,
                    position: carouselIndex,
                    decorator: DotsDecorator(
                      color: Colors.black38, // Inactive color
                      activeColor: backgroundColor2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        CardSectionHorizontal(text: text, headerText: "Promo "),
        CardSectionHorizontal(text: text, headerText: "Diskon"),
        CardSectionVertical(text: text, headerText: "Produk terlaku"),
      ],
    );
  }
}

class CardSectionHorizontal extends StatelessWidget {
  final List<int> text;
  final String headerText;
  const CardSectionHorizontal(
      {super.key, required this.text, required this.headerText});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 340,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              margin: const EdgeInsets.only(top: 20, bottom: 10),
              width: double.infinity,
              child: Text(
                headerText,
                style: poppins.copyWith(
                    fontSize: 24,
                    fontWeight: semiBold,
                    color: backgroundColor1),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(left: 30, right: 30, bottom: 5),
                scrollDirection: Axis.horizontal,
                children: [
                  for (var i in text)
                    DynamicCardHorizontal(
                      text: i.toString(),
                    ),
                ],
              ),
            ),
          ],
        ));
  }
}

class DynamicCardHorizontal extends StatelessWidget {
  final String text;
  final bool isDiscount;
  const DynamicCardHorizontal(
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
        margin: const EdgeInsets.only(right: 10),
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
                height: 150,
                width: 150,
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
                      "Lorem ipsum dolor sit ametasdasd",
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

class CardSectionVertical extends StatelessWidget {
  final List<int> text;
  final String headerText;
  const CardSectionVertical(
      {super.key, required this.text, required this.headerText});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: double.infinity,
              child: Text(
                headerText,
                style: poppins.copyWith(
                    fontSize: 24,
                    fontWeight: semiBold,
                    color: backgroundColor1),
              ),
            ),
            for (var i in text)
              DynamicCardVertical(
                text: i.toString(),
              ),
          ],
        ));
  }
}

class DynamicCardVertical extends StatelessWidget {
  final String text;
  final bool isDiscount;
  const DynamicCardVertical(
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
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image:
                    "https://picsum.photos/300?image=${(int.tryParse(text)! * Random().nextInt(10))}",
                fit: BoxFit.cover,
                height: 125,
                width: 125,
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
                      "Lorem ipsum dolor sit amet",
                      style: poppins.copyWith(
                          overflow: TextOverflow.ellipsis,
                          fontWeight: semiBold,
                          fontSize: 18,
                          color: backgroundColor1),
                      maxLines: 2,
                    ),
                    Text(
                      "Rp.100,000.00",
                      style: poppins.copyWith(
                          fontWeight: regular, color: backgroundColor3),
                    ),
                    if (isDiscount)
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              "Rp.100,000.000",
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
                                color: Colors.red,
                                fontWeight: bold),
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
