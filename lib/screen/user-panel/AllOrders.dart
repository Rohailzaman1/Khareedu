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
import 'package:khareedu/model/order_model.dart';
import 'package:khareedu/screen/user-panel/AddReview.dart';
import 'package:khareedu/utils/app-constant.dart';

import 'CheckOutScreen.dart';
import 'ProductDetail.dart';

class AllOrders extends StatefulWidget {

  const AllOrders({super.key});

  @override
  State<AllOrders> createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders> {
  final CartPriceController cartPriceController = Get.put(CartPriceController());
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appconst.maincolor,
        title: Center(
          child: Text(
            "All Orders",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .doc(user!.uid)
            .collection('confirmOrder').snapshots(),
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
                  OrderModel orderModel = OrderModel(
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
                    customerId: data['customerId'],
                    status:data['status'] ,
                    customerName: data['customerName'],
                    customerPhone: data['customerPhone'],
                    customerAddress: data['customerAddress'],
                    customerToken: data['customerToken'],

                    totalPrice: (data['totalPrice'] is int)
                        ? (data['totalPrice'] as int).toDouble()
                        : (data['totalPrice'] ?? 0.0),

                  );
                  // cartPriceController.gettotalPrice();
               return SwipeActionCell(
                    key: ObjectKey(orderModel.productId),
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
                              .doc(orderModel.productId)
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
                            orderModel.productImg[0],
                          ),
                        ),
                        title: Text(orderModel.productName),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Qty: ${orderModel.productQuantity}"),
                                Text(
                                  "Total: Rs ${orderModel.totalPrice.toStringAsFixed(2)}",
                                ),
                              ],

                            ),


                            orderModel.status !=true ? Text("Pending" ,
                            style: TextStyle(color: Colors.green,fontSize: 10),) : Text("Deliver",  style: TextStyle(
                              color: Colors.red,fontSize: 10),),
                          ],
                        ),
                        trailing: ElevatedButton(onPressed: (){
                                              Get.to(()=>Addreview(orderModel:orderModel));
                        }, child: Text("Review")

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

    );
  }
}

// print ("+${cartModel.productId});
