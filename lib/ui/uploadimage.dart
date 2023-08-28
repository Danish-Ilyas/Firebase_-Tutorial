
import 'dart:io';
import 'package:backend/utils/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../widget/roundbutton.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  File? _image ;
  final picker = ImagePicker();
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance ;
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref('Post');
  bool loading = false;
  Future getImageGallery()async{
    final pickedFile = await picker.pickImage(source: ImageSource.gallery,imageQuality: 80);
    setState(() {
      if(pickedFile != null){
        _image = File(pickedFile.path);
      }else{
        debugPrint('no image picked');
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Upload image'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: (){
                    getImageGallery();
              },
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                  ),

                ),
                child: Center(child: _image != null ? Image.file(_image!.absolute): Icon(Icons.image)),
              ),
            ),
            SizedBox(height: 30,),
            RoundButton(
              loading: loading,
              title: 'Upload', onTap: () async{
              setState(() {
                loading = true;
              });
              firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref('/folder/'+'123');
              firebase_storage.UploadTask uploadTask = ref.putFile(_image!.absolute);

              await Future.value(uploadTask);
              var newUrl = await ref.getDownloadURL();
              databaseRef.child('1').set({
                'id' : '1212',
                'title': newUrl.toString(),
              }).then((value) {
                setState(() {
                  loading = false;
                });
                Utils().toastMessage('Image Uploaded');
              }).onError((error, stackTrace) {
                setState(() {
                  loading = false;
                });
                Utils().toastMessage(error.toString());
              });
            },),
          ],
        ),
      ),
    );
  }
}
