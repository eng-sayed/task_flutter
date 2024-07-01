import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_flutter/features/product/domain/model/product_model.dart';
import '../../../core/data_source/dio_helper.dart';
import '../../../core/utils/Locator.dart';
import '../domain/model/cart_model.dart';
import '../domain/repository/repository.dart';
import 'product_states.dart';

class ProductCubit extends Cubit<ProductStates> {
  ProductCubit() : super(ProductInitial());
  static ProductCubit get(context) => BlocProvider.of(context);

  ProductRepository productRepository =
      ProductRepository(locator<DioService>());

  void getProducts() {
    emit(ProductLoading());
    productRepository.getProducts().then((products) {
      emit(ProductLoaded(products));
    }).catchError((error) {
      emit(ProductError(error.toString()));
    });
  }

  List<CartItem> cart = [];
  addProductToCart(CartItem cartItem) {
    final index = cart
        .indexWhere((element) => element.product?.id == cartItem.product?.id);
    if (index != -1) {
      cart[index].quantity = cart[index].quantity! + 1;
    } else {
      cart.add(cartItem);
    }
    emit(ProductCartAdded(cart));
  }

  removeProductFromCart(CartItem cartItem) {
    final index = cart
        .indexWhere((element) => element.product?.id == cartItem.product?.id);
    cart.removeAt(index);
    emit(ProductCartRemoved(cart));
  }

  addQuantity(CartItem cartItem) {
    final index = cart
        .indexWhere((element) => element.product?.id == cartItem.product?.id);
    if (index != -1) {
      cart[index].quantity = cart[index].quantity! + 1;
    }
    emit(ProductCartAdded(cart));
  }

  removeQuantity(CartItem cartItem) {
    final index = cart
        .indexWhere((element) => element.product?.id == cartItem.product?.id);
    if (index != -1) {
      cart[index].quantity = cart[index].quantity! - 1;
      if (cart[index].quantity == 0) {
        cart.removeAt(index);
      }
    }
    emit(ProductCartRemoved(cart));
  }

  getTotal() {
    return cart.fold(
        0, (previousValue, element) => previousValue + element.quantity!);
  }

  getTotalPrice() {
    return cart.fold(
        0,
        (previousValue, element) =>
            previousValue +
            (element.quantity! * int.parse(element.product!.price!)));
  }

  clearCart() {
    cart = [];
    emit(ProductCartRemoved(cart));
  }
}
