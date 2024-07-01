import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_flutter/core/extensions/all_extensions.dart';
import 'package:task_flutter/core/utils/extentions.dart';
import 'package:task_flutter/features/product/domain/model/cart_model.dart';
import 'package:task_flutter/features/product/domain/model/product_model.dart';
import 'package:task_flutter/shared/widgets/customtext.dart';
import 'package:task_flutter/shared/widgets/loadinganderror.dart';
import 'package:task_flutter/shared/widgets/network_image.dart';
import '../../../../core/Router/Router.dart';
import '../../cubit/product_cubit.dart';
import '../../cubit/product_states.dart';
import '../widgets/widgets.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  void initState() {
    super.initState();
  }

  List<ProductModel> products = [];
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductCubit, ProductStates>(
      listener: (context, state) {
        if (state is ProductLoaded) {
          products = state.products;
        }
      },
      builder: (context, state) {
        final cubit = ProductCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: const CustomText("Product Screen"),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.cartScreen);
                },
                icon: const Icon(Icons.shopping_cart),
              ),
            ],
          ),
          body: LoadingAndError(
            isError: state is ProductError,
            isLoading: state is ProductLoading,
            function: () => cubit.getProducts,
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final item = products[index];
                return ProductWidget(
                  item: item,
                  addToCart: () => cubit.addProductToCart(CartItem(
                    product: item,
                    quantity: 1,
                  )),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
