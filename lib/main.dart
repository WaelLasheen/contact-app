import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'contact.dart';
import 'contactHelper.dart';
import 'contantDetail.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await contactHelper.instance.open();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: home(),
    );
  }
}

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _home();
}

class _home extends State<home> {
  List<Contact> contacts = [];
  List<String> images = ['images/p1.png','images/p2.jpg','images/p3.jpg' ,'images/p4.jpg'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('My Contacts',style: TextStyle(fontSize: 32 ,fontWeight: FontWeight.bold ,color: Colors.blue)),
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10,15,10,15),
        child: FutureBuilder<List<Contact>>(
          future: contactHelper.instance.getContacts(),
          builder: (context, snapshot) {
            if(snapshot.hasError){
              return Center(child: Text(snapshot.error.toString()),);
            }
            if(snapshot.hasData){
              contacts = snapshot.data!;
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), 
                itemCount: contacts.length,
                itemBuilder: (context , index){
                  Contact contact = contacts[index];
                  return InkWell(
                    onTap: () async{
                      final updated = await Navigator.of(context).push(MaterialPageRoute(builder: (Context)=> contantDetails(contact: contact,)));
                      if(updated != null){
                        setState(() {
                          contacts = updated;
                        });
                      }
                      Navigator.of(context).push(MaterialPageRoute(builder: (Context)=> contantDetails(contact: contact,)));
                    },
                    child: SizedBox(
                      child: Column(
                        children: [
                          const SizedBox(height: 15,),
                          Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60),
                              image: DecorationImage(image: AssetImage(images.contains(contact.imgUrl)? contact.imgUrl : 'images/p0.png'), fit: BoxFit.cover)
                            ),
                          ),
                          Text(contact.name,style: const TextStyle(fontSize: 24 ,fontWeight: FontWeight.w500),), 
                          Text(contact.number ,style: TextStyle(color: Colors.grey[800] ,fontSize: 18),), 
                        ],
                      ),
                    ),
                  );
                }
              );
            }
            return const Center(child: CircularProgressIndicator(),);
          }
        ),
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async{
          await showModalBottomSheet(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(15.0),
              ),
            ),
            isScrollControlled: true,
            context: context,
            builder: (context){
              TextEditingController nameController = TextEditingController();
              TextEditingController numberController = TextEditingController();
              TextEditingController imgUrlController = TextEditingController();
              return SizedBox(
                height: 300 + MediaQuery.of(context).viewInsets.bottom,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10,5,10,5),
                      child: TextField(
                        controller: nameController,
                        decoration: const InputDecoration(hintText: 'Contact Name'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10,5,10,5),
                      child: TextField(
                        controller: numberController,
                        decoration: const InputDecoration(hintText: 'Contact Number'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10,5,10,5),
                      child: TextField(
                        controller: imgUrlController,
                        decoration: const InputDecoration(hintText: 'Image URL'),
                      ),
                    ),
                    Container(
                      width: double.maxFinite,
                      margin: const EdgeInsets.only(top: 30),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ElevatedButton(
                        onPressed: (){
                          contactHelper.instance.insertContact(
                            Contact(name: nameController.text, number: numberController.text, imgUrl: imgUrlController.text)
                          );
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text('Contact Added Successfully')
                            )
                          );
                          Navigator.of(context).pop();
                          setState(() {});
                        }, 
                        child: const Padding(
                          padding: EdgeInsets.all(4),
                          child: Text('ADD',style: TextStyle(fontSize: 22 ,letterSpacing: 2),),
                        )
                      ),
                    ),
                  ]
                ),
              );
            }
          );
        },
      
      ),
    );
  }
}