import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:virtual_store/models/cart_model.dart';
import 'package:virtual_store/models/user_model.dart';
import 'package:virtual_store/screens/login_screen.dart';
import 'package:virtual_store/widgets/discount_card.dart';
import 'package:virtual_store/widgets/tiles/cart_tile.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meu Carrinho'),
        centerTitle: true,
        actions: <Widget>[
          Container(
            padding: const EdgeInsets.only(right: 8),
            alignment: Alignment.center,
            child: ScopedModelDescendant<CartModel>(
              builder: (context, child, model) {
                return Text(
                  '${model.listProduct.length ?? 0} ${model.listProduct.length == 1 ? 'item' : 'itens'}',
                  style: TextStyle(fontSize: 19),
                );
              },
            ),
          ),
        ],
      ),
      body: ScopedModelDescendant<CartModel>(
        builder: (context, child, model) {
          if (model.isLoading && UserModel.of(context).isLoggedIn())
            return Center(child: CircularProgressIndicator());
          else if (!UserModel.of(context).isLoggedIn()) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.remove_shopping_cart,
                    size: 84,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(height: 16),
                  RaisedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ));
                    },
                    child: Text('Entrar ', style: TextStyle(fontSize: 16)),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                  ),
                ],
              ),
            );
          } else if (model.listProduct.length == 0 ||
              model.listProduct == null) {
            return Center(
              child: Text(
                'Nenhum produto no carrinho',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            );
          } else {
            return ListView(
              children: <Widget>[
                Column(
                  children: model.listProduct
                      .map(
                        (cart) => CartTile(cart),
                      )
                      .toList(),
                ),
                DiscountCard(),
              ],
            );
          }
        },
      ),
    );
  }
}
