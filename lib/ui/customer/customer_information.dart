import 'dart:ffi';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:e_shop/provider/customer_provider.dart';
import 'package:e_shop/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CustomerInformation extends StatefulWidget {
  final Map<dynamic, dynamic> data;
  final bool isEditable;
  final bool isUpdate;
  const CustomerInformation(
      {super.key,
      required this.data,
      this.isEditable = false,
      this.isUpdate = false});

  @override
  State<CustomerInformation> createState() => _CustomerInformationState();
}

class _CustomerInformationState extends State<CustomerInformation> {
  String? selectedValue;

  final TextEditingController usernameTextEditingController =
      TextEditingController();
  final TextEditingController passwordTextEditingController =
      TextEditingController();
  final TextEditingController confirmPasswordTextEditingController =
      TextEditingController();
  final TextEditingController emailTextEditingController =
      TextEditingController();
  final TextEditingController birthDateTextEditingController =
      TextEditingController();
  final TextEditingController nameTextEditingController =
      TextEditingController();
  final TextEditingController phoneTextEditingController =
      TextEditingController();
  final TextEditingController addressTextEditingController =
      TextEditingController();
  final TextEditingController genderTextEditingController =
      TextEditingController();

  @override
  initState() {
    super.initState();
    if (widget.data.isNotEmpty) {
      usernameTextEditingController.text = widget.data["nama_lengkap"];
      passwordTextEditingController.text = ""; //widget.data["password"];
      emailTextEditingController.text = widget.data["password"];
      nameTextEditingController.text = widget.data["nama_lengkap"];
      birthDateTextEditingController.text = widget.data["tgl_lahir"];
      dropdownvalue = widget.data["jenis_kelamin"];
      addressTextEditingController.text = widget.data["alamat"];
      phoneTextEditingController.text = widget.data["telp"];
    }
  }

  // List of items in our dropdown menu
  var genderItems = [
    'Laki-Laki',
    'Perempuan',
  ];

