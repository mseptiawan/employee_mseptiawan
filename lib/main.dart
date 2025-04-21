import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:employee_mseptiawan/screens/add_employee.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(EmployeeApp());
}

class EmployeeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Employee Septiawan',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final databaseRef = FirebaseDatabase.instance.ref('employees');
  List<Map<String, dynamic>> employees = [];

  @override
  void initState() {
    super.initState();
    fetchEmployees();
  }

  void fetchEmployees() {
    databaseRef.onValue.listen((event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        final loadedEmployees =
            data.entries.map((e) {
              final value = Map<String, dynamic>.from(e.value);
              return {
                'key': e.key,
                'name': value['name'],
                'position': value['position'],
              };
            }).toList();
        setState(() {
          employees = loadedEmployees;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Data Karyawan')),
      body: ListView.builder(
        itemCount: employees.length,
        itemBuilder: (ctx, index) {
          final emp = employees[index];
          return ListTile(
            leading: CircleAvatar(child: Text(emp['name'][0])),
            title: Text(emp['name']),
            subtitle: Text(emp['position']),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEmployeeScreen()),
          );
        },
      ),
    );
  }
}
