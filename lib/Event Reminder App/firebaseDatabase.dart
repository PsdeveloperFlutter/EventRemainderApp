import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
      appBar: AppBar(title: Text('Firestore User List')),
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
                child: ListTile(
                  title: Text(data['name'] ?? 'No Name'),
                  subtitle: Text(data['location']??'No Location')
                  ,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          users.doc(doc.id).delete();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
