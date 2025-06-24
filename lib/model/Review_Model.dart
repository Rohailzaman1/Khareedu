class ReviewModel {
  final String customerName;
  final String customerPhone;
  final String customerToken;
  final String customerId;
  final String feedBack;
  final String rating;
  final dynamic createdAt;

  ReviewModel({
    required this.customerName,
    required this.customerPhone,
    required this.customerToken,
    required this.customerId,
    required this.feedBack,
    required this.rating,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerDeviceToken': customerToken,
      'customerId': customerId,
      'feedBack': feedBack,
      'rating': rating,
      'createdAt': createdAt,
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> json) {
    return ReviewModel(
      customerName: json['customerName'],
      customerPhone: json['customerPhone'],
      customerToken: json['customerToken'],
      customerId: json['customerId'],
      feedBack: json['feedBack'],
      rating: json['rating'],
      createdAt: json['createdAt'],
    );
  }
}
