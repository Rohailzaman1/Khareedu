import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khareedu/model/product_model.dart';
import 'package:khareedu/utils/app-constant.dart';

class SingleCategoryProduct extends StatefulWidget {
  final String categoryId;

  const SingleCategoryProduct({super.key, required this.categoryId});

  @override
  State<SingleCategoryProduct> createState() => _SingleCategoryProductState();
}

class _SingleCategoryProductState extends State<SingleCategoryProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appconst.maincolor,
        title: const Center(
          child: Text(
            "Products",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('products')
            .where('categoryId', isEqualTo: widget.categoryId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Some Error"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CupertinoActivityIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No Product Found"));
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              itemCount: snapshot.data!.docs.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // better spacing for images
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.75,
              ),

              itemBuilder: (context, index) {
                final data =
                snapshot.data!.docs[index].data() as Map<String, dynamic>;

                final product = ProductModel(
                  categoryId: data['categoryId'] ?? '',
                  categoryName: data['categoryName'] ?? '',
                  productName: data['productName'] ?? '',
                  productId: data['productId'] ?? '',
                  salePrice: data['salePrice'] ?? '',
                  fullPrice: data['fullPrice'] ?? '',
                  productImg: data['productImg'] ?? [],
                  deliveryTime: data['deliveryTime'] ?? '',
                  description: data['description'] ?? '',
                  createdDate: data['createdDate'] ?? '',
                  updatedDate: data['updatedDate'] ?? '',
                  isSale: data['isSale'] ?? false,
                );

                final imageUrl = product.productImg.isNotEmpty
                    ? product.productImg[0]
                    : 'https://via.placeholder.com/150';

                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey.shade100,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            placeholder: (context, url) => const Center(child: CupertinoActivityIndicator()),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: Text(
                          product.productName,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
