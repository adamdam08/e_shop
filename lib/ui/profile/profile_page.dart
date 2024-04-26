import 'package:e_shop/models/user_model.dart';
import 'package:e_shop/provider/auth_provider.dart';
import 'package:e_shop/theme/theme.dart';
import 'package:e_shop/ui/customer/add_customer_page.dart';
import 'package:e_shop/ui/profile/profile_edit.dart';
import 'package:flutter/material.dart';
import 'package:placeholder_images/placeholder_images.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    var imageUrl = PlaceholderImage.getPlaceholderImageURL(
        authProvider.user.data.namaLengkap.toString());
    UserModel loginData = authProvider.user;

    // Load Latest Profil
    void _getLatestProfil() async {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      // Check Latest Profil
      if (await authProvider.salesLogin(
        email: authProvider.user.data.email.toString(),
        password: authProvider.user.data.password.toString(),
      )) {
        setState(() {});
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
              backgroundColor: Colors.red,
              content: Text(
                'Gagal Mendapatkan Profil Terbaru!',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
      }
    }

    Widget textData(String title, String data) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  data,
                  style: poppins.copyWith(
                    fontWeight: regular,
                    color: Colors.black,
                  ),
                ),
              ],
            )
          ],
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

    return Scaffold(
      body: SafeArea(
        child: Center(
            child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
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
                  Spacer(),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "Pengaturan",
                      style:
                          poppins.copyWith(fontWeight: semiBold, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 75,
                    height: 75,
                    decoration: BoxDecoration(
                        color: backgroundColor3, shape: BoxShape.circle),
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Text(
                        getInitials(loginData.data.namaLengkap.toString()),
                        style: poppins.copyWith(
                          fontWeight: regular,
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textData("Nama", loginData.data.namaLengkap.toString()),
                        textData("Email", loginData.data.email.toString()),
                        textData("Telefon", loginData.data.telp.toString()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                var dataUpdate = {
                  "id": loginData.data.id.toString(),
                  "username": loginData.data.username.toString(),
                  "nama_lengkap": loginData.data.namaLengkap.toString(),
                  "email": loginData.data.email.toString(),
                  "telp": loginData.data.telp.toString(),
                  "alamat": loginData.data.alamat.toString()
                };
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfilEdit(
                            data: dataUpdate,
                            isPassword: false,
                          )),
                ).then((value) => setState(() {
                      _getLatestProfil();
                    }));
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 10, right: 10),
                      child: const Icon(SolarIconsBold.pen),
                    ),
                    Text(
                      "Edit Profil",
                      style: poppins.copyWith(
                        fontWeight: regular,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfilEdit(
                            data: {},
                            isPassword: true,
                          )),
                ).then((value) => setState(() {}));
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 10, right: 10),
                      child: const Icon(SolarIconsBold.lock),
                    ),
                    Text(
                      "Ubah Kata Sandi",
                      style: poppins.copyWith(
                        fontWeight: regular,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 30),
              width: 150,
              child: ElevatedButton(
                onPressed: () {
                  authProvider.removeLoginData();
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/', (route) => false);
                },
                style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(
                        side: BorderSide(width: 1, color: Colors.red)),
                    backgroundColor: Colors.red),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    Text(
                      ' Logout',
                      style: poppins.copyWith(
                          fontWeight: semiBold, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )),
      ),
      backgroundColor: Colors.white,
    );
  }
}
