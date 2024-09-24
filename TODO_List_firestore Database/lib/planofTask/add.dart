import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstproject_firebase/componen/Textfield_Add.dart';
import 'package:firstproject_firebase/componen/materialButton.dart';
import 'package:firstproject_firebase/planofTask/view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class AddNote extends StatefulWidget {
  final String categoriesid;

  AddNote({super.key, required this.categoriesid});

  @override
  State<AddNote> createState() => _addCategoryState();
}

class _addCategoryState extends State<AddNote> {
  TextEditingController note = TextEditingController();
  TextEditingController num = TextEditingController();
  GlobalKey<FormState> key14 = GlobalKey();

  addNode() async {
    CollectionReference categorynote = FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categoriesid)
        .collection('note');
    try {
      categorynote
          .add({
            'note': note.text,
            'num': num.text,
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));

      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => detalesOfMyTask(
                categoryid: widget.categoriesid,
              )));
    } catch (e) {
      print("Error:$e");
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    note.dispose();
    num.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Container(
          decoration: BoxDecoration(color: Colors.blue[100]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_box,
                    color: Colors.white,
                    size: 45,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Enter your plane",
                    style: TextStyle(
                        fontFamily: 'DancingScript',
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        color: Colors.white),
                  ),
                ],
              ),
              Form(
                key: key14,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Addtext("Enter Note number", num,
                          Icon(Icons.note_add_outlined), (val) {
                        if (val!.isEmpty) {
                          return "Can't This field Empty";
                        }
                      }, () {}),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Addtext("Enter Your Note", note,
                          Icon(Icons.note_add_outlined), (val) {
                        if (val!.isEmpty) {
                          return "Can't This field Empty";
                        }
                      }, () {}),
                    ),
                    materialbutton(() {
                      if (key14.currentState!.validate()) {
                        addNode();
                      }
                    }, "Add")
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
