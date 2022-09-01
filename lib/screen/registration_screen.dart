import 'package:flash_chat_app/screen/chat_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  static  const String id = 'registration_screen';

  const RegistrationScreen({Key? key}) : super(key: key);
  @override
  RegistrationScreenState createState() => RegistrationScreenState();
}

class RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  bool _isObscure = true;
  bool showSpinner = false;
  late String email;
  late String password;
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _password = new TextEditingController();


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
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      controller: _email,
                      onChanged: (value) {
                        email = value;
                      },
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
                          borderSide: BorderSide(color: Colors.blueAccent,
                              width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent,
                              width: 2.0),
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
                      obscureText: _isObscure,
                      controller: _password,
                      onChanged: (value) {
                        password = value;
                      },
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Enter your Password',
                        hintStyle: const TextStyle(color: Colors.black26),
                        prefixIcon: const Icon(Icons.lock),
                        suffix: InkWell(
                          onTap: _togglePasswordview,
                          child: Padding(
                            padding: const EdgeInsets.only(top:8.0),
                            child: Icon(_isObscure ? Icons.visibility_off : Icons
                                .visibility),
                          ),
                        ),
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 8.0,horizontal: 20.0),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent,
                              width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent,
                              width: 2.0),
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
                        color: Colors.blueAccent,
                        borderRadius: const BorderRadius.all(
                            Radius.circular(30.0)),
                        elevation: 5.0,
                        child: MaterialButton(
                          onPressed: () async {
                            if(_formKey.currentState!.validate()){
                              try {
                                final newUser = await _auth
                                    .createUserWithEmailAndPassword(
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
                                if(e.code == 'email-already-in-use') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor: Colors.blueAccent,
                                      content: Text(
                                        'User Already Registered, Please Login! ',
                                        style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  );
                                }
                              }
                              clearText();
                              return;
                            }
                            else{
                              print("UnSuccessfull");
                            }
                          },
                          minWidth: 200.0,
                          height: 42.0,
                          child: const Text(
                            'Register',
                            style: TextStyle(color: Colors.white),
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

  void _togglePasswordview() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }
  void clearText() {
    _email.clear();
    _password.clear();
  }
  }
