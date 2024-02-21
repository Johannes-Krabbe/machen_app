import 'package:flutter/material.dart';
import 'package:machen_app/components/task_tile.dart';

class Task {
  final String id;
  final String title;
  final bool isDone;

  Task({
    required this.id,
    required this.title,
    required this.isDone,
  });
}

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  var tasks = <Task>[Task(id: "1", title: "Task", isDone: false)];

  toggleDone(String id) {
    setState(() {
      tasks = tasks.map((task) {
        if (task.id == id) {
          return Task(
            id: task.id,
            title: task.title,
            isDone: !task.isDone,
          );
        }
        return task;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 100,
            child: ListView(
              children: [
                ...tasks
                    .map((e) => TaskTile(
                          title: e.title,
                          isDone: e.isDone,
                          onChanged: (value) => toggleDone(e.id),
                        ))
                    .toList()
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Container(
              color: Colors.grey,
              height: 61,
              child: const Row(
                children: [
                  SizedBox(width: 15),
                  Expanded(
                    child: Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                            hintText: "Create new task",
                            hintStyle: TextStyle(color: Colors.white),
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 15),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
