import 'package:schedule_contacts/database/app_database.dart';
import 'package:schedule_contacts/models/contact.dart';
import 'package:sqflite/sqflite.dart';

class ContactDao {
  static const SQL =
      'CREATE TABLE $table_name($id_column INTEGER PRIMARY KEY, $name_column TEXT, $email_column TEXT, $phone_column TEXT, $image_column TEXT)';

  static const table_name = 'Contact';

  static const id_column = 'id';
  static const name_column = 'name';
  static const email_column = 'email';
  static const phone_column = 'phone';
  static const image_column = 'image';

  final _db = AppDatabase();

  Future<Contact> save(Contact contact) async {
    final dbContacts = await _db.db;
    final idSave = await dbContacts.insert(table_name, contact.toMap());
    contact.id = idSave;

    return contact;
  }

  Future<Contact> getById(int id) async {
    Contact contact;

    final dbContacts = await _db.db;
    final contactMap = (await dbContacts.query(table_name,
            columns: [
              id_column,
              name_column,
              email_column,
              phone_column,
              image_column
            ],
            where: '$id_column = ?',
            whereArgs: [id]))
        .first;

    if (contactMap != null) contact = Contact.fromMap(contactMap);
    return contact;
  }

  Future<int> update(Contact contact) async {
    final dbContacts = await _db.db;

    final idUpdate = await dbContacts.update(table_name, contact.toMap(),
        where: '$id_column = ?', whereArgs: [contact.id]);

    return idUpdate;
  }

  Future<int> delete(int id) async {
    final dbContacts = await _db.db;

    final idDelete = await dbContacts
        .delete(table_name, where: '$id_column = ?', whereArgs: [id]);

    return idDelete;
  }

  Future<List<Contact>> getAll() async {
    List<Contact> contacts = List<Contact>();

    final dbContacts = await _db.db;
    final contactsMap = await dbContacts.rawQuery('SELECT * FROM $table_name');

    for (Map map in contactsMap) {
      final contact = Contact.fromMap(map);
      contacts.add(contact);
    }

    return contacts;
  }

  Future<int> getNumber() async {
    final dbContacts = await _db.db;
    final query = await dbContacts.rawQuery('SELECT COUNT(1) FROM $table_name');
    return Sqflite.firstIntValue(query);
  }

  Future close() async {
    final dbContacts = await _db.db;
    dbContacts.close();
  }
}
