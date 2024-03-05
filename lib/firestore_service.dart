import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class FirestoreService {
  final _firestore = FirebaseFirestore.instance;


  Stream<QuerySnapshot> getPetStream() {
    return _firestore.collection('pet').snapshots();
  }

  Future<void> addPet(Map<String, dynamic> pet) async {
    await _firestore.collection('pet').add(pet);
  }

}