import '../features/product/domain/model/product_model.dart';

class ProductDataSource {
  static final List<ProductModel> products = [
    ProductModel(
        id: 1,
        name: 'Product 1',
        price: '100',
        description: 'Product 1 description',
        image:
            "https://cdn.prod.website-files.com/619e8d2e8bd4838a9340a810/64c590c754d6bc13ebd90cbc_ai_product_photo_styles.webp",
        available: false),
    ProductModel(
        id: 2,
        name: 'Product 2',
        price: '200',
        description: 'Product 2 description',
        image:
            "https://cdn.prod.website-files.com/619e8d2e8bd4838a9340a810/64c590c754d6bc13ebd90cbc_ai_product_photo_styles.webp",
        available: false),
    ProductModel(
        id: 3,
        name: 'Product 3',
        price: '300',
        description: 'Product 3 description',
        image:
            "https://cdn.prod.website-files.com/619e8d2e8bd4838a9340a810/64c590c754d6bc13ebd90cbc_ai_product_photo_styles.webp",
        available: true),
    ProductModel(
        id: 4,
        name: 'Product 4',
        price: '400',
        description: 'Product 4 description',
        image:
            "https://cdn.prod.website-files.com/619e8d2e8bd4838a9340a810/64c590c754d6bc13ebd90cbc_ai_product_photo_styles.webp",
        available: true),
    ProductModel(
        id: 5,
        name: 'Product 5',
        price: "500",
        description: 'Product 5 description',
        image:
            "https://cdn.prod.website-files.com/619e8d2e8bd4838a9340a810/64c590c754d6bc13ebd90cbc_ai_product_photo_styles.webp",
        available: true),
  ];
}
