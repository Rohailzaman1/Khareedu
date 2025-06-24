import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart' show FillImageCard;
import 'package:khareedu/model/Review_Model.dart';
import 'package:khareedu/model/cart_model.dart';
import 'package:khareedu/model/category_model.dart' show CategoryModel;
import 'package:khareedu/model/product_model.dart';
import 'package:khareedu/screen/user-panel/Single_Category_Product.dart';
import 'package:khareedu/utils/app-constant.dart';

import 'Cart.dart';

class AllProductDetail extends StatefulWidget {
  ProductModel productModel;
  AllProductDetail({super.key, required this.productModel});

  @override
  State<AllProductDetail> createState() => _AllProductDetailState();
}

class _AllProductDetailState extends State<AllProductDetail> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () =>Get.to(()=>Cart()),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.shopping_cart),
            ),
          ),
        ],
        title: Text("Product Detail"),
        backgroundColor: Appconst.maincolor,
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(height: Get.height / 60),
            CarouselSlider(
              items: widget.productModel.productImg
                  .map(
                    (imgUrl) => ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: CachedNetworkImage(
                        imageUrl: imgUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        placeholder: (context, url) => const ColoredBox(
                          color: Colors.white,
                          child: CupertinoActivityIndicator(),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  )
                  .toList(),
              options: CarouselOptions(
                height: 180, // or whatever height suits your design
                autoPlay: true, // 🔄 Auto-slide enabled
                autoPlayInterval: Duration(
                  seconds: 3,
                ), // ⏱ Interval between slides
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                enlargeCenterPage: true, // optional for effect
                viewportFraction: 0.9,
                aspectRatio: 16 / 9,
                initialPage: 0,
                enableInfiniteScroll: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Name: " + widget.productModel.productName,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Icon(Icons.favorite_border_outlined),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            widget.productModel.isSale == true &&
                                    widget.productModel.salePrice != ''
                                ? Text(
                                    "Sale Price: " +
                                        widget.productModel.salePrice,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : Text(
                                    "Full Price: " +
                                        widget.productModel.fullPrice,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Description: " + widget.productModel.description,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Material(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Appconst.secondarycolor,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                width: Get.width / 3,
                                height: Get.height / 16,
                                child: TextButton(
                                  child: Text(
                                    "Whatsapp",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    // Get.offAll(SignIn());
                                  },
                                ),
                              ),
                            ),
                          ),
                          Material(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Appconst.secondarycolor,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                width: Get.width / 3,
                                height: Get.height / 16,
                                child: TextButton(
                                  child: Text(
                                    "Add to Cart",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () async {
                                    // Get.offAll(SignIn());
                                    await checkproductExisting(uId: user!.uid);
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            FutureBuilder(

              future: FirebaseFirestore.instance.collection('products').doc(widget.productModel.productId).collection('reviews').get(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("Some Error"));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CupertinoActivityIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No Reviews Found"));
                }
                if(snapshot!=null)
                  {
                   return Expanded(
                     child: ListView.builder(
                         itemCount: snapshot.data!.docs.length,

                         itemBuilder: (context, index)
                         {
                              var data = snapshot.data!.docs[index];
                              ReviewModel reviewModel = ReviewModel(
                                  customerName: data['customerName'],
                                  customerPhone: data['customerPhone'],
                                  customerToken: data['customerDeviceToken'],
                                  customerId: data['customerId'],
                                  feedBack: data['feedBack'],
                                  rating: data['rating'],
                                  createdAt: data['createdAt']);

                              return Card(
                                elevation: 5,
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.grey.shade300,
                                    child: Text(
                                      reviewModel.customerName.isNotEmpty
                                          ? reviewModel.customerName[0].toUpperCase()
                                          : "?",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    reviewModel.customerName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 4),
                                      Text(
                                        reviewModel.feedBack,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(Icons.star, color: Colors.amber, size: 16),
                                          SizedBox(width: 4),
                                          Text(
                                            reviewModel.rating,
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ],
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
          ],
        ),
      ),
    );
  }

  Future<void> checkproductExisting({required String uId}) async {
    final int  Quantity = 1;
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection('carts')
        .doc(uId)
        .collection('cartOrders')
        .doc(widget.productModel.productId.toString());

    DocumentSnapshot snapshot = await documentReference.get();
    if (snapshot.exists) {
      int incrementQuantity = snapshot['productQuantity'];
      int updateQuantity = incrementQuantity + Quantity;
      double totalPrice =
          double.parse(
            widget.productModel.isSale
                ? widget.productModel.salePrice
                : widget.productModel.fullPrice,
          ) *
          updateQuantity;
      await documentReference.update({
        'productQuantity': updateQuantity,
        'totalPrice': totalPrice,
        'updatedDate': DateTime.now(),
      });
      print("Product Exit");
    } else {
      await FirebaseFirestore.instance.collection('carts').doc(uId).set({
        'uId': uId,
        'createdDate': DateTime.now(),
      });
      print("Product Added");
      CartModel cartModel = CartModel(
        categoryId: widget.productModel.categoryId,
        categoryName: widget.productModel.categoryName,
        productName: widget.productModel.productName,
        productId: widget.productModel.productId,
        salePrice: widget.productModel.salePrice,
        fullPrice: widget.productModel.fullPrice,
        productImg: widget.productModel.productImg,
        deliveryTime: widget.productModel.deliveryTime,
        description: widget.productModel.description,
        createdDate: DateTime.now(),
        updatedDate: DateTime.now(),
        totalPrice: double.parse( widget.productModel.isSale
            ? widget.productModel.salePrice
            : widget.productModel.fullPrice,),
        productQuantity: 1,
      );
      await documentReference.set(cartModel.toMap());
    }
  }
}
