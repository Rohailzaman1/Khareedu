import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';
import 'package:khareedu/model/category_model.dart';
import 'package:khareedu/screen/user-panel/Single_Category_Product.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('categories').get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Some Error"));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CupertinoActivityIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No Category Found"));
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
                CategoryModel categoryModel = CategoryModel(
                  categoryId: data['categoryId'] ?? '',
                  categoryName: data['categoryName'] ?? '',
                  createdDate: data['createdDate'] ?? '',
                  upDate: data['upDate'] ?? '',
                  categoryImg: data['categoryImg'] ?? '',
                );
                return Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.to(
                          () => SingleCategoryProduct(
                            categoryId: categoryModel.categoryId,
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Container(
                          child: FillImageCard(
                            borderRadius: 20.0,
                            width: Get.width / 4,
                            heightImage: Get.height / 7,
                            imageProvider: CachedNetworkImageProvider(
                              categoryModel.categoryImg,
                            ),
                            title: Center(
                              child: Text(categoryModel.categoryName),
                            ),
                            footer: Center(child: Text("")),
                            // description: _content(),
                          ),
                        ),
                      ),
                    ),
                  ],
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
