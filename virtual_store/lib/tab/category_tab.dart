import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:virtual_store/widgets/tiles/category_tile.dart';

class CategoryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance.collection('products').getDocuments(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        else {
          final listCategory = ListTile.divideTiles(
            tiles: snapshot.data.documents.map(
              (doc) {
                return CategoryTile(doc);
              },
            ),
            color: Colors.grey[500],
          ).toList();

          return ListView(children: listCategory);
        }
      },
    );
  }
}
