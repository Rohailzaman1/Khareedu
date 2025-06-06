import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';
import 'package:khareedu/model/category_model.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({super.key});

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
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


        if(snapshot.data !=null)
          {
            return Container(
              height: Get.height / 4,
              child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index)

                  {
                    CategoryModel categoryModel = CategoryModel(
                        categoryId: snapshot.data!.docs[index]['categoryId'],
                        categoryName: snapshot.data!.docs[index]['categoryName'],
                        createdDate: snapshot.data!.docs[index]['createdDate'],
                        upDate: snapshot.data!.docs[index]['upDate'],
                        categoryImg: snapshot.data!.docs[index]['categoryImg'],);
                        return Row(
                          children: [
                            Padding(padding: EdgeInsets.all(5),
                            child: Container(
                              child:
                              FillImageCard(
                                borderRadius: 20.0,
                                width: Get.width / 4,
                                heightImage: Get.height / 7,
                                imageProvider: CachedNetworkImageProvider(
                                  categoryModel.categoryImg
                                ),
                                title: Center(child: Text(categoryModel.categoryName)),
                                footer: Center(child: Text("data")),
                                // description: _content(),
                              ),
                            ),
                            )

                          ],


                        );
                  }
              ),

            );

          }
        return Container();
      },
    );
  }
}
        // return SizedBox(
        //   height: Get.height / 4,
        //   child: ListView.builder(
        //     itemCount: snapshot.data!.docs.length,
        //     shrinkWrap: true,
        //     scrollDirection: Axis.horizontal,
        //     itemBuilder: (context, index) {
        //       final data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
        //       final categoryModel = CategoryModel(
        //         categoryId: data['categoryId'] ?? '',
        //         categoryName: data['categoryName'] ?? '',
        //         categoryImg: data['categoryImg'] ?? '',
        //         createdDate: data['createdDate'] ?? '',
        //         upDate: data['upDate'] ?? '',
        //       );
        //
        //       return Padding(
        //         padding: const EdgeInsets.all(8.0),
        //         child: FillImageCard(
        //           borderRadius: 25,
        //           width: Get.width / 4,
        //           heightImage: Get.height / 7,
        //           imageProvider: CachedNetworkImageProvider(categoryModel.categoryImg),
        //           title: Padding(
        //             padding: const EdgeInsets.all(8.0),
        //             child: Text(categoryModel.categoryName),
        //           ),
        //         ),
        //       );
        //     },
        //   ),
        // );
