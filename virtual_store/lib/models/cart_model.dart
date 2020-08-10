import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:virtual_store/data/cart_product.dart';
import 'package:virtual_store/models/user_model.dart';

class CartModel extends Model {
  List<CartProduct> listProduct = [];
  UserModel user;
  bool isLoading = false;

  String couponCode;
  int discountPercentage = 0;

  CartModel(this.user) {
    if (this.user.isLoggedIn()) _loadCartItems();
  }

  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  void addCartProduct(CartProduct product) async {
    final docAdd = await Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('cart')
        .add(product.toMap());

    product.cid = docAdd.documentID;
    listProduct.add(product);
    notifyListeners();
  }

  void removeCartProduct(CartProduct product) async {
    await Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('cart')
        .document(product.cid)
        .delete();

    listProduct.remove(product);
    notifyListeners();
  }

  void incrementProduct(CartProduct cartProduct) {
    cartProduct.quantity++;

    Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('cart')
        .document(cartProduct.cid)
        .updateData(cartProduct.toMap());

    notifyListeners();
  }

  void decrementProduct(CartProduct cartProduct) {
    cartProduct.quantity--;

    Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('cart')
        .document(cartProduct.cid)
        .updateData(cartProduct.toMap());

    notifyListeners();
  }

  Future _loadCartItems() async {
    final query = await Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('cart')
        .getDocuments();

    listProduct = query.documents.map((doc) => CartProduct.fromDocument(doc));
    notifyListeners();
  }
}
