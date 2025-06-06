import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String categoryId;
  final String categoryName;
  final String categoryImg;
  final String createdDate;
  final String upDate;

  CategoryModel({
    required this.categoryId,
    required this.categoryName,
    required this.createdDate,
    required this.upDate,
    required this.categoryImg
  });

  Map<String, dynamic> toMap() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
      'createdDate': createdDate,
      'upDate': upDate,
      'categoryImg': categoryImg,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> json) {
    return CategoryModel(
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      createdDate: json['createdDate'],
      upDate: json['upDate'],
        categoryImg :json['categoryImg'],
    );
  }


}
