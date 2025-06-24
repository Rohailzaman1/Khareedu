import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:khareedu/controller/cart-price-Controller.dart';
import 'package:khareedu/controller/customer_token_Controller.dart';
import 'package:khareedu/model/cart_model.dart';
import 'package:khareedu/services/place_order_Services.dart';
import 'package:khareedu/utils/app-constant.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'ProductDetail.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  late String name;
  late String phone;
  late String address;
  late String Customertoken;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  final CartPriceController cartPriceController = Get.put(
    CartPriceController(),
  );
  User? user = FirebaseAuth.instance.currentUser;
  Razorpay  _razorpay = Razorpay();
  @override
  Widget build(BuildContext context) {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appconst.maincolor,
        title: Center(
          child: Text(
            "Checkout",
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
              Obx(
                () => Text(
                  "   ${cartPriceController.totalPrice.toStringAsFixed(1)}",
                ),
              ),
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
                      onPressed: () async {
                        ShowCustomeButtomSheet();
                        //......
                      },
                      child: Text("Confirm Order"),
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

  void ShowCustomeButtomSheet() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white, // Better contrast for text fields
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(Get.context!).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Important for bottom sheet height
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Name',
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.amber, width: 4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.number,

                decoration: InputDecoration(
                  hintText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.amber, width: 4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                autocorrect: true,
                controller: addressController,
                decoration: InputDecoration(
                  hintText: 'Home Address',
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.amber, width: 4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 10),

              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () async {
                    if (nameController.text.trim().isNotEmpty &&
                        phoneController.text.trim().isNotEmpty &&
                        addressController.text.trim().isNotEmpty) {
                       name = nameController.text.trim();
                       phone = phoneController.text.trim();
                       address = addressController.text.trim();
                       Customertoken = await getCustomerTokenController();
                      var options = {
                        'key': 'rzp_test_YghCO1so2pwPnx',
                        'amount': 1000,
                        'name': 'Acme Corp.',
                        'description': 'Fine T-Shirt',
                        'prefill': {
                          'contact': '8888888888',
                          'email': 'test@razorpay.com'
                        }
                      };
                      _razorpay.open(options);
                      PlaceOrder(
                        context: context,
                        customerName: name,
                        customerPhone: phone,
                        customerAddress: address,
                        customerToken: Customertoken,
                      );
                    } else {
                      Get.snackbar(
                        "Missing Info",
                        "Please fill all fields!",
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  },
                  icon: const Icon(Icons.check, color: Colors.white),
                  label: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      isScrollControlled: true, // Ensures proper keyboard behavior
    );
  }
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    PlaceOrder(
      context: context,
        customerName: name,
      customerPhone: phone,
      customerAddress: address,
      customerToken: Customertoken,
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }
  @override
  void dispose()
  {
    super.dispose();
    _razorpay.clear(); // Removes all listeners
  }
}

// print ("+${cartModel.productId});
