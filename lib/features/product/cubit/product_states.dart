import 'package:task_flutter/features/product/domain/model/product_model.dart';

import '../domain/model/cart_model.dart';

abstract class ProductStates {}

class ProductInitial extends ProductStates {}

class ProductLoading extends ProductStates {}

class ProductLoaded extends ProductStates {
  final List<ProductModel> products;

  ProductLoaded(this.products);
}

class ProductError extends ProductStates {
  final String error;

  ProductError(this.error);
}

class ProductCartAdded extends ProductStates {
  final List<CartItem> cart;

  ProductCartAdded(this.cart);
}

class ProductCartRemoved extends ProductStates {
  final List<CartItem> cart;

  ProductCartRemoved(this.cart);
}
