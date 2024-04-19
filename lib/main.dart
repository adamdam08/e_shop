import 'package:e_shop/provider/auth_provider.dart';
import 'package:e_shop/provider/product_provider.dart';
import 'package:e_shop/provider/settings_provider.dart';
import 'package:e_shop/ui/cart/cart.dart';
import 'package:e_shop/ui/category/category.dart';
import 'package:e_shop/ui/home/home.dart';
import 'package:e_shop/ui/login/login.dart';
import 'package:e_shop/ui/profile/profile_page.dart';
import 'package:e_shop/ui/promo/promo.dart';
import 'package:e_shop/provider/cart_provider.dart';
import 'package:e_shop/provider/customer_provider.dart';
import 'package:e_shop/provider/page_provider.dart';
import 'package:e_shop/theme/theme.dart';
import 'package:e_shop/ui/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';

import 'ui/customer/customer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => PageProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => CustomerProvider()),
        ChangeNotifierProvider(create: (context) => SettingsProvider()),
        ChangeNotifierProvider(create: (context) => ProductProvider()),
      ],
      child: MaterialApp(
          title: 'E-Shop',
          builder: (BuildContext context, Widget? child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaleFactor: 1.0,
              ),
              child: child!,
            );
          },
          theme: ThemeData(
            // This is the theme of your application.
            //
            // TRY THIS: Try running your application with "flutter run". You'll see
            // the application has a blue toolbar. Then, without quitting the app,
            // try changing the seedColor in the colorScheme below to Colors.green
            // and then invoke "hot reload" (save your changes or press the "hot
            // reload" button in a Flutter-supported IDE, or press "r" if you used
            // the command line to start the app).
            //
            // Notice that the counter didn't reset back to zero; the application
            // state is not lost during the reload. To reset the state, use hot
            // restart instead.
            //
            // This works for code too, not just values: Most code changes can be
            // tested with just a hot reload.
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          debugShowCheckedModeBanner: false,
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/':
                return PageTransition(
                    child: const SplashScreenPage(),
                    type: PageTransitionType.fade);
              case '/login':
                return PageTransition(
                    child: const LoginPage(), type: PageTransitionType.fade);
              case '/home':
                return PageTransition(
                    child: const BottomNavigationBarExample(),
                    type: PageTransitionType.fade);
              case '/profile':
                return PageTransition(
                    child: const ProfilePage(), type: PageTransitionType.fade);
              default:
                return null;
            }
          }),
    );
  }
}

class BottomNavigationBarExample extends StatefulWidget {
  const BottomNavigationBarExample({super.key});

  @override
  State<BottomNavigationBarExample> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  static const List<Widget> _widgetOptions = <Widget>[
    Home(),
    Category(),
    Promo(),
    Customer(),
    Cart()
  ];

  @override
  Widget build(BuildContext context) {
    PageProvider pageProvider = Provider.of(context);
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: true,
        left: true,
        right: true,
        maintainBottomViewPadding: true,
        child: Center(
          child: _widgetOptions.elementAt(pageProvider.currentIndex),
        ),
      ),
      bottomNavigationBar: bottomNavBar(pageProvider),
    );
  }

  Widget bottomNavBar(PageProvider pageProvider) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(25),
      ),
      child: Theme(
        data: ThemeData(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        child: BottomAppBar(
          height: 70,
          elevation: 0,
          color: backgroundColor3,
          notchMargin: 10,
          shape: const CircularNotchedRectangle(),
          clipBehavior: Clip.antiAlias,
          child: BottomNavigationBar(
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: const Icon(Icons.home),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: const Icon(Icons.menu),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: const Icon(Icons.percent),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: const Icon(SolarIconsBold.usersGroupRounded),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: const Icon(Icons.shopping_cart),
                ),
                label: '',
              ),
            ],
            currentIndex: pageProvider.currentIndex,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.black,
            showUnselectedLabels: false,
            showSelectedLabels: false,
            backgroundColor: Colors.transparent,
            onTap: (index) {
              if (context.mounted) {
                setState(() {
                  pageProvider.currentIndex = index;
                });
              }
            },
          ),
        ),
      ),
    );
  }
}
