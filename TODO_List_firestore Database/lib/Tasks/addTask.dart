import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstproject_firebase/componen/Textfield_Add.dart';
import 'package:firstproject_firebase/componen/materialButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class addCategory extends StatefulWidget {
  const addCategory({super.key});

  @override
  State<addCategory> createState() => _addCategoryState();
}

List<String> items = ['Learning', 'work', 'Shopping', 'personal'];
String? selectedValue;
late Function(int?) onTaskAdded;

class _addCategoryState extends State<addCategory> {
  TextEditingController name = TextEditingController();
  TextEditingController Date = TextEditingController();
  TextEditingController time = TextEditingController();
  bool isDone = false;
  bool isFavorite = false;
  GlobalKey<FormState> key14 = GlobalKey();
  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');

  addUser() {
    try {
      categories
          .add({
            'full_name': name.text,
            'Date': Date.text,
            'time': time.text,
            'isDone': isDone,
            'isFavorite': isFavorite,
            'item': selectedValue,
            'id': FirebaseAuth.instance.currentUser!.uid
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));

      Navigator.of(context).pushReplacementNamed(
        "homepage",
      );
    } catch (e) {
      print("Error:$e");
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    name.dispose();
    Date.dispose();
    time.dispose();
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
                    "Add Task",
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
                      child: Addtext("Enter Task Name", name,
                          Icon(Icons.note_add_outlined), (val) {
                        if (val!.isEmpty) {
                          return "Can't This field Empty";
                        }
                      }, () {}),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Addtext("Enter Task Date", Date,
                          Icon(Icons.date_range_outlined), (val) {
                        if (val!.isEmpty) {
                          return "Can't This field Empty";
                        }
                      }, () {
                        showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          initialDate: DateTime.now(),
                          lastDate: DateTime.parse('3119-05-09'),
                        ).then((value) {
                          Date.text = DateFormat.yMMMd().format(value!);
                        });
                      }),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Addtext("Enter Task Time", time, Icon(Icons.timer),
                          (val) {
                        if (val!.isEmpty) {
                          return "Can't This field Empty";
                        }
                      }, () {
                        showTimePicker(
                                context: context, initialTime: TimeOfDay.now())
                            .then((value) {
                          time.text = value!.format(context);
                        });
                      }),
                    ),
                    Container(
                        padding: EdgeInsets.all(20),
                        child: DropdownButton2(
                          hint: Text('Select an Category'),
                          items: items
                              .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(item),
                                  ))
                              .toList(),
                          value: selectedValue,
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value as String;
                            });
                          },
                        )),
                    materialbutton(() {
                      if (key14.currentState!.validate()) {
                        //بقوله لما ادوس addروح حط الداتا ف categoryوانقلني للصفحه التانيه
                        addUser();
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
