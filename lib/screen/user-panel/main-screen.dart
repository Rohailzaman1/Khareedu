import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:khareedu/utils/Category_Widget.dart';
import 'package:khareedu/utils/Custom_banners.dart';
import 'package:khareedu/utils/Custom_drawer.dart';
import 'package:khareedu/utils/Custome_Category.dart';
import 'package:khareedu/utils/app-constant.dart';

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
              CustomeBanners(),
              Divider(
                thickness: 2,
                color: Colors.grey,
              ),
              CustomeCategory(CategoryName: 'Jeans',
                CategorySub: 'Cotton and Some thing Other in the filed',
                onTap: () {  },
                SeeMoreText: 'See More',),
              CategoryWidget(),
            ],
          )

          ,
        ),

      ),
    );
  }
}
