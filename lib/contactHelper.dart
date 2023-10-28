import 'package:path/path.dart';
import 'contact.dart';
import 'package:sqflite/sqflite.dart';

final String columnId = 'id';
final String columnName = 'name';
final String columnNumber = 'number';
final String columnImageUrl = 'imgUrl';
final String contactTable = 'contact_table';

class contactHelper{
  late Database db;
  static final contactHelper instance = contactHelper._internal();
  factory contactHelper()=> instance;

  contactHelper._internal();

  Future open() async{
    String path = await getDatabasesPath();
    String databaseName = 'contacts.db';
    db = await openDatabase(
      join(path , databaseName),
      version: 1,
      onCreate: (Database db,int version) async {
        await db.execute('''
            create table $contactTable (
              $columnId integer primary key autoincrement,
              $columnName text not null,
              $columnNumber text not null,
              $columnImageUrl text not null
            )
      ''');
      },
    );
  }

  Future<Contact> insertContact(Contact contact) async {
    contact.id = await db.insert(contactTable, contact.toMap());
    return contact;
  }

  Future<int> updateContact(Contact contact) async {
    return await db.update(contactTable, contact.toMap(),
        where: '$columnId = ?', whereArgs: [contact.id]);
  }

  Future<int> deleteContact(int id) => db.delete(contactTable ,where: '$columnId = ?' ,whereArgs: [id]);

  Future<List<Contact>> getContacts() async {
    List<Map<String ,dynamic>> contactMaps = await db.query(contactTable);
    if(contactMaps.isEmpty) return [];
    List<Contact> contacts =[];
    for(var element in contactMaps){
      contacts.add(Contact.fromMap(element));
    }
    return contacts;
  }

  Future close() => db.close();


}