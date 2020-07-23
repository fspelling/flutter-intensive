import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class GiphyPage extends StatelessWidget {
  final Map _data;

  GiphyPage(this._data);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _data['title'],
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share, color: Colors.white),
            onPressed: () =>
                Share.share(_data['images']['fixed_height']['url']),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: FadeInImage.memoryNetwork(
          placeholder: kTransparentImage,
          image: _data['images']['fixed_height']['url'],
        ),
      ),
    );
  }
}
