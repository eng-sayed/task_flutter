import 'package:flutter/material.dart';
import 'package:task_flutter/core/extensions/context_extensions.dart';
import 'package:task_flutter/core/utils/extentions.dart';

import '../../../../core/Router/Router.dart';
import '../../../../shared/widgets/customtext.dart';
import '../../../../shared/widgets/network_image.dart';
import '../../domain/model/product_model.dart';

class ProductWidget extends StatelessWidget {
  const ProductWidget({super.key, required this.item, this.addToCart});
  final ProductModel item;
  final void Function()? addToCart;
  @override
  Widget build(BuildContext context) {
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
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: NetworkImagesWidgets(
              item.image ?? "",
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
              CustomText(item.name ?? ""),
              CustomText(item.description ?? ""),
              CustomText(item.price.toString()),
            ],
          ),
          const Spacer(),
          item.available == true
              ? IconButton(
                  onPressed: () {
                    addToCart?.call();
                  },
                  icon: const Icon(Icons.add),
                )
              : CustomText("item not available"),
        ],
      ),
    );
  }
}
