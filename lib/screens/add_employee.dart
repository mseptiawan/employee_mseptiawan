import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AddEmployeeScreen extends StatefulWidget {
  @override
  _AddEmployeeScreenState createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final nameController = TextEditingController();
  final positionController = TextEditingController();
  final databaseRef = FirebaseDatabase.instance.ref('employees');

  void addEmployee() {
    final name = nameController.text.trim();
    final position = positionController.text.trim();

    if (name.isNotEmpty && position.isNotEmpty) {
      databaseRef.push().set({'name': name, 'position': position}).then((_) {
        Navigator.pop(context); // kembali ke home setelah menambah data
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Karyawan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nama'),
            ),
            TextField(
              controller: positionController,
              decoration: InputDecoration(labelText: 'Jabatan'),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: addEmployee, child: Text('Tambah')),
          ],
        ),
      ),
    );
  }
}
