import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:khareedu/model/cart_model.dart';
import 'package:khareedu/utils/app-constant.dart';

import 'ProductDetail.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(


        backgroundColor: Appconst.maincolor,
        title: Center(
          child: Text(
            "Cart",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
        ),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('carts').doc(user!.uid).collection('cartOrders').get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Some Error"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CupertinoActivityIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No Product Found"));
          }

          if (snapshot != null) {

            return Container(
              child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final data =
                        snapshot.data!.docs[index].data() as Map<String, dynamic>;
                        CartModel cartModel = CartModel(
                          categoryId: data['categoryId'] ?? ' ',
                          categoryName: data['categoryName'] ?? ' ',
                          productName: data['productName'] ?? ' ',
                          productId: data['productId'] ?? ' ',
                          salePrice: data['salePrice'] ?? ' ',
                          fullPrice: data['fullPrice'] ?? ' ',
                          productImg: data['productImg'] ?? ' ',
                          deliveryTime: data['deliveryTime'] ?? ' ',
                          description: data['description'] ?? ' ',
                          createdDate: data['createdDate'] ?? ' ',
                          updatedDate: data['updatedDate'] ?? ' ',
                          productQuantity: data['productQuantity'] ?? ' ',
                          totalPrice: (data['totalPrice'] is int)
                              ? (data['totalPrice'] as int).toDouble()
                              : (data['totalPrice'] ?? 0.0),
                        );
                        return Card(
                          elevation: 5,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Appconst.secondarycolor,
                              backgroundImage: NetworkImage(cartModel.productImg[0]),
                            ),
                            title: Text(cartModel.productName),

                            subtitle: Row(
                              children: [
                                Text(cartModel.fullPrice),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    radius: 20,
                                    child: Icon(Icons.add, size: 20),
                                  ),
                                ),
                                CircleAvatar(
                                  radius: 20,
                                  child: Icon(Icons.remove, size: 20),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
              ),
            );

          }
          return Container();
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Sub Total", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(width: Get.width / 5),
              Text("1200"),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Material(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Appconst.secondarycolor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    width: Get.width / 2.1,
                    height: Get.height / 20,
                    child: TextButton(
                      onPressed: () {},
                      child: Text("CheckOut"),
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
}
