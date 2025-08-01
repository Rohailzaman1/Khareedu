import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:khareedu/controller/cart-price-Controller.dart';
import 'package:khareedu/model/cart_model.dart';
import 'package:khareedu/utils/app-constant.dart';

import 'CheckOutScreen.dart';
import 'ProductDetail.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  final CartPriceController cartPriceController = Get.put(CartPriceController());
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('carts')
            .doc(user!.uid)
            .collection('cartOrders')
            .snapshots(),
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
            cartPriceController.gettotalPrice();
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
                  // cartPriceController.gettotalPrice();
                  return SwipeActionCell(
                    key: ObjectKey(cartModel.productId),
                    trailingActions: <SwipeAction>[
                      SwipeAction(
                        title: "delete",
                        forceAlignmentToBoundary: true,
                        performsFirstActionWithFullSwipe: true,
                        onTap: (CompletionHandler handler) async {
                          await FirebaseFirestore.instance
                              .collection('carts')
                              .doc(user!.uid)
                              .collection('cartOrders')
                              .doc(cartModel.productId)
                              .delete();
                        },
                        color: Colors.red,
                      ),
                    ],
                    child: Card(
                      elevation: 5,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Appconst.secondarycolor,
                          backgroundImage: NetworkImage(
                            cartModel.productImg[0],
                          ),
                        ),
                        title: Text(cartModel.productName),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Qty: ${cartModel.productQuantity}"),
                                Text(
                                  "Total: Rs ${cartModel.totalPrice.toStringAsFixed(2)}",
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    if (cartModel.productQuantity > 0) {
                                      FirebaseFirestore.instance
                                          .collection('carts')
                                          .doc(user!.uid)
                                          .collection('cartOrders')
                                          .doc(cartModel.productId)
                                          .update({
                                            'productQuantity':
                                                cartModel.productQuantity - 1,
                                            'totalPrice':
                                                double.parse(
                                                  cartModel.fullPrice,
                                                ) *
                                                (cartModel.productQuantity - 1),
                                          });
                                    }
                                  },
                                  child: CircleAvatar(
                                    radius: 20,
                                    child: Text("-"),
                                  ),
                                ),
                                SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () async {
                                    if (cartModel.productQuantity >= 1) {
                                      FirebaseFirestore.instance
                                          .collection('carts')
                                          .doc(user!.uid)
                                          .collection('cartOrders')
                                          .doc(cartModel.productId)
                                          .update({

                                            'productQuantity':
                                                cartModel.productQuantity + 1,
                                            'totalPrice':
                                                double.parse(
                                                  cartModel.fullPrice,
                                                ) +
                                                double.parse(

                                                      cartModel.fullPrice,
                                                    ) *
                                                    (cartModel.productQuantity),
                                          });
                                    }
                                  },
                                  child: CircleAvatar(
                                    radius: 20,
                                    child: Text("+"),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
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
              SizedBox(width: Get.width / 15),
              Obx(() => Text(
                  "   ${cartPriceController.totalPrice.toStringAsFixed(1)}"
              )),
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
                      onPressed: () {
                       Get.to(()=>CheckOutScreen());
                      },
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

// print ("+${cartModel.productId});
