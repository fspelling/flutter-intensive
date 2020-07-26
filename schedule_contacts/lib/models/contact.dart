import 'package:schedule_contacts/database/dao/contact_dao.dart';

class Contact {
  int id;
  String name;
  String email;
  String phone;
  String image;

  Contact.init()
      : id = 0,
        name = null,
        email = null,
        phone = null,
        image = null;

  Contact(this.id, this.name, this.email, this.phone, this.image);

  Contact.fromMap(Map<String, dynamic> map)
      : id = map[ContactDao.id_column],
        name = map[ContactDao.name_column],
        email = map[ContactDao.email_column],
        phone = map[ContactDao.phone_column],
        image = map[ContactDao.image_column];

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      ContactDao.name_column: name,
      ContactDao.email_column: email,
      ContactDao.phone_column: phone,
      ContactDao.image_column: image
    };

    if (id != null && id > 0) map[ContactDao.id_column] = id;
    return map;
  }

  @override
  String toString() => '$id - $name - $email - $phone - $image';
}
