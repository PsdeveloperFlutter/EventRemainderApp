import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class fireBaseDataBase {
  final Firebase = FirebaseFirestore.instance;

  void addUsers(
    String name,
    String location,
    String dateandtime,
    String description,
    String category,
    String priority,
    String image_path,
    String file_path,
    String video_path,
    String reminder_time,
  ) {
    Firebase.collection('EventRemainderusers').add({
      'name': name,
      'location': location,
      'dateandtime': dateandtime,
      'description': description,
      'category': category,
      'priority': priority
    }).then((value) => print('Data Added'));
  }

  void updateUsers(
    String docId,
    String name,
    String location,
    String dateandtime,
    String description,
    String category,
  ) {
    Firebase.collection('EventRemainderusers').doc(docId).update({
      'name': name,
      'location': location,
      'dateandtime': dateandtime,
      'description': description,
      'category': category,
    });
  }

  void getUsers() {
    Firebase.collection('EventRemainderusers').snapshots().listen((snapshot) {
      for (var doc in snapshot.docs) {
        print(doc.data());
      }
    });
  }
}

class FirestoreListScreen extends StatefulWidget {
  @override
  State<FirestoreListScreen> createState() => _FirestoreListScreenState();
}

class _FirestoreListScreenState extends State<FirestoreListScreen> {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('EventRemainderusers');

  // Your Firestore collection
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Task List ')),
      body: StreamBuilder<QuerySnapshot>(
        stream: users.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No users found.'));
          }
          final docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  width: 300,
                  height: 250,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        InkWell(
                            onTap: () {
                              updateFunction(context, "name", doc.id);
                            },
                            child: Text(
                              "Task Name :- " + data['name'] ?? 'No Name',
                              style: GoogleFonts.aBeeZee(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                        InkWell(
                            onTap: () {
                              updateFunction(context, "location", doc.id);
                            },
                            child: Text(
                              "Location :- " + data['location'] ??
                                  'No Location',
                              style: GoogleFonts.aBeeZee(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                        InkWell(
                          onTap: () {
                            updateFunction(context, "category", doc.id);
                          },
                          child: Text(
                            "Category :- " + data['category'] == null
                                ? 'No Category'
                                : data['category'],
                            style: GoogleFonts.aBeeZee(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            updateFunction(context, "dateandtime", doc.id);
                          },
                          child: Text(
                            "Date and Time :- " +
                                    DateFormat('dd-MM-yyyy - hh:mm a').format(
                                        DateTime.parse(data['dateandtime'])) ??
                                'No Date and Time',
                            style: GoogleFonts.aBeeZee(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            updateFunction(context, "description", doc.id);
                          },
                          child: Text(
                            "Description :- " + data['description'] ??
                                'No Description',
                            style: GoogleFonts.aBeeZee(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                           showDialog(context: context, builder: (context){
                             return AlertDialog(
                               title: Text("Delete"),
                               content: Text("Are you sure you want to delete this task?"),
                               actions: [
                                 TextButton(onPressed: () {
                                   Navigator.pop(context);
                                 }, child: Text("Cancel")),
                                 TextButton(onPressed: () {
                                   users.doc(doc.id).delete();
                                   Navigator.pop(context);
                                 }, child: Text("Delete")),
                               ],
                             );
                           });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void updateFunction(BuildContext context, String value, String docId) {
    final TextEditingController _controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update $value'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'Enter new $value',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (value == "name") {
                  FirebaseFirestore.instance
                      .collection('EventRemainderusers')
                      .doc(docId)
                      .update({
                    'name': _controller.text.trim(),
                  });
                } else if (value == "location") {
                  FirebaseFirestore.instance
                      .collection('EventRemainderusers')
                      .doc(docId)
                      .update({
                    'location': _controller.text.trim(),
                  });
                } else if (value == "dateandtime") {
                  FirebaseFirestore.instance
                      .collection('EventRemainderusers')
                      .doc(docId)
                      .update({
                    'dateandtime': _controller.text.trim(),
                  });
                } else if (value == "description") {
                  FirebaseFirestore.instance
                      .collection('EventRemainderusers')
                      .doc(docId)
                      .update({
                    'description': _controller.text.trim(),
                  });
                } else if (value == "category") {
                  FirebaseFirestore.instance
                      .collection('EventRemainderusers')
                      .doc(docId)
                      .update({
                    'category': _controller.text.trim(),
                  });
                } else if (value == "priority") {
                  FirebaseFirestore.instance
                      .collection('EventRemainderusers')
                      .doc(docId)
                      .update({
                    'priority': _controller.text.trim(),
                  });
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
