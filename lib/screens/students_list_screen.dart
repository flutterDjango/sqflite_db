import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_db/provider/student_provider.dart';
import 'package:sqflite_db/screens/add_student_screen.dart';
import 'package:sqflite_db/screens/edit_student_screen.dart';

class StudentsListScreen extends StatefulWidget {
  const StudentsListScreen({super.key});

  @override
  State<StudentsListScreen> createState() => _StudentsListScreenState();
}

class _StudentsListScreenState extends State<StudentsListScreen> {
  late Future data;
  @override
  void initState() {
    super.initState();
    data = _fetchData();
  }

  _fetchData() {
    return data = Provider.of<StudentProvider>(context, listen: false).selectData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Students list"),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AddStudentScreen()));
              setState(() {
                data = _fetchData();
              });
            },
            icon: Icon(
              Icons.add,
              color: Theme.of(context).colorScheme.inversePrimary,
              size: 25,
            ),
            style: IconButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.onPrimary),
          ),
        ],
      ),
      body: FutureBuilder(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Consumer<StudentProvider>(
                builder: (context, studentProvider, child) {
              return studentProvider.studentItem.isNotEmpty
                  ? ListView.builder(
                      itemCount: studentProvider.studentItem.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 5,
                          child: ListTile(
                            leading: Text(studentProvider.studentItem[index].id
                                .toString()),
                            title: Text(
                                studentProvider.studentItem[index].lastName),
                            subtitle: Text(
                                studentProvider.studentItem[index].firstName),
                            trailing: IconButton(
                              onPressed: () async {
                                await studentProvider.deleteById(
                                    studentProvider.studentItem[index].id!);
                                setState(() {
                                  data = _fetchData();
                                });
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 32,
                              ),
                            ),
                            onTap: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => EditStudentScreen(
                                        id: studentProvider
                                            .studentItem[index].id!,
                                        lastName: studentProvider
                                            .studentItem[index].lastName,
                                        firstName: studentProvider
                                            .studentItem[index].firstName)),
                              );
                              setState(() {
                                data = _fetchData();
                              });
                            },
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        'List is empty',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                        ),
                      ),
                    );
            });
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
