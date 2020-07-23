import 'package:flutter/material.dart';
import 'package:giphy_search/http/webclients/giphy_webclient.dart';
import 'package:giphy_search/screens/giphy_page.dart';
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  final GiphyWebClient giphyWebClient = GiphyWebClient();

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _controller = TextEditingController();
  String _search = null;
  int _offset = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.network(
          'https://developers.giphy.com/branch/master/static/header-logo-8974b8ae658f704a5b48a2d039b8ad93.gif',
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Pesquise aqui',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
              onSubmitted: (text) {
                setState(() {
                  _search = text;
                  _offset = 0;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<Map>(
              future: widget.giphyWebClient.getGiphys(_search, offset: _offset),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Container(
                      width: 200,
                      height: 200,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5,
                      ),
                    );

                  case ConnectionState.done:
                    return _createGifTable(context, snapshot);

                  default:
                    if (snapshot.hasError)
                      return Container(
                        child: Text('Erros ao buscar os gifs'),
                      );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  _createGifTable(BuildContext context, AsyncSnapshot snapshoot) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _search == null
          ? snapshoot.data['data'].length
          : snapshoot.data['data'].length + 1,
      itemBuilder: (context, index) {
        if (_search == null || index < snapshoot.data['data'].length)
          return GestureDetector(
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: snapshoot.data['data'][index]['images']['fixed_height']
                  ['url'],
              fit: BoxFit.cover,
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => GiphyPage(
                          snapshoot.data['data'][index],
                        )),
              );
            },
            onLongPress: () => Share.share(
                snapshoot.data['data'][index]['images']['fixed_height']['url']),
          );
        else {
          return Container(
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.add, color: Colors.white, size: 72),
                  Text(
                    'Buscar mais...',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  )
                ],
              ),
              onTap: () {
                setState(() => _offset += 19);
              },
            ),
          );
        }
      },
    );
  }
}
