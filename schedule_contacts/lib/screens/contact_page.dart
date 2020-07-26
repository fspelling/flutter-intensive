import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:schedule_contacts/models/contact.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage({this.contact});

  @override
  State<StatefulWidget> createState() => ContactPageState();
}

class ContactPageState extends State<ContactPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _nameFocus = FocusNode();

  Contact _editingContact;
  bool _isEditing;

  @override
  void initState() {
    super.initState();

    _editingContact = widget.contact ?? Contact.init();
    _isEditing = false;

    _nameController.text = _editingContact.name;
    _emailController.text = _editingContact.email;
    _phoneController.text = _editingContact.phone;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _editingContact.name ?? 'Novo Contato',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  height: 140,
                  width: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: _editingContact.image != null
                          ? FileImage(File(_editingContact.image))
                          : AssetImage('images/person.png'),
                    ),
                  ),
                ),
                onTap: () async {
                  final fileImage =
                      await ImagePicker().getImage(source: ImageSource.camera);

                  if (fileImage != null)
                    setState(() => _editingContact.image = fileImage.path);
                },
              ),
              TextField(
                controller: _nameController,
                focusNode: _nameFocus,
                decoration: InputDecoration(labelText: 'Name'),
                onChanged: (text) {
                  _isEditing = true;
                  setState(
                    () => _editingContact.name = text.isEmpty ? null : text,
                  );
                },
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                onChanged: (text) {
                  _isEditing = true;
                  _editingContact.email = text.isEmpty ? null : text;
                },
              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
                onChanged: (text) {
                  _isEditing = true;
                  _editingContact.phone = text.isEmpty ? null : text;
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.save, color: Colors.white),
          backgroundColor: Colors.red,
          onPressed: () {
            if (_editingContact.name != null && _editingContact.name.isNotEmpty)
              Navigator.of(context).pop(_editingContact);
            else
              _nameFocus.requestFocus();
          },
        ),
      ),
      onWillPop: () => _requestPop(context),
    );
  }

  Future<bool> _requestPop(BuildContext context) {
    if (_isEditing) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Alteracoes Efetuadas'),
            content: Text('Apos concluir as alteracoes serao desfeitas'),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancelar'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                child: Text('Sim'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

      return Future.value(false);
    } else
      return Future.value(true);
  }
}
