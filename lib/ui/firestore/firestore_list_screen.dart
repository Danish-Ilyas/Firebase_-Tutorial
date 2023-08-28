import 'package:backend/ui/firestore/firestoreData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import '../signin.dart';

class FireStoreScreen extends StatefulWidget {
  const FireStoreScreen({super.key});

  @override
  State<FireStoreScreen> createState() => _FireStoreScreenState();
}

class _FireStoreScreenState extends State<FireStoreScreen> {

  final editController = TextEditingController();
  final auth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance.collection('users').snapshots();
  CollectionReference ref = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddFireStoreData()));
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('FireStore'),
        actions: [
          IconButton(onPressed:(){
            auth.signOut().then((value){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> SignInScreen()));
            }).onError((error, stackTrace){
              Utils().toastMessage(error.toString());
            });
          },
              icon: Icon(Icons.logout)),
        ],
      ),
      body: Column(
        children: [
        SizedBox(height: 30,),
          StreamBuilder<QuerySnapshot>(
            stream: fireStore,
              builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){

                if(snapshot.connectionState == ConnectionState.waiting){
                  return CircularProgressIndicator();
                } else if(snapshot.hasError){
                  return Text('Some error');
                }
                else{
                  return Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index){
                            final title = Text(snapshot.data!.docs[index]['title'].toString());
                            return ListTile(
                              title: Text(snapshot.data!.docs[index]['title'].toString()),
                              subtitle: Text(snapshot.data!.docs[index]['id'].toString()),
                              trailing: PopupMenuButton(
                                icon: Icon(Icons.more_horiz_outlined),
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                      child: ListTile(
                                        onTap: (){
                                        Navigator.pop(context);
                                        showMyDialog(snapshot.data!.docs[index]['title'].toString(),
                                            snapshot.data!.docs[index]['id'].toString());
                                        },
                                            leading: Icon(Icons.edit),
                                            title: Text('Edit'),
                                      ),
                                  ),
                                  PopupMenuItem(
                                      child: ListTile(
                                        onTap: (){
                                        Navigator.pop(context);
                                        ref.doc(snapshot.data!.docs[index]['id'].toString()).delete();
                                        },
                                            leading: Icon(Icons.delete),
                                            title: Text('Delete'),
                                      ),
                                  ),
                                ],
                              ),
                            );
                          }));
                }
              }
          ),
        ],
      ),
    );
  }

  Future<void> showMyDialog(String title, String id)async{
    editController.text = title;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update'),
          content: Container(
            child: TextField(
              controller: editController,
              decoration: InputDecoration(
                  hintText: 'Edit'
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: (){
              Navigator.pop(context);
            },
                child: Text('Cancel')
            ),
            TextButton(onPressed: (){
              Navigator.pop(context);
                  ref.doc(id).update({
                    'title' : editController.text.toLowerCase(),
                  }).then((value){
                    Utils().toastMessage('updated successfully');
                  }).onError((error, stackTrace){
                    Utils().toastMessage(error.toString());
                  });
            },
                child: Text('Update')
            ),
          ],
        );
      },
    );
  }

}
