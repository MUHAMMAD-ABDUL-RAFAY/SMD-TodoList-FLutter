import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:collection/collection.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo List -> Muhammad Rafay(20K-0180)',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final taskController = TextEditingController();
  Future<Directory?>? _appDocumentsDirectory;

  void _requestAppDocumentsDirectory() async {
    setState(() {
      _appDocumentsDirectory = getApplicationDocumentsDirectory();
    });
  }

  List<Task> tasks = [];

  Future<void> _loadTasks() async {
    final directory = await _appDocumentsDirectory;
    if (_appDocumentsDirectory == null) {
      print('Error: App documents directory not found!');
      return;
    }
    final file = File('${directory!.path}/tasks.json');
    // print(file);
    if (!await file.exists()) {
      print('Error: Tasks file not found!');
      return;
      // No tasks file, return empty list
    }
    var content = await file.readAsString();
    print(content);
    try {
      final List<dynamic> taskJson = jsonDecode(content);
      tasks = taskJson.map((task) {
        return Task(
            id: task['id'],
            name: task['name'],
            isCompleted: task['isCompleted']);
      }).toList();
    } catch (e) {
      print(e);
    }
    return;
  }

  Future<void> _deleteTask(Task taskToBeDeleted) async {
    final directory = await _appDocumentsDirectory;
    if (_appDocumentsDirectory == null) {
      print('Error: App documents directory not found!');
      return;
    }
    final file = File('${directory!.path}/tasks.json');
    // print(file);
    if (!await file.exists()) {
      print('Error: Tasks file not found!');
      return;
      // No tasks file, return empty list
    }
    var content = await file.readAsString();
    print(content);
    try {
      setState(() {
        tasks = tasks.whereNot((t) => t.id == taskToBeDeleted.id).toList();
      });
      await file.writeAsString(tasks.toString());
      print('Tasks saved to file!');
    } catch (e) {
      print(e);
    }
    return;
  }

  Future<void> _deleteFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file =
          File('${directory.path}/tasks.json'); // Adjust the path if needed
      print(file);
      if (await file.exists()) {
        await file.delete();
        print('File deleted successfully!');
      } else {
        print('File does not exist.');
      }
    } catch (error) {
      print('Error deleting file: $error');
    }
  }

  Future<void> _updateTask(Task updatedTask, bool statusValue) async {
    try {
      // Get the application documents directory
      final directory = await getApplicationDocumentsDirectory();

      // Create a file path for the task file
      print(directory.path);
      final file = File('${directory.path}/tasks.json');
      print(updatedTask);
      setState(() {
        tasks = tasks.map((task) {
          if (task.id == updatedTask.id) {
            task.isCompleted = statusValue;
          }
          return task;
        }).toList();
      });
      await file.writeAsString(tasks.toString());
      print('Tasks saved to file!');
    } catch (error) {
      print('Error writing tasks to file: $error');
      // Handle errors gracefully
    }
  }

  Future<void> _writeToFile(Task task) async {
    try {
      // Get the application documents directory
      final directory = await getApplicationDocumentsDirectory();

      // Create a file path for the task file
      print(directory.path);
      final file = File('${directory.path}/tasks.json');
      print(task);
      setState(() {
        tasks.add(task);
      });
      await file.writeAsString(tasks.toString());
      print('Tasks saved to file!');
    } catch (error) {
      print('Error writing tasks to file: $error');
      // Handle errors gracefully
    }
  }

  @override
  void initState() {
    print("initState");
    super.initState();
    _requestAppDocumentsDirectory();
  }

  @override
  void dispose() {
    taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              'Todo List',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
          ),
          foregroundColor: Colors.white,
          backgroundColor: Colors.deepPurple,
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: TextField(
                controller: taskController,
                decoration: const InputDecoration(
                  labelText: 'Enter a task',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: const Color(0xFFFFFFFF),
                  ),
                  onPressed: () {
                    setState(() {
                      List<String> existingIds =
                          tasks.map((task) => task.id).toList();
                      int randomNumber = Random().nextInt(9000) + 1000;
                      String randomId = "Id$randomNumber";
                      while (existingIds.contains(randomId)) {
                        randomNumber = Random().nextInt(9000) + 1000;
                        randomId = "Id$randomNumber";
                      }
                      taskController.text.isNotEmpty
                          ? _writeToFile(Task(
                              id: randomId,
                              name: taskController.text,
                              isCompleted: false))
                          : null;
                      taskController.text = "";
                    });
                  },
                  child: const Text(
                    'Add New Task',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
            ),
            const Text("Tasks",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                )),
            FutureBuilder(
                future: _loadTasks(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  return tasks.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 30),
                          child: Text("No tasks to show!",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey)),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          child: Column(
                            children: tasks
                                .map((task) => ListTile(
                                      style: ListTileStyle.list,
                                      title: Text(
                                        task.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          decoration: task.isCompleted
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none,
                                        ),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Checkbox(
                                              value: task.isCompleted,
                                              onChanged: (bool? value) {
                                                _updateTask(task, value!);
                                                // setState(() {
                                                //   task.isCompleted = value!;
                                                // });
                                              }),
                                          IconButton(
                                            icon: const Icon(Icons.delete,
                                                color: Colors.red),
                                            onPressed: () {
                                              _deleteTask(task);
                                            },
                                          )
                                        ],
                                      ),
                                    ))
                                .toList(),
                          ),
                        );
                }),
          ],
        )));
  }
}

class Task {
  final String id;
  final String name;
  bool isCompleted;

  Task({required this.id, required this.name, required this.isCompleted});

  @override
  String toString() =>
      '{"id": "$id", "name": "$name", "isCompleted": $isCompleted}';
}
