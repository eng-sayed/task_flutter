import 'dart:convert';

class ProductModel {
  int? id;
  String? name;
  String? description;
  String? price;
  String? image;
  bool? available;
  ProductModel({
    this.id,
    this.name,
    this.description,
    this.price,
    this.image,
    this.available,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (id != null) {
      result.addAll({'id': id});
    }
    if (name != null) {
      result.addAll({'name': name});
    }
    if (description != null) {
      result.addAll({'description': description});
    }
    if (price != null) {
      result.addAll({'price': price});
    }
    if (image != null) {
      result.addAll({'image': image});
    }
    if (available != null) {
      result.addAll({'available': available});
    }

    return result;
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      price: map['price']?.toString(),
      image: map['image'],
      available: map['available'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source));
}