  // Initial Selected Value
  String dropdownvalue = 'Laki-Laki';

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
                        "Profil Pelanggan",
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
                      searchBoxController: usernameTextEditingController,
                      headerText: "Username",
                      icon: Icons.person,
                      isEditable: widget.isEditable,
                      keyboardType: TextInputType.name,
                    ),
                    textFormBuilder(
                        searchBoxController: passwordTextEditingController,
                        headerText: "Password",
                        icon: Icons.password,
                        isEditable: widget.isEditable,
                        keyboardType: TextInputType.name),
                    textFormBuilder(
                        searchBoxController: confirmPasswordTextEditingController,
                        headerText: "Konfirmasi Password",
                        icon: Icons.password,
                        isEditable: widget.isEditable,
                        keyboardType: TextInputType.name),
                    textFormBuilder(
                        searchBoxController: emailTextEditingController,
                        headerText: "Email",
                        icon: Icons.email,
                        isEditable: widget.isEditable,
                        keyboardType: TextInputType.name),
                    textFormBuilder(
                        searchBoxController: nameTextEditingController,
                        headerText: "Nama Lengkap",
                        icon: Icons.person,
                        isEditable: widget.isEditable,
                        keyboardType: TextInputType.name),
                    datePickerBuilder(
                        searchBoxController: birthDateTextEditingController,
                        headerText: "Tanggal Lahir",
                        icon: Icons.calendar_month,
                        isEditable: widget.isEditable,
                        keyboardType: TextInputType.name),
                    genderPickerBuilder(
                        searchBoxController: genderTextEditingController,
                        headerText: "Jenis Kelamin",
                        icon: Icons.person,
                        isEditable: widget.isEditable,
                        keyboardType: TextInputType.name),
                    if (widget.isEditable) ...[
                      textFormBuilder(
                          searchBoxController: addressTextEditingController,
                          headerText: "Alamat",
                          icon: Icons.pin_drop,
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
                    ],
                    textFormBuilder(
                        searchBoxController: phoneTextEditingController,
                        headerText: "Nomor Telefon",
                        icon: Icons.phone,
                        isEditable: widget.isEditable,
                        keyboardType: TextInputType.number),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Center(
                  child: SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        bool isempty = false;
                        String username = usernameTextEditingController.text;
                        if (username.isEmpty && isempty == false) {
                          isempty = true;
                          showToast("Username wajib diisi");
                        }

                        String password = passwordTextEditingController.text;
                        String confirmPassword = confirmPasswordTextEditingController.text;
                        if (password.isEmpty && isempty == false) {
                          isempty = true;
                          showToast("Password wajib diisi");
                        }

                        if(password.isNotEmpty){
                          if(confirmPassword.isEmpty){
                            isempty = true;
                            showToast("Konfirmasi password wajib diisi");
                          }else if(password != confirmPassword){
                            isempty = true;
                            showToast("Password tidak sama");
                          }
                        }

                        String email = emailTextEditingController.text;
                        if (email.isEmpty && isempty == false) {
                          isempty = true;
                          showToast("Email wajib diisi");
                        }

                        String name = nameTextEditingController.text;
                        if (name.isEmpty && isempty == false) {
                          isempty = true;
                          showToast("Nama Lengkap wajib diisi");
                        }

                        String birthdate = birthDateTextEditingController.text;
                        if (birthdate.isEmpty && isempty == false) {
                          isempty = true;
                          showToast("Tanggal lahir wajib diisi");
                        }

                        String address = addressTextEditingController.text;
                        if (address.isEmpty && isempty == false) {
                          isempty = true;
                          showToast("Alamat wajib diisi");
                        }

                        String phone = phoneTextEditingController.text;
                        if (phone.isEmpty && isempty == false) {
                          isempty = true;
                          showToast("Nomor Telefon wajib diisi");
                        }

                        if (!isempty) {
                          customerProvider.myCustomer.add({
                            "id": customerProvider.myCustomer.length + 1,
                            "username": username,
                            "password": password,
                            "email": email,
                            "nama_lengkap": name,
                            "tgl_lahir": birthdate, // datepicker
                            "jenis_kelamin":
                                dropdownvalue, // Laki-laki / Perempuan
                            "alamat": address,
                            "telp": phone
                          });
                          Navigator.pop(context);
                        } else {}
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
                          Icon(
                            widget.isUpdate == true
                                ? Icons.refresh
                                : Icons.person_add,
                            color: Colors.white,
                          ),
                          Text(
                            widget.isUpdate == true
                                ? ' Update Data Pelanggan'
                                : ' Simpan Pelanggan',
                            style: poppins.copyWith(
                                fontWeight: semiBold, color: Colors.white),
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
      ),
    );
  }

  Widget listFormBuilder({
    required List<String> items,
    required String headerText,
    required IconData icon
  }) {
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

  Widget textFormBuilder({
    required TextEditingController searchBoxController,
    required String headerText,
    required IconData icon,
    required bool isEditable,
    required TextInputType keyboardType,
  }) {
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
              obscureText: headerText == "Password" ? true : false,
              cursorColor: Colors.grey,
              enabled: isEditable,
              keyboardType: keyboardType,
              maxLines: headerText == "Password" ? 1 : 5,
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

  Widget datePickerBuilder(
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
              readOnly: true,
              cursorColor: Colors.grey,
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
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(), //get today's date
                    firstDate: DateTime(1950),
                    lastDate: DateTime(2101));

                if (pickedDate != null) {
                  String formattedDate =
                      DateFormat('yyyy-MM-dd').format(pickedDate);
                  setState(() {
                    searchBoxController.text = formattedDate;
                  });
                } else {
                  print("Date is not selected");
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget genderPickerBuilder(
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
            width: double.infinity,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                border: Border.fromBorderSide(BorderSide(color: Colors.grey))),
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton(
                underline: const SizedBox(),
                isExpanded: true,
                value: dropdownvalue,
                icon: const Icon(Icons.keyboard_arrow_down),
                menuMaxHeight: 300,
                items: genderItems.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                // After selecting the desired option,it will
                // change button value to selected value
                onChanged: isEditable == true
                    ? (String? newValue) {
                        setState(() {
                          dropdownvalue = newValue!;
                        });
                      }
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showToast(String text){
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
