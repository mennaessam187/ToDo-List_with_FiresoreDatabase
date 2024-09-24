import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstproject_firebase/Tasks/editTask.dart';
import 'package:firstproject_firebase/componen/TextFormField.dart';
import 'package:firstproject_firebase/planofTask/add.dart';
import 'package:firstproject_firebase/planofTask/edit.dart';
import 'package:firstproject_firebase/planofTask/view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:motion_toast/motion_toast.dart';

class detalesOfMyTask extends StatefulWidget {
  final String categoryid;
  const detalesOfMyTask({super.key, required this.categoryid});

  @override
  State<detalesOfMyTask> createState() => _homepageState();
}

class _homepageState extends State<detalesOfMyTask> {
  List<Map<String, dynamic>> data = [];
  bool loading = true;
  bool isDelete = false;

  getdata() async {
    QuerySnapshot data1 = await FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categoryid)
        .collection('note')
        .get();

    await Future.delayed(Duration(seconds: 1));

    // Attach the document ID to each document's data
    data = data1.docs.map((doc) {
      Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
      docData['id'] = doc.id; // Store document ID with data
      return docData;
    }).toList();

    await Future.delayed(Duration(seconds: 1));
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
      appBar: AppBar(
        backgroundColor: Colors.blue[500],
        title: const Text(
          " Your Plane",
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
                            return Container(
                              width: double.infinity,
                              height: 250,
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
                                          Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 18, 90, 154),
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              "${data[index]['num']}",
                                              style: const TextStyle(
                                                  fontSize: 25,
                                                  color: Colors.white,
                                                  fontFamily: 'DancingScript',
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Container(
                                            width: 200,
                                            height: 200,
                                            child: ListView(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      20.0),
                                                  child: Text(
                                                    "${data[index]['note']}",
                                                    style: const TextStyle(
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: 'SofadiOne',
                                                        color: Color.fromARGB(
                                                            255, 1, 75, 102)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                builder: (context) => editNote(
                                                  catid: widget.categoryid,
                                                  Noteid: data[index]["id"],
                                                  oldNote: data[index]['note'],
                                                  oldnumofnode: data[index]
                                                      ['num'],
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
                                                dialogType: DialogType.warning,
                                                animType: AnimType.rightSlide,
                                                title: 'Delete',
                                                desc:
                                                    'Are you sure you want to delete this category?',
                                                btnCancelOnPress: () {},
                                                btnOkOnPress: () async {
                                                  try {
                                                    isDelete = true;
                                                    //id for note
                                                    String docId =
                                                        data[index]['id'];

                                                    // Delete the document from Firestore
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection(
                                                            'categories')
                                                        .doc(widget.categoryid)
                                                        .collection('note')
                                                        .doc(docId)
                                                        .delete();

                                                    setState(() {
                                                      data.removeAt(index);
                                                    });

                                                    isDelete = false;
                                                    setState(() {});
                                                    Navigator.of(context).pushReplacement(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                detalesOfMyTask(
                                                                    categoryid:
                                                                        widget
                                                                            .categoryid)));

                                                    // Show success message
                                                    MotionToast.success(
                                                      height: 50,
                                                      title:
                                                          const Text("Success"),
                                                      description: const Text(
                                                          "Category deleted successfully"),
                                                    ).show(context);
                                                  } catch (e) {
                                                    MotionToast.error(
                                                      height: 50,
                                                      title: Text("Error"),
                                                      description: Text(
                                                          "Failed to delete category: $e"),
                                                    ).show(context);
                                                  }
                                                },
                                              ).show();
                                            },
                                            icon: Icon(Icons.delete),
                                          ),
                                        ],
                                      ),
                                    ],
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
        shape: CircleBorder(),
        onPressed: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => AddNote(
                    categoriesid: widget.categoryid,
                  )));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
