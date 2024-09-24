import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstproject_firebase/componen/Textfield_Add.dart';
import 'package:firstproject_firebase/componen/materialButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

List<String> items = ['Learning', 'work', 'Shopping', 'personal'];
String? selectedValue;

class editCategory extends StatefulWidget {
  late String catid;
  late String oldName;
  late String olddate;
  late String oldtime;
  late String oldCategory;
  editCategory({
    super.key,
    required this.catid,
    required this.olddate,
    required this.oldName,
    required this.oldtime,
    required this.oldCategory,
  });

  @override
  State<editCategory> createState() => _addCategoryState();
}

class _addCategoryState extends State<editCategory> {
  TextEditingController name = TextEditingController();
  TextEditingController Date = TextEditingController();
  TextEditingController time = TextEditingController();
  GlobalKey<FormState> key14 = GlobalKey();

  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');

  editUser() async {
    ///set instead of update that make you to edit
    ///1-on id you want(not found in database)
    ///2-update the information on Database
    await categories.doc(widget.catid).set(
      {
        'full_name': name.text,
        'Date': Date.text,
        'time': time.text,
        'item': selectedValue,
      },

      ///not forget this to able to edit
      SetOptions(merge: true),
    );
    Navigator.of(context).pushReplacementNamed(
      "homepage",
    );
  }

  void dispose() {
    // TODO: implement dispose
    super.dispose();
    name.dispose();
    Date.dispose();
  }

  @override
  void initState() {
    ///here i want when open this page of edit
    ///gve me old data of this id
    name.text = widget.oldName;
    Date.text = widget.olddate;
    time.text = widget.oldtime;
    selectedValue = widget.oldCategory;
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
                      "Edit Task",
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
                      "Enter Name Task", name, Icon(Icons.note_add_outlined),
                      (val) {
                    if (val!.isEmpty) {
                      return "Can't This field Empty";
                    }
                  }, () {}),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Addtext(
                      "Enter Task Date", Date, Icon(Icons.date_range_outlined),
                      (val) {
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
                  child: Addtext(
                      "Enter Task Time", time, Icon(Icons.timer_outlined),
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
                    editUser();
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
