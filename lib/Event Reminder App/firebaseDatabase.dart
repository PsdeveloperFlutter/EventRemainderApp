import 'package:cloud_firestore/cloud_firestore.dart';
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
  void deleteUsers(String docId) {
    Firebase.collection('EventRemainderusers').doc(docId).delete();
  }
  void getUsers() {
    Firebase.collection('EventRemainderusers').snapshots().listen((snapshot) {
      for (var doc in snapshot.docs) {
        print(doc.data());
      }
    });
  }
}
