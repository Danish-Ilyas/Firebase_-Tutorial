import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:backend/utils/utils.dart';
import 'package:backend/widget/roundbutton.dart';

class AddFireStoreData extends StatefulWidget {
  const AddFireStoreData({super.key});

  @override
  State<AddFireStoreData> createState() => _AddFireStoreDataState();
}

class _AddFireStoreDataState extends State<AddFireStoreData> {

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    postController.dispose();
  }
  final postController = TextEditingController();
  bool loading = false;
  final fireStore = FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add FireStore Data'),
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
                  setState(() {
                    loading = true;
                  });
                  final id = DateTime.now().millisecondsSinceEpoch.toString();
                  fireStore.doc(id).set({
                    'title' : postController.text.toString(),
                    'id' : id,
                  }).then((value){
                    Utils().toastMessage('post added');
                    setState(() {
                      loading = false;
                    });
                  }).onError((error, stackTrace){
                    Utils().toastMessage(error.toString());
                    setState(() {
                      loading = false;
                    });
                  });
                }
            )
          ],
        ),
      ),
    );
  }
}

