import 'product_model.dart';

class CartItem {
  ProductModel? product;
  int? quantity;

  CartItem({
    this.quantity,
    this.product,
  });
  CartItem.fromMap(Map<String, dynamic> map) {
    quantity = map['quantity'];
    product = ProductModel.fromMap(map['product']);
  }
}
