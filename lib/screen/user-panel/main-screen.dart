import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:khareedu/Widgets/All-Product-Widget.dart';
import 'package:khareedu/Widgets/Category-Widget.dart';
import 'package:khareedu/Widgets/Flash-Sale-Widget.dart';
import 'package:khareedu/Widgets/Heading-Widget.dart';
import 'package:khareedu/utils/Custom_banners.dart';
import 'package:khareedu/utils/Custom_drawer.dart';
import 'package:khareedu/utils/app-constant.dart';

import 'Cart.dart';
import 'Category.dart';
import 'AllProduct.dart';
import 'SaleProduct.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseAuth _auth = FirebaseAuth.instance;
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Appconst.maincolor,
          title: Text("KHAREEDU",style: TextStyle(color: Colors.black87,fontSize: 20)),
          centerTitle: true,
          actions: [
            GestureDetector(
              onTap: () =>Get.to(()=>Cart()),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.shopping_cart),
              ),
            ),

    //         GestureDetector(
    // onTap: ()=>Get.to(()=>MapView()),
    //     child:  Icon(Icons.location_on)),
          ],
        ),

      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child:Column(
            children: [
              SizedBox(
                height: Get.height/90,
              ),
              //..............................//
              CustomeBanners(),
              Divider(
                thickness: 2,
                color: Colors.grey,
              ),

              HeadingWidget(
                CategoryName: 'Category',
                CategorySub: 'You will Get Here Each and EveryThing! Happy Shopping',
                SeeMoreText: 'See More',
                onTap: () {   Get.to(()=>Category());
                },
               ),
              CategoryWidget(),

              HeadingWidget(
                CategoryName: 'Flash Sales',
                CategorySub: 'According To Your Budget',
                SeeMoreText: 'See More',
                onTap: () { Get.to(()=>SaleProduct()); },
              ),
              FlashSaleWidget(),

              HeadingWidget(
                CategoryName: 'All Products',
                CategorySub: 'Here`s All the Products',
                SeeMoreText: 'See More',
                onTap: () {Get.to(()=>AllProduct());  },
              ),
              AllProductWidget(),
              //..............................//
              // CustomeCategory(CategoryName: 'Category',
              //   CategorySub: 'Cotton and Some thing Other in the filed',
              //   onTap: () {
              //   Get.to(()=>Category());
              //   },
              //   SeeMoreText: 'See More',),
              // CategoryWidget(),

              //..............................//
              // FlashWidget(ProductName: 'Flash Product', onTap: () {
              //   Get.to(()=>SaleProduct());
              // }, SeeMoreText: 'See More', Subcategoty: 'Cotton and Some thing Other in the filed',),
              // SaleProduct(),
              // //..............................//
              // CustomeCategory(CategoryName: 'All Products',
              //   CategorySub: 'Cotton and Some thing Other in the filed',
              //   onTap: () {
              //     Get.to(()=>AllProduct());
              //   }, SeeMoreText: 'See More',),
              //   AllProduct(),
              //..............................//
              // SizedBox(
              //   height: 200,
              //   child: SaleProduct(),
              // ),
            ],
          ),
        ),

      ),
    );
  }
}
