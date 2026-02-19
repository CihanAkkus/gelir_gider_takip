import 'package:flutter/cupertino.dart';

class CategoryModel {
  final String id;
  final String name;
  final int iconCodePoint;

  CategoryModel({
    required this.id,
    required this.name,
    required this.iconCodePoint,
  });

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "iconCodePoint": iconCodePoint};
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json["id"],
      name: json["name"],
      iconCodePoint: json["iconCodePoint"],
    );
  }

  IconData get iconData => IconData(iconCodePoint, fontFamily: 'MaterialIcons');

}
