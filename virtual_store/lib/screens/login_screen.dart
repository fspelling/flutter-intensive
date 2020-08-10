import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:virtual_store/models/user_model.dart';
import 'package:virtual_store/screens/signup_screen.dart';

class LoginScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  BuildContext _contextCurrent;

  @override
  Widget build(BuildContext context) {
    _contextCurrent = context;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Entrar'),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => SignupScreen(),
              ));
            },
            child: Text('CREATE', style: TextStyle(fontSize: 16)),
            textColor: Colors.white,
          ),
        ],
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          if (model.isLoading)
            return Center(child: CircularProgressIndicator());

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(hintText: 'email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@'))
                      return 'Email invalido';
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(hintText: 'senha'),
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  validator: (value) {
                    if (value.isEmpty || value.length < 6)
                      return 'Senha invalida';
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      if (_emailController.text.isEmpty) {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text('Favor preencher o email'),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                        ));
                      } else {
                        model.resetEmail(_emailController.text);
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text('Confira seu email'),
                          backgroundColor: Theme.of(context).primaryColor,
                          duration: Duration(seconds: 2),
                        ));
                      }
                    },
                    child: Text('Esqueci minha senha'),
                  ),
                ),
                Container(
                  height: 40,
                  child: RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        Map<String, dynamic> loginData = {
                          'email': _emailController.text,
                          'password': _passwordController.text
                        };

                        model.signin(loginData, onsuccess, onerror);
                      }
                    },
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    child: Text('Login', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void onsuccess() => Navigator.of(_contextCurrent).pop();

  void onerror() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('Erro ao realizar login'),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 2),
    ));
  }
}
