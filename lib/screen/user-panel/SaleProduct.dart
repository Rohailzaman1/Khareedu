import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';
import 'package:khareedu/model/category_model.dart';
import 'package:khareedu/model/product_model.dart' show ProductModel;
import 'package:khareedu/utils/app-constant.dart';
import 'ProductDetail.dart';
import 'Single_Category_Product.dart';

class SaleProduct extends StatefulWidget {
  const SaleProduct({super.key});

  @override
  State<SaleProduct> createState() => _SaleProductState();
}

class _SaleProductState extends State<SaleProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appconst.maincolor,
        title: const Center(
          child: Text(
            "Product",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('products').where('isSale',isEqualTo: false).get(),
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



          return  Container(
              child: GridView.builder(
                itemCount: snapshot.data!.docs.length,
                
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 3 / 5,
                ),
                itemBuilder: (context, index) {
                  final data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  // final productModel = ProductModel.fromMap(data);
                  ProductModel productModel = ProductModel(
                    categoryId: data['categoryId'],
                    categoryName: data['categoryName'],
                    productName: data['productName'],
                    productId: data['productId'],
                    salePrice: data['salePrice'],
                    fullPrice: data['fullPrice'],
                    productImg: data['productImg'],
                    deliveryTime: data['deliveryTime'],
                    description: data['description'],
                    createdDate: data['createdDate'],
                    updatedDate: data['updatedDate'],
                    isSale: data['isSale'],
                  );

                  return  GestureDetector(
                    onTap: ()=>Get.to(()=>AllProductDetail(productModel: productModel,),),
                    child: FillImageCard(
                        borderRadius: 20.0,
                        width: Get.width / 2,
                        heightImage: Get.height * 0.13,
                        imageProvider: CachedNetworkImageProvider(productModel.productImg[0],),
                        title: Center(
                          child: Text(
                            productModel.productName,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      footer:  Row(
                        children: [
                          Text(productModel.fullPrice,style: TextStyle(fontSize: 10),),
                          SizedBox(
                            width: 5,
                          ),
                          Text(productModel.salePrice,style: TextStyle(fontSize: 10,decoration: TextDecoration.lineThrough,color: Appconst.secondarycolor,),),
                        ],
                      ),
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
