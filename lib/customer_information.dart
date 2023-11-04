import 'dart:math';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:e_shop/provider/customer_provider.dart';
import 'package:e_shop/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class CustomerInformation extends StatefulWidget {
  final Map<dynamic, dynamic> data;
  final bool isEditable;
  const CustomerInformation(
      {super.key, required this.data, this.isEditable = false});

  @override
  State<CustomerInformation> createState() => _CustomerInformationState();
}

class _CustomerInformationState extends State<CustomerInformation> {
  String? selectedValue;

  final List<String> items = [
    'A_Item1',
    'A_Item2',
    'A_Item3',
    'A_Item4',
    'B_Item1',
    'B_Item2',
    'B_Item3',
    'Jl.Bendungan Sutami GG.6 No 11, Lowokwaru, Kota Malang, Jawa Timur.',
  ];

  final TextEditingController nameTextEditingController =
      TextEditingController();
  final TextEditingController phoneTextEditingController =
      TextEditingController();
  final TextEditingController addressTextEditingController =
      TextEditingController();

  @override
  initState() {
    super.initState();
    if (widget.isEditable == false) {
      nameTextEditingController.text = widget.data["name"];
      phoneTextEditingController.text = widget.data["phone"];
      addressTextEditingController.text = widget.data["address"];
    }
  }

  @override
  Widget build(BuildContext context) {
    CustomerProvider customerProvider = Provider.of<CustomerProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const SizedBox(
                        width: 20, //MediaQuery.of(context).size.width * 0.1,
                        child: Icon(Icons.arrow_back),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Profil Customer",
                        style: poppins.copyWith(
                            fontWeight: semiBold, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    textFormBuilder(
                        searchBoxController: nameTextEditingController,
                        headerText: "Nama",
                        icon: Icons.person,
                        isEditable: widget.isEditable,
                        keyboardType: TextInputType.name),
                    textFormBuilder(
                        searchBoxController: phoneTextEditingController,
                        headerText: "Nomor Telefon",
                        icon: Icons.phone,
                        isEditable: widget.isEditable,
                        keyboardType: TextInputType.number),
                    if (widget.isEditable) ...[
                      textFormBuilder(
                          searchBoxController: addressTextEditingController,
                          headerText: "Alamat",
                          icon: Icons.phone,
                          isEditable: widget.isEditable,
                          keyboardType: TextInputType.emailAddress),
                    ] else ...[
                      for (var i = 0; i < 1; i++)
                        textFormBuilder(
                            searchBoxController: addressTextEditingController,
                            headerText: "Alamat ${i + 1}",
                            icon: Icons.phone,
                            isEditable: widget.isEditable,
                            keyboardType: TextInputType.text),
                    ]
                  ],
                ),
              ),
              if (widget.isEditable) ...[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Center(
                    child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          String name = nameTextEditingController.text;
                          String phone = phoneTextEditingController.text;
                          String address = addressTextEditingController.text;

                          if (name.isNotEmpty &&
                              phone.isNotEmpty &&
                              address.isNotEmpty) {
                            customerProvider.myCustomer.add({
                              "id": customerProvider.myCustomer.length + 1,
                              "name": nameTextEditingController.text,
                              "phone": phoneTextEditingController.text,
                              "address": addressTextEditingController.text
                            });
                            Navigator.pop(context);
                          } else {
                            if (name.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Nama wajib diisi",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                            if (phone.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Nomor telefon wajib diisi",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                            if (address.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Alamat wajib diisi",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            shape: StadiumBorder(
                                side: BorderSide(
                                    width: 1, color: backgroundColor3)),
                            backgroundColor: backgroundColor1),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.person_add,
                              color: Colors.white,
                            ),
                            Text(
                              ' Simpan Customer',
                              style: poppins.copyWith(
                                  fontWeight: semiBold, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ] else
                ...[],
            ],
          ),
        ),
      ),
    );
  }

  Widget listFormBuilder(
      {required List<String> items,
      required String headerText,
      required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            headerText,
            style: poppins.copyWith(fontWeight: semiBold, fontSize: 14),
          ),
          const SizedBox(
            height: 10,
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              isExpanded: true,
              hint: Row(
                children: [
                  Icon(
                    icon,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      '$selectedValue',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: regular,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              items: items
                  .map((String item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: TextStyle(
                            fontWeight: regular,
                            color: Colors.grey,
                          ),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ))
                  .toList(),
              value: selectedValue,
              buttonStyleData: ButtonStyleData(
                width: double.infinity,
                padding: const EdgeInsets.only(left: 14, right: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  color: Colors.white,
                ),
                elevation: 1,
              ),
              iconStyleData: const IconStyleData(
                icon: Icon(
                  Icons.arrow_forward_ios_outlined,
                ),
                iconSize: 14,
                iconEnabledColor: Colors.grey,
                iconDisabledColor: Colors.grey,
              ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: 200,
                width: 370,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                offset: const Offset(0, 0),
                scrollbarTheme: ScrollbarThemeData(
                  thickness: MaterialStateProperty.all(6),
                  thumbVisibility: MaterialStateProperty.all(true),
                ),
              ),
              barrierColor: Colors.grey.withOpacity(0.5),
              onChanged: (value) {
                setState(() {
                  selectedValue = value!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget textFormBuilder(
      {required TextEditingController searchBoxController,
      required String headerText,
      required IconData icon,
      required bool isEditable,
      required TextInputType keyboardType}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            headerText,
            style: poppins.copyWith(fontWeight: semiBold, fontSize: 14),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: TextField(
              controller: searchBoxController,
              obscureText: false,
              cursorColor: Colors.grey,
              enabled: isEditable,
              keyboardType: keyboardType,
              maxLines: 5,
              minLines: 1,
              decoration: InputDecoration(
                prefixIcon: Icon(icon),
                prefixIconColor: Colors.grey,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  borderSide: BorderSide(color: Colors.red, width: 1),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  borderSide: BorderSide(color: Colors.green, width: 1),
                ),
                hintText: isEditable ? "Input $headerText" : headerText,
                hintStyle: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.normal),
                alignLabelWithHint: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
