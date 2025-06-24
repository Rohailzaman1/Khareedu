import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:khareedu/model/Review_Model.dart';
import 'package:khareedu/model/order_model.dart';

class Addreview extends StatefulWidget {
  final OrderModel orderModel;

   Addreview({super.key, required this.orderModel});

  @override
  State<Addreview> createState() => _AddreviewState();
}

class _AddreviewState extends State<Addreview> {
  User? user = FirebaseAuth.instance.currentUser;

  double productRating =0;
  final TextEditingController feedback = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Review")),
        backgroundColor: Colors.red,
      ),
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Add your review",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            RatingBar.builder(
              initialRating: 3,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) =>
                  Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (rating) {
                   productRating =rating;
                print(rating);
                setState(() {

                });
              },
            ),
            Text("Feedback"),
            TextField(
              controller: feedback,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: 'Share Your Feedback',
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.amber, width: 4),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            ElevatedButton(onPressed: (){
              String Review = feedback.text.trim();

              ReviewModel reviewModel = ReviewModel(
                  customerName: widget.orderModel.customerName,
                  customerPhone: widget.orderModel.customerPhone,
                  customerToken: widget.orderModel.customerToken,
                  customerId: widget.orderModel.customerId,
                  feedBack: Review,
                  rating: productRating.toString(),
                  createdAt: DateTime.now());

              FirebaseFirestore.instance
                  .collection('products')
                  .doc(widget.orderModel.productId)
                  .collection('reviews')
                  .doc(user!.uid).set(reviewModel.toMap());
            }, child: Text("Add"))
          ],
        ),
      ),
    );
  }
}
