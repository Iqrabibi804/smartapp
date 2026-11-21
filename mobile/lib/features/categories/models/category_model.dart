import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final String icon;

  CategoryModel({required this.id, required this.name, required this.icon});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String? ?? 'place',
    );
  }
}

IconData iconForCategory(String key) {
  switch (key) {
    case 'restaurant':
      return Icons.restaurant;
    case 'hotel':
      return Icons.hotel;
    case 'local_hospital':
      return Icons.local_hospital;
    case 'shopping_bag':
      return Icons.shopping_bag;
    case 'park':
      return Icons.park;
    case 'photo_camera':
      return Icons.photo_camera;
    case 'mosque':
      return Icons.mosque;
    default:
      return Icons.place;
  }
}
