import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_flutter/core/extensions/context_extensions.dart';
import 'package:task_flutter/core/utils/extentions.dart';
import '../../../../shared/widgets/customtext.dart';
import '../../../../shared/widgets/network_image.dart';
import '../../cubit/product_cubit.dart';
import '../../cubit/product_states.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductCubit, ProductStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        final cubit = ProductCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: const CustomText("Cart Screen"),
            actions: [],
          ),
          body: SafeArea(
            child: ListView.builder(
              itemCount: cubit.cart.length,
              itemBuilder: (context, index) {
                final item = cubit.cart[index];
                return Container(
                  height: 150,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: context.background,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: NetworkImagesWidgets(
                        item.product?.image ?? "",
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    8.pw,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomText(item.product?.name ?? ""),
                        CustomText(item.product?.description ?? ""),
                        CustomText(item.product?.price ?? ""),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        IconButton(
                            onPressed: () {
                              cubit.removeProductFromCart(item);
                            },
                            icon: Icon(Icons.delete)),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                cubit.addQuantity(item);
                              },
                              icon: const Icon(Icons.add),
                            ),
                            CustomText(item.quantity.toString()),
                            IconButton(
                              onPressed: () {
                                cubit.removeQuantity(item);
                              },
                              icon: const Icon(Icons.remove),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ]),
                );
              },
            ),
          ),
          bottomNavigationBar: Container(
            height: 150,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.background,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText("Total Quantity:"),
                    CustomText(cubit.getTotal().toString()),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText("Total Price:"),
                    CustomText(cubit.getTotalPrice().toString()),
                  ],
                ),
                // clear cart
                ElevatedButton(
                  onPressed: () {
                    cubit.clearCart();
                  },
                  child: const CustomText(
                    "Clear Cart",
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
