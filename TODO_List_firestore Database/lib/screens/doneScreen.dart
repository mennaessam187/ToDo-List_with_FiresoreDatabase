import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DoneScreen extends StatefulWidget {
  @override
  _DoneScreenState createState() => _DoneScreenState();
}

class _DoneScreenState extends State<DoneScreen> {
  List<Map<String, dynamic>> doneData = [];
  bool loading = true;

  getDoneData() async {
    QuerySnapshot doneTasks = await FirebaseFirestore.instance
        .collection('categories')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('isDone', isEqualTo: true) // Only fetch done tasks
        .get();

    doneData = doneTasks.docs.map((doc) {
      Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
      docData['id'] = doc.id;
      return docData;
    }).toList();

    loading = false;
    setState(() {});
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
          'Done Tasks',
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
                        "All Done Tasks",
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
                          "${doneData.length}",
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
                      itemCount: doneData.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 5,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            title: Text(
                              doneData[index]['full_name'],
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
                                  doneData[index]['Date']?.isEmpty ?? true
                                      ? "No Date available"
                                      : doneData[index]['Date'],
                                  style: const TextStyle(fontSize: 18),
                                ),
                                Text(
                                  doneData[index]['time']?.isEmpty ?? true
                                      ? "No time available"
                                      : doneData[index]['time'],
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
                                    .doc(doneData[index]['id'])
                                    .delete();

                                // Remove from local list
                                setState(() {
                                  doneData.removeAt(index);
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
