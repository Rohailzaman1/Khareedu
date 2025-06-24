import 'dart:math';

String generateOrderId()
 {
DateTime now = DateTime.now();
int RandomId = Random().nextInt(99999999);
String id = '${now.microsecondsSinceEpoch}_$RandomId';
return id;
}
