import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:virtual_store/screens/products_screen.dart';

class CategoryTile extends StatelessWidget {
  final DocumentSnapshot data;

  CategoryTile(this.data);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(top: 8, bottom: 8),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductsScreen(data),
          ),
        );
      },
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 25,
        backgroundImage: NetworkImage(data['icon']),
      ),
      title: Text(data['title']),
      trailing: Icon(Icons.arrow_right),
    );
  }
}
