class OrderModel {
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
  String customerId;
  bool status;
  String customerName;
  String customerPhone;
  String customerAddress;
  String customerToken;

  OrderModel({
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
    required this.productQuantity,
    required this.customerId,
    required this.status,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.customerToken
  });


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
      'productQuantity': productQuantity,
      'customerId': customerId,
      'status': status,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerAddress': customerAddress,
      'customerToken': customerToken,

    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> json) {
    return OrderModel(
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
      customerId: json['customerId'],
      status: json['status'],
      customerName: json['customerName'],
      customerPhone: json['customerPhone'],
      customerAddress: json['customerAddress'],
      customerToken: json['customerToken'],
    );
  }
}
