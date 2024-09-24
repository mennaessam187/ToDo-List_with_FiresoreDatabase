// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Map<String, dynamic>> favoriteData = [];
  bool loading = true;

  getFavoriteData() async {
    QuerySnapshot favorites = await FirebaseFirestore.instance
        .collection('categories')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('isFavorite', isEqualTo: true) // Filter for favorites
        .get();

    favoriteData = favorites.docs.map((doc) {
      Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
      docData['id'] = doc.id;
      return docData;
    }).toList();

    loading = false;
    setState(() {});
  }

  @override
  void initState() {
    getFavoriteData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[500],
      appBar: AppBar(
        title: const Text(
          'Priority Tasks',
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
                  // Header: All Tasks and Count
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "All Tasks",
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
                          "${favoriteData.length}",
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

                  // List of Favorite Tasks
                  Expanded(
                    child: ListView.builder(
                      itemCount: favoriteData.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 5,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            title: Text(
                              favoriteData[index]['full_name'],
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
                                  favoriteData[index]['Date']?.isEmpty ?? true
                                      ? "No Date available"
                                      : favoriteData[index]['Date'],
                                  style: const TextStyle(fontSize: 18),
                                ),
                                Text(
                                  favoriteData[index]['time']?.isEmpty ?? true
                                      ? "No time available"
                                      : favoriteData[index]['time'],
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
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
