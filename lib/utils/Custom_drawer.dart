import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:khareedu/utils/app-constant.dart';

import '../screen/auth/welcome_screen.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});


  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseAuth _auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.deepOrange,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
          ),
      ),
      child: Wrap(
        runSpacing: 10,
        children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 30,horizontal:10 ),
                child: Container(
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.only(
                   )
                 ),
                  child: ListTile(
                    titleAlignment: ListTileTitleAlignment.center,
                    title: Text('Rohail'),
                    subtitle: Text("Version 1.3.2"),
                    leading: CircleAvatar(
                     backgroundColor: Appconst.secondarycolor,
                      child: Text("R"),
                    ),
                  ),
                ),
              ),
          Divider(
            indent: 10,
            endIndent: 10,
            thickness: 2,
            color: Colors.grey,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: ListTile(
              title: Text("Home"),
              leading: Icon(Icons.home),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: ListTile(
              title: Text("Product"),
              leading: Icon(Icons.production_quantity_limits),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: ListTile(
              title: Text("Order"),
              leading: Icon(Icons.shopping_bag),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: ListTile(
              title: Text("Contact"),
              leading: Icon(Icons.contact_phone),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: ListTile(
              onTap: () async 
              {
                await _auth.signOut();
                await googleSignIn.signOut();
                Get.offAll(()=>WelcomeScreen());
              },
              title: Text("Logout"),
              leading: Icon(Icons.logout_outlined),
            ),
          ),
        ],
      ),
      
    );
  }
}
