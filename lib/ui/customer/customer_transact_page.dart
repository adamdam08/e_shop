import 'package:flutter/material.dart';

import '../../theme/theme.dart';

class CustomerTransactPage extends StatefulWidget {
  final Map myCustomer;
  const CustomerTransactPage({required this.myCustomer, super.key});

  @override
  State<CustomerTransactPage> createState() => _CustomerTransactPageState();
}

class _CustomerTransactPageState extends State<CustomerTransactPage> {

  Widget transactionDynamicCard(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.symmetric(horizontal: 10),
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
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "No Invoice : ${widget.myCustomer["nama_lengkap"]}",
            style: poppins.copyWith(
                fontWeight: regular,
                color: Colors.black,
                fontSize: 12,
                overflow: TextOverflow.ellipsis
            ),
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        left: true,
        right: true,
        bottom: true,
        child: Container(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                color: backgroundColor3,
                padding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const SizedBox(
                            width:
                            20, //MediaQuery.of(context).size.width * 0.1,
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Text(
                          "Riwayat Transaksi Pelanggan",
                          style: poppins.copyWith(
                              fontSize: 20,
                              fontWeight: semiBold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration:BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                blurRadius: 4,
                                offset: const Offset(0, 0))
                          ]),
                      child: Row(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                                color: backgroundColor3, shape: BoxShape.circle),
                            margin: const EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: Text(
                                getInitials(widget.myCustomer["username"].toString()),
                                style: poppins.copyWith(
                                  fontWeight: regular,
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20,),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.myCustomer["nama_lengkap"].toString(),
                                  style: poppins.copyWith(
                                      fontWeight: regular,
                                      color: Colors.black,
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis
                                  ),
                                  maxLines: 1,
                                ),
                                Text(
                                  widget.myCustomer["telp"].toString(),
                                  style: poppins.copyWith(
                                      fontWeight: regular,
                                      color: Colors.black,
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis
                                  ),
                                  maxLines: 1,
                                ),
                                Text(
                                  widget.myCustomer["email"].toString(),
                                  style: poppins.copyWith(
                                      fontWeight: regular,
                                      color: Colors.black,
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis
                                  ),
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                children: [
                  Text(
                      widget.myCustomer.toString(),
                      style: poppins.copyWith(
                        fontWeight: regular,
                        color: Colors.black,
                        fontSize: 18,
                      )
                  ),
                  transactionDynamicCard()
                ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getInitials(String name) {
    // Split the name into individual words
    List<String> words = name.split(' ');

    // Initialize an empty string to store initials
    String initials = '';

    // Iterate through each word and extract the first letter
    for (int i = 0; i < words.length && i < 2; i++) {
      // Get the first letter of the word and add it to the initials string
      initials += words[i][0];
    }

    // Return the initials string
    return initials;
  }
}
