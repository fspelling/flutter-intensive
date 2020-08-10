import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:virtual_store/data/cart_product.dart';
import 'package:virtual_store/data/product_data.dart';
import 'package:virtual_store/models/cart_model.dart';
import 'package:virtual_store/models/user_model.dart';
import 'package:virtual_store/screens/cart_screen.dart';
import 'package:virtual_store/screens/login_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductData productData;

  ProductDetailScreen(this.productData);

  @override
  State<StatefulWidget> createState() => _ProductDetailScreenState(productData);
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ProductData productData;
  String size;

  _ProductDetailScreenState(this.productData);

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(productData.title),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 0.9,
            child: Carousel(
              images: productData.images.map((url) {
                return Image.network(url, fit: BoxFit.cover);
              }).toList(),
              dotSize: 4,
              dotSpacing: 16,
              dotColor: primaryColor,
              dotBgColor: Colors.transparent,
              autoplay: true,
              autoplayDuration: Duration(seconds: 4),
              animationDuration: Duration(seconds: 2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  productData.title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  maxLines: 3,
                ),
                Text(
                  'R\$ ${productData.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 16),
                Text(
                  'Tamanho',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  maxLines: 3,
                ),
                SizedBox(
                  height: 34,
                  child: GridView(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: 0.5,
                    ),
                    scrollDirection: Axis.horizontal,
                    children: productData.sizes
                        .map(
                          (size) => GestureDetector(
                            onTap: () {
                              setState(() => this.size = size);
                            },
                            child: Container(
                              width: 50,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              alignment: Alignment.center,
                              child: Text(size),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(4),
                                ),
                                border: Border.all(
                                  color: this.size == size
                                      ? primaryColor
                                      : Colors.grey[500],
                                  width: 3,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  height: 40,
                  child: RaisedButton(
                    onPressed: size != null
                        ? () {
                            final userModel = UserModel.of(context);
                            if (userModel.isLoggedIn()) {
                              final cartModel = CartModel.of(context);

                              final cartProduct = CartProduct();
                              cartProduct.pid = productData.id;
                              cartProduct.category = productData.category;
                              cartProduct.size = size;
                              cartProduct.quantity = 1;
                              cartProduct.productData = productData;

                              cartModel.addCartProduct(cartProduct);

                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => CartScreen(),
                                ),
                              );
                            } else {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                            }
                          }
                        : null,
                    child: Text(
                      UserModel.of(context).isLoggedIn()
                          ? 'Adicionar ao carrinho'
                          : 'Entre para comprar',
                      style: TextStyle(fontSize: 16),
                    ),
                    color: primaryColor,
                    textColor: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Descricao',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Text(productData.description),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
