import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';
import 'package:khareedu/model/product_model.dart';
import 'package:khareedu/utils/app-constant.dart';

import 'ProductDetail.dart';

class AllProduct extends StatefulWidget {
  const AllProduct({super.key});

  @override
  State<AllProduct> createState() => _AllProductState();
}

class _AllProductState extends State<AllProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appconst.maincolor,
        title: Center(
          child: Text(
            "Product",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('products').get(),
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
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                ProductModel productModel = ProductModel(
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
                  isSale: data['isSale'] ?? ' ',
                );

                return GestureDetector(
                  onTap: ()=>Get.to(()=>AllProductDetail(productModel: productModel,),),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded( // This will force the image to stay within bounds
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedNetworkImage(
                                  imageUrl: productModel.productImg[0],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            productModel.productName,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                );



              },
            );
          }
          return Container();
        },
      ),
    );
  }
}
