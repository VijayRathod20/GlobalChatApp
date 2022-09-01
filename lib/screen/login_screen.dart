import 'package:flash_chat_app/screen/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  const LoginScreen({Key? key}) : super(key: key);
  @override
  LoginScreenState createState() => LoginScreenState();
}


class LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;
  bool showSpinner = false;
  bool _obscureText = true;
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _password = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 180.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Hero(
                      tag: "logo",
                      child: SizedBox(
                        height: 200.0,
                        child: Image.asset('images/chat.png'),
                      ),
                    ),
                    const SizedBox(
                      height: 48.0,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your email address';
                        }
                        // Check if the entered email has the right format
                        if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        // Return null if the entered email is valid
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      obscureText: false,
                      controller: _email,
                      onChanged: (value) {
                        email = value;
                      },
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        hintText: 'Enter your Email',
                        hintStyle: TextStyle(color: Colors.black26),
                        prefixIcon: Icon(Icons.email),
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    TextFormField(
                      validator: (value) {
                        RegExp regex =
                        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$');
                        if (value!.isEmpty) {
                          return 'Please Enter Your Password';
                        }
                        else {
                          if (!regex.hasMatch(value)) {
                            return 'Minimum 1 Upper case,Minimum 1 lowercase,\nMinimum 1 Numeric Number,Minimum 1 Special \n CharacterCommon Allow Character ( ! @ # & * ~ )';
                          } else {
                            return null;
                          }
                        }
                      },
                      textAlign: TextAlign.center,
                      obscureText: _obscureText,
                      controller: _password,
                      onChanged: (value) {
                        //Do something with the user input.
                        password = value;
                      },
                      style: const TextStyle(color: Colors.black),
                      decoration:  InputDecoration(
                        hintText: 'Enter your Password.',
                        hintStyle: const TextStyle(color: Colors.black26),
                        prefixIcon: const Icon(Icons.lock),
                        suffix: InkWell(
                          onTap: _togglePasswordview,
                          child: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                        ),
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 24.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Material(
                        color: Colors.lightBlueAccent,
                        borderRadius: const BorderRadius.all(
                            Radius.circular(30.0)),
                        elevation: 5.0,
                        child: MaterialButton(
                          onPressed: () async {
                            if(_formKey.currentState!.validate()){
                              try {
                                final user = await _auth.signInWithEmailAndPassword(
                                    email: email, password: password);
                                setState(() {
                                  showSpinner = true;
                                });
                                Navigator.pushNamed(context, ChatScreen.id);
                                setState(() {
                                  showSpinner = false;
                                });
                              }
                              on FirebaseAuthException catch (e) {
                                print(e);
                                if(e.code == 'wrong-password'){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor: Colors.lightBlueAccent,
                                      content: Text(
                                        'Wrong Password!',
                                        style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  );
                                }else if(e.code == 'user-not-found'){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor: Colors.blueAccent,
                                      content: Text(
                                        'User Not Fount, Please Register! ',
                                        style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  );
                                }
                              }
                              clearText();
                            }
                            else{
                              print("UnSuccessfull");
                            }
                          },
                          minWidth: 200.0,
                          height: 42.0,
                          child: const Text(
                            'Log In',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  void _togglePasswordview(){
    setState((){
      _obscureText = !_obscureText;
    });
  }
  void clearText() {
    _email.clear();
    _password.clear();
  }
}

