import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_db/provider/student_provider.dart';

class EditStudentScreen extends StatefulWidget {
  const EditStudentScreen(
      {super.key,
      required this.id,
      required this.lastName,
      required this.firstName});

  final int id;
  final String lastName;
  final String firstName;

  @override
  State<EditStudentScreen> createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudentScreen> {
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();

  @override
  void initState() {
    _lastNameController.text = widget.lastName;
    _firstNameController.text = widget.firstName;
    super.initState();
  }

  @override
  void dispose() {
    _lastNameController.dispose();
    _firstNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final studentProvider =
        Provider.of<StudentProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Edit Student'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  hintText: 'Last Name',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  hintText: 'first Name',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                print('coucou ${widget.id} ${_lastNameController.text}');
                await studentProvider.updateLastName(
                    widget.id, _lastNameController.text);
                await studentProvider.updateFirstName(
                    widget.id, _firstNameController.text);
                if (!context.mounted) return;
                Navigator.of(context).pop();
              },
              child: const Text('Update'),
            )
          ],
        ),
      ),
    );
  }
}
