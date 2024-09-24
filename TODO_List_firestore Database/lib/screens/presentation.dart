import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstproject_firebase/categoryScreens/learning.dart';
import 'package:firstproject_firebase/categoryScreens/shopping.dart';
import 'package:firstproject_firebase/categoryScreens/work.dart';
import 'package:firstproject_firebase/screens/doneScreen.dart';
import 'package:firstproject_firebase/screens/favoriteScreen.dart';
import 'package:firstproject_firebase/categoryScreens/personal.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class welcomeScreen extends StatefulWidget {
  const welcomeScreen({super.key});

  @override
  State<welcomeScreen> createState() => _welcomeScreenState();
}

class _welcomeScreenState extends State<welcomeScreen> {
  int? workListCount;
  int? shoppingListCount;
  int? learningListCount;
  int? personalListCount;
  void updateWorkCount(int? count) {
    setState(() {
      workListCount = count;
    });
  }

  void updateshoppingCount(int? count) {
    setState(() {
      shoppingListCount = count;
    });
  }

  void updatepersonalCount(int? count) {
    setState(() {
      personalListCount = count;
    });
  }

  void updatelearnngCount(int? count) {
    setState(() {
      learningListCount = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 187, 222, 251),
      appBar: AppBar(
        actions: [
          IconButton(
              color: Colors.blue[800],
              onPressed: () async {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.warning,
                  animType: AnimType.rightSlide,
                  title: 'Sign Out',
                  desc: 'Are You Sure Sign out of your account',
                  btnCancelOnPress: () {
                    Navigator.of(context).pop();
                  },
                  btnOkOnPress: () async {
                    GoogleSignIn googleSignIn = GoogleSignIn();

                    // Check if the user is signed in with Google
                    GoogleSignInAccount? googleUser = googleSignIn.currentUser;

                    if (googleUser != null) {
                      // User is signed in with Google, so sign out from Google
                      await googleSignIn.disconnect();
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil("Login", (route) => false);
                    } else {
                      await FirebaseAuth.instance.signOut();

                      // Navigate to the login screen after signing out
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil("Login", (route) => false);
                    }
                  },
                ).show();
              },
              icon: const Icon(Icons.output_rounded))
        ],
        leading: const Icon(
          Icons.list_rounded,
          size: 50,
          color: Color.fromARGB(255, 13, 71, 161),
        ),
        title: const Text(
          'Lists',
          style: TextStyle(fontFamily: 'DancingScript', fontSize: 50),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: Container(
              width: 390,
              height: 250,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 131, 164, 202),
                borderRadius: BorderRadius.circular(40),
                border: Border.all(
                    color: Color.fromARGB(255, 249, 234, 234), width: 1),
              ),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed('homepage');
                      },
                      child: Container(
                        child: const Row(
                          children: [
                            Icon(Icons.task),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'All Tasks',
                              style: TextStyle(
                                  fontFamily: 'DancingScript',
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => DoneScreen()));
                      },
                      child: Row(
                        children: [
                          Icon(Icons.check_box),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Done Tasks',
                            style: TextStyle(
                                fontFamily: 'DancingScript',
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => FavoritesScreen()));
                      },
                      child: Row(
                        children: [
                          Icon(Icons.star_rate),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Important Tasks',
                            style: TextStyle(
                                fontFamily: 'DancingScript',
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => personalScreen(
                            onCountUpdate:
                                updatepersonalCount))); // Pass the callback
                  },
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: const BoxDecoration(
                      color: Color(0xffac4093),
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0, left: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 40,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            'Personal',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 15.0, left: 15),
                            child: Text(
                              personalListCount?.toString() ?? '00',
                              style: TextStyle(
                                fontFamily: 'DancingScript',
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: Colors.blue[100],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => learningScreen(
                            onCountUpdate:
                                updatelearnngCount))); // Pass the callback
                  },
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: const BoxDecoration(
                      color: Color(0xff606ebe),
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15.0, left: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.drive_file_rename_outline_outlined,
                            color: Colors.white,
                            size: 40,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            'Learning',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 15.0, left: 15),
                            child: Text(
                              learningListCount?.toString() ?? '00',
                              style: TextStyle(
                                fontFamily: 'DancingScript',
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: Colors.blue[100],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ShoppingScreen(
                            onCountUpdate:
                                updateshoppingCount))); // Pass the callback
                  },
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: const BoxDecoration(
                      color: Color(0xff22d532),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15.0, left: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.shopping_cart,
                            color: Colors.white,
                            size: 40,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            'Shopping',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 15.0, left: 15),
                            child: Text(
                              shoppingListCount?.toString() ?? '00',
                              style: TextStyle(
                                fontFamily: 'DancingScript',
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: Colors.blue[100],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => workScreen(
                            onCountUpdate:
                                updateWorkCount))); // Pass the callback
                  },
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: const BoxDecoration(
                      color: Color(0xffea9239),
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15.0, left: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.work_history,
                            color: Colors.white,
                            size: 40,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            'Work',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 15.0, left: 15),
                            child: Text(
                              workListCount?.toString() ?? '00',
                              style: TextStyle(
                                fontFamily: 'DancingScript',
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: Colors.blue[100],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
