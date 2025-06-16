import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';
import 'package:khareedu/model/category_model.dart';
import 'package:khareedu/model/product_model.dart';
import 'package:khareedu/screen/user-panel/ProductDetail.dart';
import 'package:khareedu/screen/user-panel/Single_Category_Product.dart';
import 'package:khareedu/utils/app-constant.dart';

class AllProductWidget extends StatelessWidget {
  const AllProductWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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

        if (snapshot.data != null) {
          return Container(
            height: Get.height / 4,
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final data =
                snapshot.data!.docs[index].data() as Map<String, dynamic>;
                ProductModel productModel = ProductModel(
                  categoryId: snapshot.data!.docs[index]['categoryId'],
                  categoryName: snapshot.data!.docs[index]['categoryName'],
                  productName: snapshot.data!.docs[index]['productName'],
                  productId: snapshot.data!.docs[index]['productId'],
                  salePrice: snapshot.data!.docs[index]['salePrice'],
                  fullPrice: snapshot.data!.docs[index]['fullPrice'],
                  productImg: snapshot.data!.docs[index]['productImg'],
                  deliveryTime: snapshot.data!.docs[index]['deliveryTime'],
                  description: snapshot.data!.docs[index]['description'],
                  createdDate: snapshot.data!.docs[index]['createdDate'],
                  updatedDate: snapshot.data!.docs[index]['updatedDate'],
                  isSale: snapshot.data!.docs[index]['isSale'],
                );
                return GestureDetector(
                  onTap: ()=>Get.to(()=>AllProductDetail(productModel: productModel,),),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Container(
                          child: FillImageCard(
                            borderRadius: 20.0,
                            width: Get.width / 4,
                            heightImage: Get.height / 8,
                            imageProvider: CachedNetworkImageProvider(
                              productModel.productImg[0],
                            ),
                            title: Center(child: Text(productModel.productName)),
                            footer: Row(
                              children: [
                                Text(productModel.fullPrice,style: TextStyle(fontSize: 10),),
                                SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),
                          ),
                          // description: _content(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }
        return Container();
      },
    );
  }
}
