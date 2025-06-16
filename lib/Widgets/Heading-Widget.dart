import 'package:flutter/material.dart';
import 'package:khareedu/utils/app-constant.dart';

class HeadingWidget extends StatelessWidget {
  final String CategoryName;
  final String CategorySub;
  final String SeeMoreText;
  final VoidCallback onTap;

   HeadingWidget({super.key, required this.CategoryName,
    required this.CategorySub,
    required this.onTap,
    required this.SeeMoreText,});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column
              (
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    CategoryName,style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),),
                  Text(CategorySub,style: TextStyle(
                    fontSize: 10,

                  ),),
                ]
            ),
            GestureDetector(

              onTap: onTap,
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(color: Appconst.secondarycolor, width: 1.5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(SeeMoreText),
                  )),
            ),

          ],
        ),
      ),
    );
  }
}
