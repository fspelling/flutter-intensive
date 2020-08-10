import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData {
  String id;
  String title;
  String description;
  double price;
  List sizes;
  List images;
  String category;

  ProductData.fromDocument(DocumentSnapshot doc) {
    id = doc.documentID;
    title = doc.data['title'];
    description = doc.data['description'];
    price = doc.data['price'] + 0.0;
    sizes = doc.data['sizes'];
    images = doc.data['images'];
  }

  Map<String, dynamic> resumeMap() {
    return {
      'title': title,
      'description': description,
      'price': price,
    };
  }
}
