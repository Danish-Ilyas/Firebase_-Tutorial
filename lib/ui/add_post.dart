import 'package:backend/utils/utils.dart';
import 'package:backend/widget/roundbutton.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    postController.dispose();
  }
  final postController = TextEditingController();
  bool loading = false;
  final databaseRef = FirebaseDatabase.instance.ref('post');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add post'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 30,),
            TextFormField(
              maxLines: 4,
              controller: postController,
              decoration: InputDecoration(
                hintText: "What's in your mind",
                border: OutlineInputBorder()
              ),
            ),
            SizedBox(height: 30,),
            RoundButton(
                loading: loading,
                title: 'Add',
                onTap: (){
                  final Id = DateTime.now().millisecondsSinceEpoch.toString();
                  setState(() {
                    loading = true;
                  });
                  databaseRef.child(Id).set({
                    'id': Id,
                    'title': postController.text.toString(),
                  }).then((value){
                    setState(() {
                      loading = false;
                    });
                    Utils().toastMessage('post added successfully');
                  }).onError((error, stackTrace){
                    setState(() {
                      loading = false;
                    });
                    Utils().toastMessage(error.toString());
                  });
                }
            )
          ],
        ),
      ),
    );
  }
}
