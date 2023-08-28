import 'package:backend/ui/phonelogin.dart';
import 'package:backend/ui/posts/postscreen.dart';
import 'package:backend/ui/signup.dart';
import 'package:backend/utils/utils.dart';
import 'package:backend/widget/roundbutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
   bool loading = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final key = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void islogin() {
    setState(() {
      loading = true ;
    });

    auth.signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text.toString()).then((value) {
      setState(() {
        loading = false ;
      });
      Navigator.push(context, MaterialPageRoute(builder: (context) => PostScreen()));
    })
        .onError((error, stackTrace) {
      Utils().toastMessage(error.toString());
      setState(() {
        loading = false ;
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('SignIn Screen'),
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
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        obscuringCharacter: '*',
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      RoundButton(
                        loading: loading,
                        title: 'Login',
                        onTap: () {
                          if (key.currentState!.validate()) {
                            islogin();
                          }
                        },
                      ),
                    ],
                  ),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account"),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen()));
                    },
                    child: Text("Sign Up"))
              ],
            ),

            SizedBox(height: 30,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: InkWell(
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LogInWithPhoneNumber()));
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: Colors.black
                    )
                  ),
                  child: Center(
                    child: Text('Login with phone'),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
