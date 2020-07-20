import 'package:calc_imc/models/imc_weight.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      home: Home(),
    ));

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _info = 'Informar seus dados';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora IMC'),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _reset,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Icon(Icons.person_outline, size: 120, color: Colors.green),
              TextFormField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Peso(kg)',
                  labelStyle: TextStyle(color: Colors.green),
                ),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.green, fontSize: 24),
                validator: (value) {
                  if (value.isEmpty) return 'Insira seu peso';
                },
              ),
              TextFormField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Altura(cm)',
                  labelStyle: TextStyle(color: Colors.green),
                ),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.green, fontSize: 24),
                validator: (value) {
                  if (value.isEmpty) return 'Insira sua altura';
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Container(
                  height: 48,
                  child: RaisedButton(
                    child: Text(
                      'Calcular',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    color: Colors.green,
                    onPressed: () {
                      if (_formKey.currentState.validate()) _calculate();
                    },
                  ),
                ),
              ),
              Text(
                _info,
                style: TextStyle(color: Colors.green, fontSize: 24),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _reset() {
    _formKey = GlobalKey<FormState>();
    _weightController.text = '';
    _heightController.text = '';

    setState(() => _info = 'Informar seus dados');
  }

  void _calculate() {
    final double weightValue = double.parse(_weightController.text);
    final double heightValue = double.parse(_heightController.text) / 100;
    final double imc = weightValue / (heightValue * heightValue);

    setState(() {
      final lowWeight = LowWeight(IdealWeight(AboveWeight(
          ObesidadeOneWeight(ObesidadeTwoWeight(ObesidadeThreeWeight(null))))));

      _info = lowWeight.executeMessageIMC(imc);
    });
  }
}
