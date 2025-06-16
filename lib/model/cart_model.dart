class CartModel
{

  String categoryId;
  String categoryName;
  String productName;
  String productId;
  String salePrice;
  String fullPrice;
  List productImg;
  String deliveryTime;
  String description;
  dynamic createdDate;
  dynamic updatedDate;
  int productQuantity;
  final double totalPrice;

  CartModel({
    required this.categoryId,
    required this.categoryName,
    required this.productName,
    required this.productId,
    required this.salePrice,
    required this.fullPrice,
    required this.productImg,
    required this.deliveryTime,
    required this.description,
    required this.createdDate,
    required this.updatedDate,
    required this.totalPrice,
    required this.productQuantity

  }
      );


  Map<String, dynamic> toMap() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
      'productName': productName,
      'productId': productId,
      'salePrice': salePrice,
      'fullPrice': fullPrice,
      'productImg': productImg,
      'deliveryTime': deliveryTime,
      'description': description,
      'createdDate': createdDate,
      'updatedDate': updatedDate,
      'totalPrice': totalPrice,
      'productQuantity': productQuantity
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> json) {
    return CartModel(
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      productName: json['productName'],
      productId: json['productId'],
      salePrice: json['salePrice'],
      fullPrice: json['fullPrice'],
      productImg: json['productImg'],
      deliveryTime: json['deliveryTime'],
      description: json['description'],
      createdDate: json['createdDate'],
      updatedDate: json['updatedDate'],
      totalPrice: json['totalPrice'],
      productQuantity: json['productQuantity'],
    );
  }
}


