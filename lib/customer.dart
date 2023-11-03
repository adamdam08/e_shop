import 'dart:math';

import 'package:e_shop/customer_information.dart';
import 'package:e_shop/provider/customer_provider.dart';
import 'package:e_shop/search_list.dart';
import 'package:e_shop/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rounded_image_with_textbg/rounded_image_with_textbg.dart';
import 'package:transparent_image/transparent_image.dart';


class Customer extends StatefulWidget {
  const Customer({super.key});

  @override
  State<Customer> createState() => _CustomerState();
}

class _CustomerState extends State<Customer>{
  @override
  Widget build(BuildContext context) {
    CustomerProvider customerProvider = Provider.of<CustomerProvider>(context);

    Widget customerDynamicCardVertical(Map<dynamic, dynamic> myCustomer){
      return GestureDetector(
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CustomerInformation(data: myCustomer, isEditable: false,)),
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
                    offset: const Offset(0, 0)
                )
              ]
          ),
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
                            color: backgroundColor1
                        ),
                        maxLines: 2,
                      ),
                      Text(
                        myCustomer["address"],
                        style: poppins.copyWith(
                            fontWeight: regular,
                            color: backgroundColor3,
                            overflow: TextOverflow.ellipsis
                        ),
                        maxLines: 2,
                      ),
                      Text(
                        myCustomer["phone"],
                        style: poppins.copyWith(
                            overflow: TextOverflow.ellipsis,
                            fontWeight: semiBold,
                            color: backgroundColor2
                        ),
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

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.78,
                  height: 50,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: TextField(
                    textInputAction: TextInputAction.search,
                    obscureText: false,
                    cursorColor: Colors.grey,
                    maxLines: 1,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      prefixIconColor: Colors.grey,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        borderSide: BorderSide(
                            color: Colors.red,
                            width: 1
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        borderSide: BorderSide(
                            color: Colors.green,
                            width: 1
                        ),
                      ),
                      hintText: "Search Here...",
                      hintStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal
                      ),
                      alignLabelWithHint: true,
                    ),
                    onSubmitted:(value){
                      if(value != ""){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SearchList(text: value)),
                        );
                      }
                    },
                  ),
                ),
                InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CustomerInformation(data: {}, isEditable: true,)),
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
          ),
          if(customerProvider.myCustomer.isEmpty)...[
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
                          style: poppins.copyWith(
                              fontWeight: regular,
                              fontSize: 20
                          ),
                        ),
                      ],
                    )
                )
            )
          ]else...[
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                children: [

                  for (int i = 0; i < customerProvider.myCustomer.length; i++)
                    customerDynamicCardVertical(customerProvider.myCustomer[i])
                ],
              ),
            )
          ]
        ],
      ),
    );
  }
}