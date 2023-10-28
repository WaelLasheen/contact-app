import 'package:contacts/contact.dart';
import 'package:contacts/contactHelper.dart';
import 'package:contacts/main.dart';
import 'package:flutter/material.dart';


class contantDetails extends StatefulWidget {
  final Contact contact;
  contantDetails({super.key, required this.contact});

  @override
  State<contantDetails> createState() => _contantDetailsState();
}

class _contantDetailsState extends State<contantDetails> {
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController imgUrlController = TextEditingController();
  late Contact editedContact;

  List<String> images = ['images/p1.png','images/p2.jpg','images/p3.jpg' ,'images/p4.jpg'];

  @override
  void initState() {
    super.initState();
    editedContact = Contact.fromMap(widget.contact.toMap());

    nameController.text  = editedContact.name;
    numberController.text = editedContact.number;
    imgUrlController.text = editedContact.imgUrl;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('My Contacts',style: TextStyle(fontSize: 32 ,fontWeight: FontWeight.bold ,color: Colors.blue)),
          elevation: 0,
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            SizedBox(height: 200, child: Image.asset(images.contains(editedContact.imgUrl)? editedContact.imgUrl : 'images/p0.png')),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: nameController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: numberController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: imgUrlController,
              ),
            ),
            const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  onPressed: ()=> showDialog(
                    context: context, 
                    builder: ( BuildContext context)=>AlertDialog(
                      title: const Text("Save Updates"),
                      content: const Text("Are you sure you want to Save updates"),
                      actions: [
                        Row(
                          children: [
                            const Expanded(child: SizedBox()),
                            TextButton(onPressed: ()=> Navigator.of(context).pop(), child: Text('Clean' ,style:TextStyle(color: Colors.grey[600] ,fontSize: 18))),
                            TextButton(onPressed: () {
                                setState(() {
                                  contactHelper.instance.updateContact(editedContact);
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(BuildContext context) => const home()));
                                  print(editedContact.id);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    content: Text('Contact Updated Successfully')
                                  )
                                );
                                
                              }, 
                              child: Text('YES' ,style:TextStyle(color: Colors.blue[400] ,fontSize: 18))),
                          ],
                        )
                      ],
                    )
                  )

                  ,child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Text('SAVE',style: TextStyle(fontSize: 22 ,letterSpacing: 2),),
                  )
                ),
              ),
            ),

            const SizedBox(height: 10,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  onPressed:() {
                    showDialog(
                    context: context, 
                    builder: ( BuildContext context)=>AlertDialog(
                      title: const Text("Delete Contact"),
                      content: const Text("Are you sure you want to delete this contact"),
                      actions: [
                        Row(
                          children: [
                            const Expanded(child: SizedBox()),
                            TextButton(onPressed: ()=> Navigator.of(context).pop(), child: Text('Clean' ,style:TextStyle(color: Colors.grey[600] ,fontSize: 18))),
                            TextButton(onPressed: () {
                              setState(() {
                                contactHelper.instance.deleteContact(editedContact.id!);
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(BuildContext context) => const home()));
                              });
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Text('Contact Deleted Successfully')
                                )
                              );
                            }, 
                              child: Text('YES' ,style:TextStyle(color: Colors.red[900] ,fontSize: 18) ,)
                            ),
                          ],
                        )
                      ],
                    )
                  );
                  },

                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Text('DELETE',style: TextStyle(fontSize: 22 ,letterSpacing: 2),),
                  )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}





