import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:virtual_store/models/user_model.dart';

class SignupScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  Color _primaryColor;
  BuildContext _contextCurrent;
  BuildContext _contexScaffold;

  @override
  Widget build(BuildContext context) {
    _contextCurrent = context;
    _primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Criar Conta'),
          centerTitle: true,
        ),
        body: Builder(
          builder: (context) {
            _contexScaffold = context;
            return ScopedModelDescendant<UserModel>(
              builder: (context, child, model) {
                if (model.isLoading)
                  return Center(child: CircularProgressIndicator());

                return Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: <Widget>[
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(hintText: 'nome completo'),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value.isEmpty) return 'Nome invalido';
                        },
                      ),
                      SizedBox(height: 16),
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
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _addressController,
                        decoration: InputDecoration(hintText: 'endereco'),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value.isEmpty) return 'Endereco invalido';
                        },
                      ),
                      SizedBox(height: 16),
                      Container(
                        height: 40,
                        child: RaisedButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              final userData = {
                                'name': _nameController.text,
                                'email': _emailController.text,
                                'address': _addressController.text,
                              };

                              model.signup(
                                userData,
                                _passwordController.text,
                                _onsuccess,
                                _onerror,
                              );
                            }
                          },
                          textColor: Colors.white,
                          color: _primaryColor,
                          child: Text('Criar', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ));
  }

  void _onsuccess() {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text('Usuario cadastro com sucesso'),
        duration: Duration(seconds: 2),
        backgroundColor: _primaryColor,
      ),
    );

    Future.delayed(Duration(seconds: 2))
        .then((_) => Navigator.pop(_contextCurrent));
  }

  void _onerror() {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text('Erro ao cadastrar o usuario'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
      ),
    );
  }
}
