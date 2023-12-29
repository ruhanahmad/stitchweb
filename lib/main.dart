import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:stitch_app_web_admin/views/dashboard_screens/dashboard_screens.dart';
import 'package:stitch_app_web_admin/views/screens/buyers_screen.dart';
import 'package:stitch_app_web_admin/views/screens/category_screen.dart';
import 'package:stitch_app_web_admin/views/screens/loginScreen.dart';
import 'package:stitch_app_web_admin/views/screens/order_screen.dart';
import 'package:stitch_app_web_admin/views/screens/product_screen.dart';
import 'package:stitch_app_web_admin/views/screens/upload_banner_screen.dart';
import 'package:stitch_app_web_admin/views/screens/vendors_screen.dart';
import 'package:stitch_app_web_admin/views/screens/withdrawal_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: kIsWeb || Platform.isAndroid
          ? FirebaseOptions(
              apiKey: "AIzaSyBLsUk_UX99GcOwcZrH70lC04RcsHN7aEk",
              appId: "1:260804900959:web:d2e66c6cc63e0af1c183ea",
              messagingSenderId: "260804900959",
              projectId: "tailer-9018a",
              storageBucket: "tailer-9018a.appspot.com",
            )
          : null);
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StitchNow Web Admin Pannel',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: 
       FirebaseAuth.instance.currentUser == null ?
      LoginScreen() : SideMenu(),
      //SideMenu(),
      builder: EasyLoading.init(),
    );
  }
}

class SideMenu extends StatefulWidget {
  static const String id = '\sideMenu';

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  Widget _selectedScreen = DashboardScreen();

  screnSelectore(item) {
    switch (item.route) {
      case CategoryScreen.id:
        setState(() {
          _selectedScreen = CategoryScreen();
        });

        break;
      case VendorsScreen.id:
        setState(() {
          _selectedScreen = VendorsScreen();
        });

        break;

      case BuyersScreen.id:
        setState(() {
          _selectedScreen = BuyersScreen();
        });

        break;

      case WithrawalScreen.id:
        setState(() {
          _selectedScreen = WithrawalScreen();
        });

        break;

      case OrderScreen.routeName:
        setState(() {
          _selectedScreen = OrderScreen();
        });

        break;

      case UploadBanners.id:
        setState(() {
          _selectedScreen = UploadBanners();
        });

        break;

      case ProductScreen.routeName:
        setState(() {
          _selectedScreen = ProductScreen();
        });

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(
        backgroundColor: Colors.lightBlue.shade900,
        title: const Text(
          'Admin Panel',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
           TextButton(
              onPressed: () async {
                 FirebaseAuth.instance.signOut();
                 Get.to(()=>LoginScreen());
              },
              child: Text('Signout',style: TextStyle(color: Colors.white),),
            ),
        ],
      ),
      sideBar: SideBar(
        items: const [
          AdminMenuItem(
            title: 'Vendors',
            route: VendorsScreen.id,
            icon: CupertinoIcons.person_3,
          ),
          AdminMenuItem(
            title: 'Buyers',
            route: BuyersScreen.id,
            icon: CupertinoIcons.person,
          ),
          AdminMenuItem(
            title: 'Withdrawal',
            route: WithrawalScreen.id,
            icon: CupertinoIcons.money_dollar,
          ),
          AdminMenuItem(
            title: 'Orders',
            route: OrderScreen.routeName,
            icon: CupertinoIcons.shopping_cart,
          ),
          AdminMenuItem(
            title: 'Categories',
            icon: Icons.category_rounded,
            route: CategoryScreen.id,
          ),
          AdminMenuItem(
            title: 'Upload Banner',
            icon: CupertinoIcons.add,
            route: UploadBanners.id,
          ),
          AdminMenuItem(
            title: 'Products',
            icon: CupertinoIcons.shopping_cart,
            route: ProductScreen.routeName,
          ),
        ],
        selectedRoute: VendorsScreen.id,
        onSelected: (item) {
          screnSelectore(item);

          // if (item.route != null) {
          //   Navigator.of(context).pushNamed(item.route!);
          // }
        },
        header: Container(
          height: 50,
          width: double.infinity,
          color: Colors.blueGrey.shade700,
          child: const Center(
            child: Text(
              ' STITCH NOW ',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        footer: Container(
          height: 50,
          width: double.infinity,
          color: const Color(0xff444444),
          child: const Center(
            child: Text(
              '@RuhanAhmad',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: _selectedScreen,
    );
  }
}
