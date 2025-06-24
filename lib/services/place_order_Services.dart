import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:khareedu/model/order_model.dart';
import 'package:khareedu/screen/user-panel/main-screen.dart';
import 'package:khareedu/utils/app-constant.dart';

import 'generate_random_order_id.dart';

void PlaceOrder({
  required BuildContext context,
  required String customerName,
  required String customerPhone,
  required String customerAddress,
  required String customerToken,
}) async {
  EasyLoading.show(status: 'Please Wait');
  final User? user = FirebaseAuth.instance.currentUser;
  
   QuerySnapshot querysnapshoy=await FirebaseFirestore.instance.collection('carts').doc(user!.uid).collection('cartOrders').get();
  List<DocumentSnapshot> documentSnapshot =querysnapshoy.docs;

  for (var docs in documentSnapshot)
    {
            Map<String , dynamic>? data= docs.data() as Map<String, dynamic>;
            String orderId = generateOrderId();

            OrderModel orderModel= OrderModel(
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
              customerId: user.uid,
              status: false,
              customerName: customerName,
              customerPhone: customerPhone,
              customerAddress:customerAddress,
              customerToken:customerToken ,
              totalPrice: (data['totalPrice'] is int)
                  ? (data['totalPrice'] as int).toDouble()
                  : (data['totalPrice'] ?? 0.0),
            );


            for(var x= 0; x<documentSnapshot.length;x++)
              {
                await FirebaseFirestore.instance.collection('orders').doc(user.uid).set({
                  'uId': user.uid,
                  'customerName':customerName,
                  'customerPhone':customerPhone,
                  'customerToken':customerToken,
                  'status': false,
                  'createdDate':DateTime.now(),
                });

                //Upload orders
                await FirebaseFirestore.instance
                    .collection('orders')
                    .doc(user.uid)
                    .collection('confirmOrder').doc(orderId).set(orderModel.toMap());
              }

              //Delete orders from cart

            await FirebaseFirestore.instance
                .collection('carts')
                .doc(user.uid)
                .collection('cartOrders').doc(orderModel.productId.toString()).delete()
            .then((value){
              print('cart Product Deleted $orderModel.productId.toString()');
            });
    }
  Get.snackbar(
      backgroundColor: Appconst.secondarycolor,
      colorText: Colors.white,
      duration: Duration(seconds: 5),
      'Order Confirm',

      'Thanks');
  EasyLoading.dismiss();
  Get.offAll(()=>MainScreen());
}


