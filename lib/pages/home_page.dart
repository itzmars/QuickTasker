import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quick_tasker/models/task.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  late double _heightDevice;
  String? newTaskContent;
  Box? _box;

  _HomePageState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _heightDevice = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: _heightDevice * 0.15,
        title: const Text(
          'QuickTasker',
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: _taskView(),
      floatingActionButton: _addTaskButton(),
    );
  }

  void displayTaskPoppup() {
    showDialog(
        context: context,
        builder: (BuildContext _context) {
          return AlertDialog(
            title: const Text('Add New Task !'),
            content: TextField(
              onSubmitted: (_) {
                if (newTaskContent != null) {
                  var task = Task(
                      content: newTaskContent!,
                      timeStamp: DateTime.now().toString(),
                      done: false);
                  _box!.add(task.toMap());
                  setState(() {
                    newTaskContent = null;
                    Navigator.pop(context);
                  });
                }
              },
              onChanged: (value) {
                newTaskContent = value;
              },
            ),
          );
        });
  }

  Widget _taskView() {
    return FutureBuilder(
        // Hive.openBox('tasks')
        future: Hive.openBox('tasks'),
        builder: (BuildContext _context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            _box = snapshot.data;
            return _taskList();
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _taskList() {
    List tasks = _box!.values.toList();
    return ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (BuildContext _context, int index) {
          var task = Task.froMap(tasks[index]);
          return ListTile(
            title: Text(
              task.content,
              style: TextStyle(
                  decoration: task.done ? TextDecoration.lineThrough : null),
            ),
            subtitle: Text(
              task.timeStamp.toString(),
            ),
            trailing: Icon(
              task.done
                  ? Icons.check_box_outlined
                  : Icons.check_box_outline_blank_outlined,
              color: Colors.blue,
            ),
            onTap: () => {
              setState(() {
                task.done = !task.done;
              })
            },
          );
        });
  }

  Widget _addTaskButton() {
    return FloatingActionButton(
      onPressed: () {
        displayTaskPoppup();
      },
      child: const Icon(Icons.add),
    );
  }
}
