

import 'dart:async';

import 'package:backend/ui/firestore/firestore_list_screen.dart';
import 'package:backend/ui/posts/postscreen.dart';
import 'package:backend/ui/signin.dart';
import 'package:backend/ui/uploadimage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashServices {

  void islogin (BuildContext context){
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if(user != null){
      Timer(Duration(seconds: 03),
            () => Navigator.push(context, MaterialPageRoute(builder: (context) => UploadImageScreen())),
      );
    }else{
      Timer(Duration(seconds: 03),
            () => Navigator.push(context, MaterialPageRoute(builder: (context) => SignInScreen())),
      );
    }



  }


}