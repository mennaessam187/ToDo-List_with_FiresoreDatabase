import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

int? workListCount;

class workScreen extends StatefulWidget {
  final Function(int?) onCountUpdate; // Add this line
  workScreen({required this.onCountUpdate});
  @override
  _DoneScreenState createState() => _DoneScreenState();
}

class _DoneScreenState extends State<workScreen> {
  bool loading = true;
  List<Map<String, dynamic>> workData = [];

  getDoneData() async {
    QuerySnapshot workTasks = await FirebaseFirestore.instance
        .collection('categories')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('item', isEqualTo: 'work') // Only fetch done tasks
        .get();

    workData = workTasks.docs.map((doc) {
      Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
      docData['id'] = doc.id;
      return docData;
    }).toList();

    //setState(() {});
    /*setState(() {
      workListCount = doneTasks.size;
      loading = false;
    });
    */
    setState(() {
      workListCount = workTasks.docs.length;
      widget.onCountUpdate(workListCount); // Update count here
      loading = false;
    });
  }

  @override
  void initState() {
    getDoneData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[500],
      appBar: AppBar(
        title: const Text(
          'Work Tasks',
          style: TextStyle(
              fontFamily: 'DancingScript',
              fontSize: 40,
              fontWeight: FontWeight.w800,
              color: Colors.white),
        ),
        backgroundColor: Colors.blue[500],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: All Done Tasks and Count
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "All Work Tasks",
                        style: TextStyle(
                          fontFamily: 'DancingScript',
                          fontSize: 35,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
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
                          "${workData.length}",
                          style: const TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontFamily: 'DancingScript',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // List of Done Tasks
                  Expanded(
                    child: ListView.builder(
                      itemCount: workData.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 5,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            title: Text(
                              workData[index]['full_name'],
                              style: const TextStyle(
                                fontFamily: 'SofadiOne',
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 2, 43, 104),
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  workData[index]['Date']?.isEmpty ?? true
                                      ? "No Date available"
                                      : workData[index]['Date'],
                                  style: const TextStyle(fontSize: 18),
                                ),
                                Text(
                                  workData[index]['time']?.isEmpty ?? true
                                      ? "No time available"
                                      : workData[index]['time'],
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Color.fromARGB(255, 0, 7, 61)),
                              onPressed: () async {
                                // Delete task from Firestore
                                await FirebaseFirestore.instance
                                    .collection('categories')
                                    .doc(workData[index]['id'])
                                    .delete();

                                // Remove from local list
                                setState(() {
                                  workData.removeAt(index);
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
