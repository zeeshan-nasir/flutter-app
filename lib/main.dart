import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Todos extends ChangeNotifier {
  final List<Map> todos = [];

  void addTodo(Map todo) {
    todos.add(todo);
    notifyListeners();
  }

  void removeTodo(todo) {}
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => ChangeNotifierProvider(
              create: (context) => Todos(),
              child: const HomeScreen(),
            ),
        '/addTasks': (context) => const AddTasks(),
        '/completedTasks': (context) => const Placeholder(),
        '/settings': (context) => const Placeholder(),
      },
    );
  }
}

class Todo {
  String title;
  String date;
  String priority;
  bool isDone;

  Todo(this.title, this.date, this.priority, {this.isDone = false});
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    List<Todo> todos = [
      Todo('Get Milk', '22/03/2023', 'High'),
      Todo('Get Honey', '22/03/2023', 'High'),
      Todo('Get Eggs', '22/03/2023', 'High')
    ];

    return Scaffold(
      appBar: AppBar(
          leading: const Icon(Icons.bug_report),
          title: const Text("Task Manager"),
          actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.history),
                tooltip: 'Completed Tasks',
                onPressed: () =>
                    Navigator.pushNamed(context, '/completedTasks')),
            IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'Settings',
              onPressed: () => Navigator.pushNamed(context, '/settings'),
            ),
          ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/addTasks'),
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(todos[index].title),
              trailing: Checkbox(
                checkColor: Colors.black,
                value: todos[index].isDone,
                onChanged: (bool? value) {
                  setState(() {
                    todos[index].isDone = value!;
                  });
                },
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditTask(todo: todos[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class AddTasks extends StatefulWidget {
  const AddTasks({super.key});

  @override
  State<AddTasks> createState() => _AddTasksState();
}

class _AddTasksState extends State<AddTasks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.chevron_left),
            iconSize: 30,
            onPressed: () => Navigator.pushNamed(context, '/'),
          ),
          title: const Text('Add Task')),
      body: const TaskForm(),
    );
  }
}

class TaskForm extends StatefulWidget {
  const TaskForm({super.key});

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var priorityTypes = ['High', 'Medium', 'Low'];
    // var _category;

    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Title',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              autofocus: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
                decoration: InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                autofocus: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a date';
                  }
                  return null;
                }),
            const SizedBox(height: 15),
            DropdownButtonFormField(
              items: priorityTypes.map((String type) {
                return DropdownMenuItem(
                    value: type,
                    child: Row(
                      children: <Widget>[
                        Text(type),
                      ],
                    ));
              }).toList(),
              onChanged: (newValue) {
                // do other stuff with _category
                setState(() => print(newValue));
              },
              // value: _category,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 117, 117, 117), width: 1),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 8, 119, 14), width: 1),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 209, 12, 12), width: 1),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: 'Priority'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a priority level';
                }
                return null;
              },
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25))),
                  onPressed: () => {
                        if (!_formKey.currentState!.validate())
                          {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Fill fields correctly!')),
                            )
                          }
                      },
                  child: const Text(
                    'Add',
                    style: TextStyle(fontSize: 20),
                  )),
            )
          ],
        ),
      ),
    );
  }
}

class EditTask extends StatefulWidget {
  const EditTask({super.key, required this.todo});
  final Todo todo;

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var priorityTypes = ['High', 'Medium', 'Low'];
    // var _category;

    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Title',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              autofocus: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
                decoration: InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                autofocus: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a date';
                  }
                  return null;
                }),
            const SizedBox(height: 15),
            DropdownButtonFormField(
              items: priorityTypes.map((String type) {
                return DropdownMenuItem(
                    value: type,
                    child: Row(
                      children: <Widget>[
                        Text(type),
                      ],
                    ));
              }).toList(),
              onChanged: (newValue) {
                // do other stuff with _category
                setState(() => print(newValue));
              },
              // value: _category,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 117, 117, 117), width: 1),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 8, 119, 14), width: 1),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 209, 12, 12), width: 1),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: 'Priority'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a priority level';
                }
                return null;
              },
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25))),
                  onPressed: () => {
                        if (!_formKey.currentState!.validate())
                          {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Fill fields correctly!')),
                            )
                          }
                      },
                  child: const Text(
                    'Add',
                    style: TextStyle(fontSize: 20),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
