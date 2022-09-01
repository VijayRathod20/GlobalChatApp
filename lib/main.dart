// @dart=2.9
import 'package:flash_chat_app/screen/chat_screen.dart';
import 'package:flash_chat_app/screen/login_screen.dart';
import 'package:flash_chat_app/screen/registration_screen.dart';
import 'package:flash_chat_app/screen/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const FlashChat());
  });
}

class FlashChat extends StatelessWidget {
  const FlashChat({key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id:(context)=>const WelcomeScreen(),
        LoginScreen.id:(context)=>const LoginScreen(),
        RegistrationScreen.id:(context)=>const RegistrationScreen(),
        ChatScreen.id:(context)=>const ChatScreen(),
      },

      );
  }
}

