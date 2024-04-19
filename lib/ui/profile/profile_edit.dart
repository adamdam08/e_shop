import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:e_shop/provider/auth_provider.dart';
import 'package:e_shop/provider/customer_provider.dart';
import 'package:e_shop/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfilEdit extends StatefulWidget {
  final Map<dynamic, dynamic> data;
  final bool isPassword;
  const ProfilEdit({
    super.key,
    required this.data,
    this.isPassword = false,
  });

  @override
  State<ProfilEdit> createState() => ProfilEditState();
}

class ProfilEditState extends State<ProfilEdit> {
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
      usernameTextEditingController.text = widget.data["nama_lengkap"] ?? "";
      emailTextEditingController.text = widget.data["email"] ?? "";
      nameTextEditingController.text = widget.data["nama_lengkap"] ?? "";
      birthDateTextEditingController.text = widget.data["tgl_lahir"] ?? "";
      addressTextEditingController.text = widget.data["alamat"] ?? "";
      phoneTextEditingController.text = widget.data["telp"] ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    CustomerProvider customerProvider = Provider.of<CustomerProvider>(context);
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

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
                        "Update Data Sales",
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
                    if (widget.isPassword == true) ...[
                      textFormBuilder(
                          searchBoxController: passwordTextEditingController,
                          headerText: "Password",
                          icon: Icons.password,
                          isEditable: true,
                          keyboardType: TextInputType.name),
                      textFormBuilder(
                          searchBoxController:
                              confirmPasswordTextEditingController,
                          headerText: "Konfirmasi Password",
                          icon: Icons.password,
                          isEditable: true,
                          keyboardType: TextInputType.name)
                    ] else ...[
                      const SizedBox()
                    ],
                    if (widget.isPassword != true) ...[
                      textFormBuilder(
                        searchBoxController: usernameTextEditingController,
                        headerText: "Username",
                        icon: Icons.person,
                        isEditable: true,
                        keyboardType: TextInputType.name,
                      ),
                      textFormBuilder(
                          searchBoxController: nameTextEditingController,
                          headerText: "Nama Lengkap",
                          icon: Icons.person,
                          isEditable: true,
                          keyboardType: TextInputType.name),
                      textFormBuilder(
                          searchBoxController: emailTextEditingController,
                          headerText: "Email",
                          icon: Icons.mail,
                          isEditable: true,
                          keyboardType: TextInputType.emailAddress),
                      textFormBuilder(
                          searchBoxController: addressTextEditingController,
                          headerText: "Alamat",
                          icon: Icons.pin_drop,
                          isEditable: true,
                          keyboardType: TextInputType.emailAddress),
                      textFormBuilder(
                          searchBoxController: phoneTextEditingController,
                          headerText: "Nomor Telefon",
                          icon: Icons.phone,
                          isEditable: true,
                          keyboardType: TextInputType.number),
                    ] else ...[
                      const SizedBox()
                    ],
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
                      onPressed: () async {
                        bool isempty = false;
                        String username = usernameTextEditingController.text;
                        String password = passwordTextEditingController.text;
                        String confirmPassword =
                            confirmPasswordTextEditingController.text;
                        String email = emailTextEditingController.text;
                        String name = nameTextEditingController.text;
                        String address = addressTextEditingController.text;
                        String phone = phoneTextEditingController.text;

                        if (widget.isPassword == true) {
                          if (password.isEmpty && isempty == false) {
                            isempty = true;
                            showToast("Password wajib diisi");
                          }

                          if (password.isNotEmpty) {
                            if (confirmPassword.isEmpty) {
                              isempty = true;
                              showToast("Konfirmasi password wajib diisi");
                            } else if (password != confirmPassword) {
                              isempty = true;
                              showToast("Password tidak sama");
                            }
                          }
                        }

                        if (widget.isPassword != true) {
                          if (username.isEmpty && isempty == false) {
                            isempty = true;
                            showToast("Username wajib diisi");
                          }

                          if (name.isEmpty && isempty == false) {
                            isempty = true;
                            showToast("Nama Lengkap wajib diisi");
                          }

                          if (email.isEmpty && isempty == false) {
                            isempty = true;
                            showToast("Email wajib diisi");
                          }

                          if (address.isEmpty && isempty == false) {
                            isempty = true;
                            showToast("Alamat wajib diisi");
                          }

                          if (phone.isEmpty && isempty == false) {
                            isempty = true;
                            showToast("Nomor Telefon wajib diisi");
                          }
                        }

                        if (!isempty) {
                          var jsonData = widget.isPassword
                              ? {"password": password}
                              : {
                                  "username": username,
                                  "nama_lengkap": name,
                                  "email": email,
                                  "alamat": address,
                                  "telp": phone,
                                  "wilayah": ""
                                };

                          var loginData = await authProvider.getLoginData();
                          var message =
                              await customerProvider.updateCustomerData(
                                  data: jsonData,
                                  id: widget.data["id"],
                                  token: loginData!.token.toString());

                          if (message != "") {
                            showToast(message);
                          } else {
                            showToast("Add data customer success");
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          }
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
                          const Icon(
                            Icons.refresh,
                            color: Colors.white,
                          ),
                          Text(
                            'Update Data Sales',
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
              obscureText: (headerText == "Password") ||
                      (headerText == "Konfirmasi Password")
                  ? true
                  : false,
              cursorColor: Colors.grey,
              enabled: isEditable,
              keyboardType: keyboardType,
              maxLines: (headerText == "Password") ||
                      (headerText == "Konfirmasi Password")
                  ? 1
                  : 5,
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

  void showToast(String text) {
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
