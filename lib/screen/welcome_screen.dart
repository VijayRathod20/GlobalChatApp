import 'package:flash_chat_app/screen/login_screen.dart';
import 'package:flash_chat_app/screen/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatefulWidget {
  static  const String id = 'welcome_screen';
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{
  late AnimationController controller;
  late Animation animation;
  @override
  void initState(){
    super.initState();
    controller=AnimationController(duration: const Duration(seconds: 1),vsync: this);
    animation=ColorTween(begin: Colors.lightBlueAccent,end: Colors.white).animate(controller);
    controller.forward();
    controller.addListener(() {
      setState((){});
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: "logo",
                  child: SizedBox(
                    height: controller.value*75,
                    child: Image.asset('images/chat.png'),
                  ),
                ),
              TypewriterAnimatedTextKit(
                  text: const ['Global Chat'],
                  totalRepeatCount: 1,
                  speed: const Duration(milliseconds: 200),
                  pause: const Duration(milliseconds:  100),
                  textStyle: const TextStyle(fontSize: 45.0, fontWeight: FontWeight.w900),
                  displayFullTextOnTap: true,
                  stopPauseOnTap: true,
                  repeatForever: false,
              ),
              ],
            ),
            const SizedBox(
              height: 48.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                elevation: 5.0,
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(30.0),
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(context,LoginScreen.id);
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: const Text(
                    'Log In',
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(30.0),
                elevation: 5.0,
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(context,RegistrationScreen.id);
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: const Text(
                    'Register',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}