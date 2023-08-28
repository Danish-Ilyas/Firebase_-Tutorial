import 'package:backend/ui/add_post.dart';
import 'package:backend/ui/signin.dart';
import 'package:backend/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {

  final searchController = TextEditingController();
  final editController = TextEditingController();
  final auth = FirebaseAuth.instance;
  final ref =FirebaseDatabase.instance.ref('post');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddPost()));
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Posts'),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 30,),
            TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                  hintText: "Search",
                  border: OutlineInputBorder()
              ),
              onChanged: (String value){
                setState(() {

                });
              },
            ),
            SizedBox(height: 30,),
            Expanded(
              child: FirebaseAnimatedList(
                defaultChild: Text('Loading'),
                  query: ref,
                  itemBuilder: (context, snapshot, animation, index){
                    final title = snapshot.child('title').value.toString();
                    if(searchController.text.isEmpty){
                      return ListTile(
                        title: Text(snapshot.child('title').value.toString()),
                        subtitle: Text(snapshot.child('id').value.toString()),
                        trailing: PopupMenuButton(
                          icon: Icon(Icons.more_horiz_outlined),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                                value: 1,
                                child: ListTile(
                                  onTap: (){
                                    Navigator.pop(context);
                                    showMyDialog(title, snapshot.child('id').value.toString());
                                  },
                                  leading: Icon(Icons.edit),
                                  title: Text('Edit'),
                                )
                            ),
                            PopupMenuItem(
                                value: 1,
                                child: ListTile(
                                  onTap: (){
                                    Navigator.pop(context);
                                    ref.child(snapshot.child('id').value.toString()).remove();
                                  },
                                  leading: Icon(Icons.delete),
                                  title: Text('Delete'),
                                )
                            ),
                          ],
                        ),
                      );
                    }else if (title.toLowerCase().contains(searchController.text.toLowerCase())){
                      return ListTile(
                        title: Text(snapshot.child('title').value.toString()),
                        subtitle: Text(snapshot.child('id').value.toString()),
                      );
                    }else{
                      return Container();
                    }
                  }
              ),
            )
          ],
        ),
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
                ref.child(id).update({
                  'title':  editController.text.toLowerCase()
                }).then((value){
                  Utils().toastMessage('Post updated');
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
