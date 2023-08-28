import 'package:backend/ui/signin.dart';
import 'package:backend/ui/signup.dart';
import 'package:backend/utils/utils.dart';
import 'package:backend/widget/roundbutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool loading = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final key = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SignUp Screen'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
              key: key,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        prefixIcon: Icon(Icons.email),
                        helperText: 'abcd@gmail.com',
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Enter email';
                        }
                        return null ;
                      },
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      obscuringCharacter: '*',
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Enter password';
                        }
                        return null ;
                      },
                    ),
                    SizedBox(height: 30,),
                    RoundButton(
                      loading: loading,
                      title: 'SignUp',
                      onTap: (){
                        if(key.currentState!.validate()){
                          setState(() {
                            loading = true ;
                          });
                          auth.createUserWithEmailAndPassword(
                              email: emailController.text.toString(),
                              password: passwordController.text.toString()).then((value){
                                setState(() {
                                  loading = false ;
                                });

                          }).onError((error, stackTrace){
                            Utils().toastMessage(error.toString());
                            setState(() {
                              loading = false ;
                            });
                          });
                        }
                      },),
                  ],
                ),
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("already have an account"),
              TextButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => SignInScreen()));
              },
                  child: Text("Sign In"))
            ],
          )
        ],
      ),
    );
  }
}
