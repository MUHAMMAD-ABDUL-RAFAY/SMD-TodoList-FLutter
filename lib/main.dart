import 'package:flutter/material.dart';
import 'dart:math';
import 'package:collection/collection.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  bool taskStatus = false;
  final taskController = TextEditingController();
  List<Map<String, Map<String, bool>>> tasks = [
    {
      "Id6435": {"Assignment by Muhammad Rafay(20K-0180)": false},
    },
    {
      "Id1234": {"Take SMD Class At 3": false},
    },
    {
      "Id1235": {"Submitted Assignment2 SMD": true},
    },
    {
      "Id1236": {"Prepare for Quiz": false},
    },
  ];
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
        body: Column(
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
                          tasks.map((task) => task.keys.first).toList();
                      int randomNumber = Random().nextInt(9000) + 1000;
                      String randomId = "Id$randomNumber";
                      while (existingIds.contains(randomId)) {
                        randomNumber = Random().nextInt(9000) + 1000;
                        randomId = "Id$randomNumber";
                      }
                      taskController.text.isNotEmpty
                          ? tasks.add({
                              randomId: {taskController.text: false}
                            })
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
            tasks.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 30),
                    child: Text("No tasks to show!",
                        style: TextStyle(fontSize: 16, color: Colors.grey)),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Column(
                      children: tasks
                          .map((task) => ListTile(
                                style: ListTileStyle.list,
                                title: Text(
                                  task.values.first.keys.first,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    decoration: task.values.first.values.first
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Checkbox(
                                        value: task.values.first.values.first,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            task[task.entries.first.key]![task
                                                .values
                                                .first
                                                .keys
                                                .first] = value!;
                                          });
                                        }),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () {
                                        setState(() {
                                          tasks = tasks
                                              .whereNot((t) =>
                                                  t.keys.first ==
                                                  task.entries.first.key)
                                              .toList();
                                        });
                                      },
                                    )
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                  )
          ],
        ));
  }
}
