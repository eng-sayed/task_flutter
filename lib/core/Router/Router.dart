import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_flutter/features/product/presentation/screens/product_screen.dart';

import '../../features/product/presentation/screens/cart_screen.dart';

class Routes {
  static const String productsScreen = "/productsScreen";
  static const String cartScreen = "/cartScreen";
}

class RouteGenerator {
  static String currentRoute = "";

  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    currentRoute = routeSettings.name.toString();
    switch (routeSettings.name) {
      case Routes.productsScreen:
        return CupertinoPageRoute(
            settings: routeSettings,
            builder: (_) {
              return const ProductScreen();
            });
      case Routes.cartScreen:
        return CupertinoPageRoute(
            settings: routeSettings,
            builder: (_) {
              return const CartScreen();
            });

      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> getNestedRoute(RouteSettings routeSettings) {
    currentRoute = routeSettings.name.toString();
    switch (routeSettings.name) {
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return CupertinoPageRoute(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: const Text("مسار غير موجود"),
              ),
              body: const Center(child: Text("مسار غير موجود")),
            ));
  }
}

class OtpArguments {
  final String sendTo;
  final bool? init;
  final dynamic Function(String) onSubmit;
  final void Function() onReSend;

  OtpArguments({
    required this.sendTo,
    required this.onSubmit,
    required this.onReSend,
    this.init,
  });
}

class NewPasswordArgs {
  final String code;
  final String email;
  const NewPasswordArgs({required this.code, required this.email});
}
