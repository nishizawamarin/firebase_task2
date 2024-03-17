import 'package:flutter/material.dart';
import 'package:firebase_task2/type_input.dart';
import 'package:firebase_task2/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Amimaltype extends StatefulWidget {
  const Amimaltype({super.key});

  @override
  State<Amimaltype> createState() => _AmimaltypeState();
}

class _AmimaltypeState extends State<Amimaltype> {
  late Stream<QuerySnapshot> petStream;
  final FirestoreService firestoreService = FirestoreService();

  late Stream<QuerySnapshot> _petStream =
      FirebaseFirestore.instance.collection('pet').snapshots();

  late Stream<QuerySnapshot> _dogpetStream = FirebaseFirestore.instance
      .collection('pet')
      .orderBy('age', descending: false)
      .where('type', isEqualTo: '犬')
      .snapshots();

  late Stream<QuerySnapshot> _catpetStream = FirebaseFirestore.instance
      .collection('pet')
      .where('type', isEqualTo: '猫')
      .snapshots();

  late Stream<QuerySnapshot> _ageascendingpetStream = FirebaseFirestore.instance
      .collection('pet')
      .orderBy('age', descending: false)
      .snapshots();

  late Stream<QuerySnapshot> _agedescendingpetStream = FirebaseFirestore
      .instance
      .collection('pet')
      .orderBy('age', descending: true)
      .snapshots();

  @override
  void initState() {
    super.initState();
    petStream = FirebaseFirestore.instance.collection('pet').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton(
              onSelected: (value) {
                switch (value) {
                  case 'dog':
                    setState(() {
                      switch (value) {
                        case 'dog':
                          _petStream = _dogpetStream;
                          break;
                        case 'cat':
                          _petStream = _catpetStream;
                          break;
                        case 'ascending':
                          _petStream = _ageascendingpetStream;
                          break;
                        case 'descending':
                          _petStream = _agedescendingpetStream;
                          break;
                      }
                    });
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'dog',
                      child: Text('犬のみ'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'cat',
                      child: Text('猫のみ'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'ascending',
                      child: Text('年齢：昇順'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'descending',
                      child: Text('年齢：降順'),
                    ),
                  ]),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _petStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<DocumentSnapshot> petsData = snapshot.data!.docs;

            return ListView.separated(
              itemCount: petsData.length,
              itemBuilder: (BuildContext context, int index) {
                Map<String, dynamic> petData =
                    petsData[index].data()! as Map<String, dynamic>;
                return ListTile(
                  title: Text('名前：${petData['name']}'
                      '品種：${petData['breeds']}'
                      '性別：${petData['gender']}'
                      '年齢：${petData['age']}'),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          ;
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const TypeInput())),
        child: const Icon(Icons.add),
      ),
    );
  }
}
