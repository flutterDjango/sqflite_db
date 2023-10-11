import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_db/provider/student_provider.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final studentProvider = Provider.of<StudentProvider>(context, listen:false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Add a student'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(hintText: 'Last Name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(hintText: 'First Name'),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await studentProvider.insertData(
                _lastNameController.text, _firstNameController.text);
                _firstNameController.clear();
                _lastNameController.clear();
              if (!context.mounted) return;
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
