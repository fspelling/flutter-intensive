import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String KEY = '47e8599a';
const String REQUEST = 'https://api.hgbrasil.com/finance?key=$KEY';

void main() async {
  runApp(MaterialApp(
    theme: ThemeData(
      primaryColor: Colors.white,
      hintColor: Colors.amber,
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
      ),
    ),
    home: Home(),
  ));
}

Future<Map> getData() async {
  final http.Response response = await http.get(REQUEST);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _realController = TextEditingController();
  final TextEditingController _dolarController = TextEditingController();
  final TextEditingController _euroController = TextEditingController();

  double _dolar, _euro;

  void changeReal(String value) {
    if (value.isEmpty) clearAll();

    double real = double.parse(value);
    _dolarController.text = (real / _dolar).toStringAsFixed(2);
    _euroController.text = (real / _euro).toStringAsFixed(2);
  }

  void changeDolar(String value) {
    if (value.isEmpty) clearAll();

    double dolar = double.parse(value);
    print((dolar * _dolar).toStringAsFixed(2));
    _realController.text = (dolar * _dolar).toStringAsFixed(2);
    _euroController.text = (dolar * _dolar / _euro).toStringAsFixed(2);
  }

  void changeEuro(String value) {
    if (value.isEmpty) clearAll();

    double euro = double.parse(value);
    _realController.text = (euro * _euro).toStringAsFixed(2);
    _dolarController.text = (euro * _euro / _dolar).toStringAsFixed(2);
  }

  void clearAll() {
    _realController.text = '';
    _dolarController.text = '';
    _euroController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('\$ Conversor \$'),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  'Carregando...',
                  style: TextStyle(color: Colors.amber, fontSize: 24),
                ),
              );

            case ConnectionState.done:
              _dolar = snapshot.data['results']['currencies']['USD']['buy'];
              _euro = snapshot.data['results']['currencies']['EUR']['buy'];

              return SingleChildScrollView(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Icon(Icons.monetization_on, size: 142, color: Colors.amber),
                    buidTextField('Real', 'R\$', _realController, changeReal),
                    Divider(),
                    buidTextField('Dolar', '\$', _dolarController, changeDolar),
                    Divider(),
                    buidTextField('Euro', '€', _euroController, changeEuro),
                  ],
                ),
              );

            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Erro ao buscar dados...',
                    style: TextStyle(color: Colors.amber, fontSize: 24),
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

Widget buidTextField(String label, String prefix,
    TextEditingController controller, Function change) {
  return TextField(
    controller: controller,
    onChanged: change,
    decoration: InputDecoration(
      labelText: label,
      prefixText: prefix,
      border: OutlineInputBorder(),
      labelStyle: TextStyle(
        color: Colors.amber,
      ),
    ),
    style: TextStyle(fontSize: 24, color: Colors.amber),
    keyboardType: TextInputType.number,
  );
}
