import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_task2/firestore_service.dart';
import 'package:firebase_task2/animal_type.dart';

class TypeInput extends StatefulWidget {
  const TypeInput({Key? key}) : super(key: key);

  @override
  State<TypeInput> createState() => _TypeInputState();
}

enum TypeList { dog, cat }

TypeList _type = TypeList.dog;

enum GenderList { male, female }

GenderList _gender = GenderList.male;

class _TypeInputState extends State<TypeInput> {
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _breedscontroller = TextEditingController();
  final TextEditingController _agecontroller = TextEditingController();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final FirestoreService = FirebaseFirestore.instance;

  final Stream<QuerySnapshot> petStream =
      FirebaseFirestore.instance.collection('pet').snapshots();

  @override
  void dispose() {
    _namecontroller.dispose();
    _breedscontroller.dispose();
    _agecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 5,
          ),
          TextField(
            controller: _namecontroller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: '名前',
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: RadioListTile(
                    title: const Text('犬'),
                    controlAffinity: ListTileControlAffinity.leading,
                    value: TypeList.dog,
                    groupValue: _type,
                    onChanged: (value) {
                      setState(() {
                        _type = value!;
                      });
                    }),
              ),
              Expanded(
                child: RadioListTile(
                    title: const Text('猫'),
                    controlAffinity: ListTileControlAffinity.leading,
                    value: TypeList.cat,
                    groupValue: _type,
                    onChanged: (value) {
                      setState(() {
                        _type = value!;
                      });
                    }),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: _breedscontroller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: '品種',
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: RadioListTile(
                    title: const Text('オス'),
                    controlAffinity: ListTileControlAffinity.leading,
                    value: GenderList.male,
                    groupValue: _gender,
                    onChanged: (value) {
                      _gender = value!;
                    }),
              ),
              Expanded(
                child: RadioListTile(
                    title: const Text('メス'),
                    controlAffinity: ListTileControlAffinity.leading,
                    value: GenderList.female,
                    groupValue: _gender,
                    onChanged: (value) {
                      _gender = value!;
                    }),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: _agecontroller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: '年齢',
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            child: const Text('登録'),
            onPressed: () async {
              await firestore.collection('pets').add({
                'name': _namecontroller.text,
                'type': _type.toString().split('.').last,
                'breeds': _breedscontroller.text,
                'gender': _gender.toString().split('.').last,
                'age': int.parse(_agecontroller.text),
              });
              _namecontroller.clear();
              _breedscontroller.clear();
              _agecontroller.clear();
              setState(() {
                _type = TypeList.dog;
                _gender = GenderList.male;
              });
            },
          ),
        ],
      ),
    );
  }
}
