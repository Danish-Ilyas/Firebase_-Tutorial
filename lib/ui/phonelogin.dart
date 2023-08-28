import 'package:backend/ui/code_screen.dart';
import 'package:backend/utils/utils.dart';
import 'package:backend/widget/roundbutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class LogInWithPhoneNumber extends StatefulWidget {
  const LogInWithPhoneNumber({super.key});

  @override
  State<LogInWithPhoneNumber> createState() => _LogInWithPhoneNumberState();
}

class _LogInWithPhoneNumberState extends State<LogInWithPhoneNumber> {
  bool loading = false;
  final phoneController = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 50,),
            TextFormField(
              controller: phoneController,
              decoration: InputDecoration(
                hintText: '+1 234 3456 567',
              ),
            ),
            SizedBox(height: 80,),
            RoundButton(
                loading: loading,
                title: 'Login',
                onTap: (){
                  auth.verifyPhoneNumber(
                    phoneNumber: phoneController.text,
                      verificationCompleted: (_){

                      },
                      verificationFailed: (e){
                      Utils().toastMessage(e.toString());
                      },
                      codeSent: (String verificationId, int? token){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => VerifyCodeScreen(verificationId: verificationId,)
                          ));
                      },
                      codeAutoRetrievalTimeout: (e){
                      Utils().toastMessage(e.toString());
                      });
            }),
          ],
        ),
      ),
    );
  }
}
