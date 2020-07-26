import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_contacts/database/dao/contact_dao.dart';
import 'package:schedule_contacts/models/contact.dart';
import 'package:schedule_contacts/screens/contact_page.dart';
import 'package:url_launcher/url_launcher.dart';

enum OrderOption { orderaz, orderza }

class HomePage extends StatefulWidget {
  final ContactDao dao = ContactDao();

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Contact> _contacts = List();

  @override
  void initState() {
    super.initState();
    _getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contatos'),
        centerTitle: true,
        backgroundColor: Colors.red,
        actions: <Widget>[
          PopupMenuButton<OrderOption>(
            itemBuilder: (context) {
              return <PopupMenuEntry<OrderOption>>[
                PopupMenuItem(
                  child: Text('Ordenar de A-Z'),
                  value: OrderOption.orderaz,
                ),
                PopupMenuItem(
                  child: Text('Ordenar de Z-A'),
                  value: OrderOption.orderza,
                ),
              ];
            },
            onSelected: _orderContacts,
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _contacts.length,
        itemBuilder: _buildItem,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.red,
        onPressed: () => _showContactPage(context),
      ),
    );
  }

  Widget _buildItem(context, index) {
    return GestureDetector(
      child: Card(
        child: Row(
          children: <Widget>[
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: _contacts[index].image != null
                      ? FileImage(File(_contacts[index].image))
                      : AssetImage('images/person.png'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                children: <Widget>[
                  Text(
                    _contacts[index].name != '' ? _contacts[index].name : '',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _contacts[index].email != '' ? _contacts[index].email : '',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    _contacts[index].phone != '' ? _contacts[index].phone : '',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () => _showOptions(context, index),
    );
  }

  void _getAllContacts() {
    widget.dao.getAll().then((list) {
      setState(() => _contacts = list);
    });
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: FlatButton(
                      child: Text(
                        'Ligar',
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        launch('tel:${_contacts[index].phone}');
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: FlatButton(
                      child: Text(
                        'Editar',
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        _showContactPage(context, contact: _contacts[index]);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: FlatButton(
                      child: Text(
                        'Deletar',
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await widget.dao.delete(_contacts[index].id);
                        _getAllContacts();
                      },
                    ),
                  ),
                ],
              ),
            );
          },
          onClosing: () {},
        );
      },
    );
  }

  void _showContactPage(BuildContext context, {Contact contact}) async {
    final contactEditing = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ContactPage(contact: contact),
    ));

    if (contactEditing != null) {
      if (contact == null)
        await widget.dao.save(contactEditing);
      else
        await widget.dao.update(contactEditing);

      _getAllContacts();
    }
  }

  void _orderContacts(OrderOption option) {
    switch (option) {
      case OrderOption.orderaz:
        setState(
          () => _contacts.sort(
            (a, b) => a.name.toLowerCase().compareTo(
                  b.name.toLowerCase(),
                ),
          ),
        );
        break;

      case OrderOption.orderza:
        setState(
          () => _contacts.sort(
            (a, b) => b.name.toLowerCase().compareTo(
                  a.name.toLowerCase(),
                ),
          ),
        );
        break;
    }
  }
}
