import 'dart:ffi';
import 'dart:math';

import 'package:e_shop/main.dart';
import 'package:e_shop/provider/cart_provider.dart';
import 'package:e_shop/provider/page_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

import 'theme/theme.dart';

class DetailItem extends StatefulWidget {
  final String imageUrl;
  const DetailItem({
    super.key,
    required this.imageUrl
  });

  @override
  State<DetailItem> createState() => _DetailItemState();
}

class _DetailItemState extends State<DetailItem> {
  @override
  Widget build(BuildContext context) {
    CartProvider cartProduct = Provider.of<CartProvider>(context);
    PageProvider pageProvider = Provider.of<PageProvider>(context);

    return Scaffold(
      body: SafeArea(
        top: true,
        left: true,
        right: true,
        bottom: true,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Stack(
                    children: [
                      Image.network(
                        widget.imageUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 30,left: 30, right: 30),
                        margin: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.8),
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(30))
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Rp.100,000.00",
                              style: poppins.copyWith(
                                fontWeight: semiBold,
                                color: backgroundColor1,
                                fontSize: 20,
                              ),
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    "Rp.100,000.000",
                                    maxLines: 1,
                                    style: poppins.copyWith(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 14,
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough
                                    ),
                                  ),
                                ),
                                Text(
                                  " 50%",
                                  style: poppins.copyWith(
                                      fontSize: 12,
                                      color: Colors.red,
                                      fontWeight: bold
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
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
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                "Lorem ipsum dolor sit amet",
                                style: poppins.copyWith(
                                  fontWeight: bold,
                                  fontSize: 18,
                                  color: backgroundColor1,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            ReadMoreText(
                              "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of de Finibus Bonorum et Malorum (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, Lorem ipsum dolor sit amet.., comes from a line in section 1.10.32.",
                              style: poppins.copyWith(
                                fontWeight: regular,
                                fontSize: 14,
                                color: Colors.black,
                              ),
                              trimLines: 3,
                              colorClickableText: Colors.grey,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: ' Show more',
                              trimExpandedText: ' Show less ',
                              textAlign: TextAlign.justify,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20, bottom: 10),
                              child: Text(
                                "Detail product",
                                style: poppins.copyWith(
                                  fontWeight: semiBold,
                                  color: backgroundColor1,
                                  fontSize: 18
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Condition",
                                  style: poppins.copyWith(
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  "Data",
                                  style: poppins.copyWith(
                                      color: backgroundColor1,
                                  ),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Divider(
                                height: 1,
                                thickness: 1,
                                color: Colors.grey,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Min. Purchase",
                                  style: poppins.copyWith(
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  "Data",
                                  style: poppins.copyWith(
                                    color: backgroundColor1,
                                  ),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Divider(
                                height: 1,
                                thickness: 1,
                                color: Colors.grey,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Category",
                                  style: poppins.copyWith(
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  "Data",
                                  style: poppins.copyWith(
                                    color: backgroundColor1,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            const Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Divider(
                                height: 1,
                                thickness: 1,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        width: double.infinity,
                        height: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  Navigator.pop(context);
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.arrow_back,
                                  size: 30,
                                  color: backgroundColor1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
              child: Center(
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        Map<dynamic, dynamic> myProducts =  cartProduct.myProducts.firstWhere(
                                (element) => element["id"] == widget.imageUrl,
                            orElse: () => {}
                        );

                        if(myProducts.isEmpty){
                          cartProduct.myProducts.add({
                            "id": widget.imageUrl,
                            "name": widget.imageUrl,
                            "price": 100000,
                            "amount": 1
                          });
                        }else{
                          myProducts["amount"]  = myProducts["amount"]+=1;
                        }

                      });
                      final snackBar = SnackBar(
                        content: const Text('Add To Cart Success!'),
                        duration: const Duration(seconds: 1),
                        action: SnackBarAction(
                          label: 'Go To Cart',
                          onPressed: () {
                            // Some code to undo the change.
                            setState(() {
                              pageProvider.currentIndex = 4;
                            });
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => const BottomNavigationBarExample()),
                                (route) => false
                            );
                          },
                        ),
                      );

                      // Find the ScaffoldMessenger in the widget tree
                      // and use it to show a SnackBar.
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(
                            side: BorderSide(
                                width: 1,
                                color: backgroundColor3
                            )
                        ),
                        backgroundColor: backgroundColor1
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                        ),
                        Text(
                          ' Add to Cart',
                          style: poppins.copyWith(
                              fontWeight: semiBold,
                              color: Colors.white
                          ),
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
    );
  }
}
