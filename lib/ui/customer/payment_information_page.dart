import 'package:e_shop/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class PaymentInformationPage extends StatefulWidget {
  final String paymentInfo;
  const PaymentInformationPage({required this.paymentInfo, super.key});

  @override
  State<PaymentInformationPage> createState() => _PaymentInformationPageState();
}

class _PaymentInformationPageState extends State<PaymentInformationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            top: true,
            bottom: true,
            left: true,
            right: true,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  color: backgroundColor3,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const SizedBox(
                          width: 20, //MediaQuery.of(context).size.width * 0.1,
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        "Tata Cara Pembayaran",
                        style: poppins.copyWith(
                            fontSize: 20,
                            fontWeight: semiBold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: HtmlWidget('''
                        ${widget.paymentInfo}
                        '''),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }
}
