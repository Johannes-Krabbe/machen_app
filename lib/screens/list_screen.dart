import 'package:flutter/material.dart';
import 'package:machen_app/components/task_tile.dart';

class Task {
  final int id;
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
  List tasks = [];
  final TextEditingController _controller = TextEditingController();

  toggleDone(int id) {
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

  addToDo() {
    setState(() {
      tasks.add(
          Task(id: tasks.length, title: _controller.value.text, isDone: false));
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
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
          Container(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black12
                : Colors.white12,
            height: 70,
            child: Row(
              children: [
                const SizedBox(width: 15),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                        hintText: "Create new task", border: InputBorder.none),
                    controller: _controller,
                  ),
                ),
                const SizedBox(width: 15),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => addToDo(),
                ),
                const SizedBox(width: 15),
              ],
            ),
          ),
          Container(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black12
                  : Colors.white12,
              height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
