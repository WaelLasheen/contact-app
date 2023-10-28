import 'contactHelper.dart';

class Contact{
  int? id;
  late String name;
  late String number;
  late String imgUrl;

  Contact({this.id,required this.name, required this.number, required this.imgUrl});
  Contact.fromMap(Map<String,dynamic> map){
    if(map[columnId] != null) id = map[columnId];
    name = map[columnName];
    number = map[columnNumber];
    imgUrl = map[columnImageUrl];
  }

  Map<String , dynamic> toMap(){
    Map<String , dynamic> map = {};
    if (id != null) map[columnId] = id;
    map[columnName] = name;
    map[columnNumber] = number;
    map[columnImageUrl] = imgUrl;
    return map;
  }

}