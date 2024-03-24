import 'package:e_shop/models/user_model.dart';
import 'package:e_shop/provider/auth_provider.dart';
import 'package:e_shop/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:placeholder_images/placeholder_images.dart';
import 'package:provider/provider.dart';

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

    Widget textData(String title, String data) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: poppins.copyWith(
                    fontWeight: semiBold,
                    color: Colors.black,
                  ),
                ),
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
                      "Profil Pengguna",
                      style:
                          poppins.copyWith(fontWeight: semiBold, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 150,
              height: 150,
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
            Expanded(
                child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  textData("Username", loginData.data.username.toString()),
                  textData("Nama", loginData.data.namaLengkap.toString()),
                  textData("Alamat", loginData.data.alamat.toString()),
                  textData("Email", loginData.data.email.toString()),
                  textData("Telefon", loginData.data.telp.toString()),
                ],
              ),
            )),
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
