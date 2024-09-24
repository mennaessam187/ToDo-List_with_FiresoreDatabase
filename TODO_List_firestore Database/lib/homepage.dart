import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firstproject_firebase/Tasks/editTask.dart';

import 'package:firstproject_firebase/planofTask/view.dart';
import 'package:firstproject_firebase/screens/doneScreen.dart';
import 'package:firstproject_firebase/screens/favoriteScreen.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:motion_toast/motion_toast.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  List<Map<String, dynamic>> data = [];
  bool loading = true;
  bool isDelete = false;

  getdata() async {
    QuerySnapshot data1 = await FirebaseFirestore.instance
        .collection('categories')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    await Future.delayed(const Duration(seconds: 1));

    // Attach the document ID to each document's data
    data = data1.docs.map((doc) {
      Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
      //every data added in category database have id
      ///docDate['id'][]
      ///docDate['time'][]
      ///docDate['date'][]
      ///docDate['name'][]
      docData['id'] = doc.id; // Store document ID with data
      return docData;
    }).toList();

    await Future.delayed(const Duration(seconds: 1));
    loading = false;
    setState(() {});
  }

  @override
  void initState() {
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.asset(
                          "images/personal.png",
                          width: 40,
                          height: 40,
                        ),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      const Text(
                        "menna essam",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 21, 101, 192),
                        ),
                      ),
                    ],
                  ),
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
                            GoogleSignInAccount? googleUser =
                                googleSignIn.currentUser;

                            if (googleUser != null) {
                              // User is signed in with Google, so sign out from Google
                              await googleSignIn.disconnect();
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  "Login", (route) => false);
                            } else {
                              await FirebaseAuth.instance.signOut();

                              // Navigate to the login screen after signing out
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  "Login", (route) => false);
                            }
                          },
                        ).show();
                      },
                      icon: const Icon(Icons.output_rounded))
                ],
              ),
            ),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                "All Tasks",
                style: TextStyle(
                    fontFamily: 'DancingScript',
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                    color: Color.fromARGB(255, 18, 90, 154)),
              ),
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 18, 90, 154),
                  borderRadius: BorderRadius.circular(50),
                ),
                alignment: Alignment.center,
                child: Text(
                  "${data.length}",
                  style: const TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontFamily: 'DancingScript',
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          const Column(
            children: [
              Divider(),
              Text(
                "Screens",
                style: TextStyle(
                    fontFamily: 'DancingScript',
                    fontSize: 35,
                    fontWeight: FontWeight.w800,
                    color: Color.fromARGB(255, 18, 90, 154)),
              ),
              Padding(
                padding: EdgeInsets.only(left: 50.0, right: 50),
                child: Divider(),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => FavoritesScreen()));
            },
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    "Priority",
                    style: TextStyle(
                        fontFamily: 'DancingScript',
                        fontSize: 35,
                        fontWeight: FontWeight.w800,
                        color: Color.fromARGB(255, 18, 90, 154)),
                  ),
                  Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 18, 90, 154),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.screen_share_outlined)),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => DoneScreen()));
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      "Done",
                      style: TextStyle(
                          fontFamily: 'DancingScript',
                          fontSize: 35,
                          fontWeight: FontWeight.w800,
                          color: Color.fromARGB(255, 18, 90, 154)),
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 18, 90, 154),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(Icons.screen_share_outlined)),
                  ],
                ),
              ),
            ),
          )
        ],
      )),
      appBar: AppBar(
        backgroundColor: Colors.blue[500],
        title: const Text(
          "All Tasks",
          style: TextStyle(
              fontFamily: 'DancingScript',
              fontSize: 40,
              fontWeight: FontWeight.w800,
              color: Colors.white),
        ),
      ),
      body: loading == true || isDelete == true
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.blue[800],
              ),
            )
          : Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue[500],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Center(
                        child: Padding(
                      padding: EdgeInsets.only(top: 15.0),
                    )),
                    Container(
                      width: 400,
                      height: 740,
                      decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(50),
                              topRight: Radius.circular(50))),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 8.0, right: 8, top: 8),
                        child: ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            getColor() {
                              if (data[index]['item'] == 'Learning') {
                                return Color(0xff606ebe);
                              } else if (data[index]['item'] == 'Shopping') {
                                return Color(0xff22d532);
                              } else if (data[index]['item'] == 'work') {
                                return Color(0xffea9239);
                              } else
                                return Color(0xffac4093);
                            }

                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => detalesOfMyTask(
                                          categoryid: data[index]['id'],
                                        )));
                              },
                              child: Container(
                                width: double.infinity,
                                height: 150,
                                child: Card(
                                  shape: ContinuousRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                data[index]['isFavorite'] ==
                                                        true // Check if it's currently true
                                                    ? Icons
                                                        .star // Filled star for favorite
                                                    : Icons
                                                        .star_border, // Outlined star for not favorite
                                                color: const Color.fromARGB(
                                                    255, 7, 49, 97),
                                                size: 30,
                                              ),
                                              onPressed: () async {
                                                try {
                                                  // Get the document ID and current favorite status
                                                  String docId =
                                                      data[index]['id'];
                                                  bool isCurrentlyFavorite =
                                                      data[index]['isFavorite'];

                                                  // Toggle the favorite status (if true, make it false, if false, make it true)
                                                  bool newFavoriteStatus =
                                                      !isCurrentlyFavorite;

                                                  // Update the Firestore document with the new status
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('categories')
                                                      .doc(docId)
                                                      .update({
                                                    'isFavorite':
                                                        newFavoriteStatus, // Update to the new status
                                                  });

                                                  // If Firestore update is successful, update local UI
                                                  setState(() {
                                                    data[index]['isFavorite'] =
                                                        newFavoriteStatus; // Update local data
                                                  });
                                                } catch (e) {
                                                  // Handle any errors
                                                  print(
                                                      "Error updating favorite status: $e");
                                                }
                                              },
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${data[index]['full_name']}",
                                                    style: const TextStyle(
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    data[index]['Date']
                                                                ?.isEmpty ??
                                                            true
                                                        ? "No Date available"
                                                        : data[index]['Date'],
                                                    style: const TextStyle(
                                                        fontSize: 18),
                                                  ),
                                                  Text(
                                                    data[index]['time']
                                                                ?.isEmpty ??
                                                            true
                                                        ? "No time available"
                                                        : data[index]['time'],
                                                    style: const TextStyle(
                                                        fontSize: 14),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width: 16,
                                                        height: 16,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          color: getColor(),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        data[index]['item']
                                                                    ?.isEmpty ??
                                                                true
                                                            ? "No time available"
                                                            : data[index]
                                                                ['item'],
                                                        style: const TextStyle(
                                                            fontSize: 14),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () async {
                                                String id = data[index]['id'];
                                                bool currentDone =
                                                    data[index]['isDone'];
                                                bool newValueOfDone =
                                                    !currentDone;
                                                await FirebaseFirestore.instance
                                                    .collection('categories')
                                                    .doc(id)
                                                    .update({
                                                  'isDone': newValueOfDone
                                                });
                                                setState(() {
                                                  data[index]['isDone'] =
                                                      newValueOfDone;
                                                });
                                                setState(() {
                                                  newValueOfDone
                                                      ? data.removeAt(index)
                                                      : null;
                                                });
                                              },
                                              icon: Icon(
                                                data[index]['isDone'] == true
                                                    ? Icons.check_box
                                                    : Icons
                                                        .check_box_outline_blank_rounded,
                                              ),
                                            ),
                                            /* IconButton(
                                              icon: Icon(
                                                data[index]['isdone'] == true
                                                    ? Icons
                                                        .check_box // If already marked done
                                                    : Icons
                                                        .check_box_outline_blank, // If not done
                                                color: Colors.blue[800],
                                              ),
                                              onPressed: () async {
                                                String docId =
                                                    data[index]['id'];

                                                // Safely check if isdone exists and is a bool, default to false
                                                bool isCurrentlyDone =
                                                    (data[index]['isdone']
                                                            as bool?) ??
                                                        false;

                                                // Toggle the isdone field in Firestore
                                                await FirebaseFirestore.instance
                                                    .collection('categories')
                                                    .doc(docId)
                                                    .update({
                                                  'isdone':
                                                      !isCurrentlyDone, // Set to true if not done
                                                });

                                                // Move to Done List by removing from current list
                                                setState(() {
                                                  data.removeAt(
                                                      index); // Remove from current task list
                                                });
                                              },
                                            ),
                                            */
                                            IconButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                        MaterialPageRoute(
                                                  builder: (context) =>
                                                      editCategory(
                                                    catid: data[index]["id"],
                                                    olddate: data[index]
                                                        ['Date'],
                                                    oldName: data[index]
                                                        ['full_name'],
                                                    oldtime: data[index]
                                                        ['time'],
                                                    oldCategory: data[index]
                                                        ['item'],
                                                  ),
                                                ));
                                              },
                                              icon: const Icon(Icons
                                                  .drive_file_rename_outline_outlined),
                                            ),
                                            IconButton(
                                              onPressed: () async {
                                                AwesomeDialog(
                                                  context: context,
                                                  dialogType:
                                                      DialogType.warning,
                                                  animType: AnimType.rightSlide,
                                                  title: 'Delete',
                                                  desc:
                                                      'Are you sure you want to delete this category?',
                                                  btnCancelOnPress: () {},
                                                  btnOkOnPress: () async {
                                                    try {
                                                      isDelete = true;
                                                      String docId =
                                                          data[index]['id'];

                                                      // Delete the document from Firestore
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'categories')
                                                          .doc(docId)
                                                          .delete();

                                                      setState(() {
                                                        data.removeAt(index);
                                                      });

                                                      isDelete = false;
                                                      setState(() {});
                                                      Navigator.of(context)
                                                          .pushReplacementNamed(
                                                              'homepage');

                                                      // Show success message
                                                      MotionToast.success(
                                                        height: 50,
                                                        title: const Text(
                                                            "Success"),
                                                        description: const Text(
                                                            "Category deleted successfully"),
                                                      ).show(context);
                                                    } catch (e) {
                                                      MotionToast.error(
                                                        height: 50,
                                                        title:
                                                            const Text("Error"),
                                                        description: Text(
                                                            "Failed to delete category: $e"),
                                                      ).show(context);
                                                    }
                                                  },
                                                ).show();
                                              },
                                              icon: const Icon(Icons.delete),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[800],
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.of(context).pushNamed("addCategory");
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
