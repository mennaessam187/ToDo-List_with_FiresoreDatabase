import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firstproject_firebase/auth/Login.dart';
import 'package:firstproject_firebase/auth/register.dart';
import 'package:firstproject_firebase/Tasks/addTask.dart';
import 'package:firstproject_firebase/categoryScreens/work.dart';
import 'package:firstproject_firebase/homepage.dart';
import 'package:firstproject_firebase/screens/presentation.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyDZrHHLRVEW_ibfTnTuY0N7TyyDYbYjlkk',
      appId: '1:903946131951:android:f04717c752314f63acbe1a',
      messagingSenderId: '903946131951',
      projectId: 'firstproject-fd465',
      storageBucket: 'myapp-b9yt18.appspot.com',
    ),
  );

  //await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    //function that always show that the personal signin or signout
    //first show signout
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        /*  textTheme: const TextTheme(
         bodyLarge: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
          bodyMedium: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          bodySmall: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        ),
        */
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 187, 222, 251),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          titleTextStyle: TextStyle(
              color: Color.fromARGB(255, 8, 75, 152),
              fontSize: 25,
              fontWeight: FontWeight.bold),
        ),
      ),
      home: (FirebaseAuth.instance.currentUser != null &&
              FirebaseAuth.instance.currentUser!.emailVerified)
          ? welcomeScreen()
          : Login(),
      routes: {
        "Register": (context) => Register(),
        "Login": (context) => Login(),
        "homepage": (context) => homepage(),
        "addCategory": (context) => addCategory(),
        "welcompage": (context) => welcomeScreen(),
      },
    );
  }
}
