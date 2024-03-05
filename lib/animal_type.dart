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

class Pet {
  final String name;
  final String type;
  final int age;

  Pet({required this.name, required this.type, required this.age});
}

class _AmimaltypeState extends State<Amimaltype> {

  late Stream<QuerySnapshot> _petStream;
  late TypeList _selectedType;
  late bool _sortAscending;

  late Stream<QuerySnapshot> _petStream;
  final FirestoreService = FirebaseFirestore.instance;

  final Stream<QuerySnapshot> _petstream = FirebaseFirestore.instance.collection('pet').snapshots();

  @override
  void initState() {
    super.initState();
    _petStream = FirebaseFirestore.instance.collection('pet').snapshots();
    _selectedType = TypeList.dog;
    _sortAscending = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton<String>(
              onSelected: (value),
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
              ]
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
    stream: _petStream,
    builder: (context, snapshot) {
    if (snapshot.hasError) {
    List<DocumentSnapshot> petData = snapshot.data!.docs;
    return ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          Map<String,dynamic> petData = petData[index].data()! as Map<String, dynamic>;
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemCount: petDate.length);
    }else{
      return const Center(
        child: CircularProgressIndicator(),
      );
    };
    },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const TypeInput())),
        child: const Icon(Icons.add),),
    );
  }
}

