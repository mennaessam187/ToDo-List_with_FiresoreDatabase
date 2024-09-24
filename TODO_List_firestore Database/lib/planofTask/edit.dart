import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstproject_firebase/componen/Textfield_Add.dart';
import 'package:firstproject_firebase/componen/materialButton.dart';
import 'package:firstproject_firebase/planofTask/view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class editNote extends StatefulWidget {
  late String catid;
  late String oldNote;
  late String Noteid;
  late String oldnumofnode;
  editNote({
    super.key,
    required this.catid,
    required this.oldNote,
    required this.Noteid,
    required this.oldnumofnode,
  });

  @override
  State<editNote> createState() => _addCategoryState();
}

class _addCategoryState extends State<editNote> {
  TextEditingController note = TextEditingController();
  TextEditingController num = TextEditingController();
  GlobalKey<FormState> key14 = GlobalKey();

  addUser() async {
    CollectionReference notes = FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.catid)
        .collection('note');
    await notes.doc(widget.Noteid).update(
      {
        'note': note.text,
        'num': num.text,
      },
    );
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => detalesOfMyTask(categoryid: widget.catid)));
  }

  void dispose() {
    // TODO: implement dispose
    super.dispose();
    note.dispose();
    num.dispose();
  }

  @override
  void initState() {
    note.text = widget.oldNote;
    num.text = widget.oldnumofnode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: key14,
        child: Container(
          decoration: BoxDecoration(color: Colors.blue[100]),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.drive_file_rename_outline_outlined,
                      color: Colors.white,
                      size: 45,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Edit Your Plane",
                      style: TextStyle(
                          fontFamily: 'DancingScript',
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                          color: Colors.white),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Addtext(
                      "Enter Name Task", num, Icon(Icons.note_add_outlined),
                      (val) {
                    if (val!.isEmpty) {
                      return "Can't This field Empty";
                    }
                  }, () {}),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Addtext(
                      "Enter Name Task", note, Icon(Icons.note_add_outlined),
                      (val) {
                    if (val!.isEmpty) {
                      return "Can't This field Empty";
                    }
                  }, () {}),
                ),
                materialbutton(() {
                  if (key14.currentState!.validate()) {
                    addUser();
                  }
                }, "Save")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
