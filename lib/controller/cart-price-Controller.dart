import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class CartPriceController extends GetxController
{

  RxDouble totalPrice = 0.0.obs;

  User? user = FirebaseAuth.instance.currentUser;

  @override
  void onInit()
  {
    gettotalPrice();
    super.onInit();
  }

  void gettotalPrice()
  async{

            final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
                .instance
                .collection('carts')
                .doc(user!.uid).collection('cartOrders').get();


            double sum = 0.0;

            for (final doc in snapshot.docs)
              {
                final data = doc.data();
                  if(data != null && data.containsKey('productQuantity'))
                    {
                      sum += (data['totalPrice']as num).toDouble();
                      // sum = sum + (data['productQuantity' as num]).toDouble;
                    }

              }

            totalPrice.value = sum;
  }


}