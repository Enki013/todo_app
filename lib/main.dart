import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({Key? key}) : super(key: key);

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  SharedPreferences? _prefs;
  late Map<String, bool> _todoList;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _todoList = {};
    _loadTodoList();
  }

  Future<void> _loadTodoList() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _todoList = {
        for (var key
            in _prefs!.getKeys().where((key) => key.startsWith('todo_')))
          key.substring(5): _prefs!.getBool(key) ?? false,
      };
    });
  }

  Future<void> _saveTodoList() async {
    _todoList.forEach((key, value) async {
      await _prefs!.setBool('todo_$key', value);
    });
  }

  Widget _buildTodoItem(String todo, bool isCompleted) {
    String todoDate = todo.split(':').first.trim(); // Notun tarihi

    return ListTile(
      title: Text(todo.split(':').last.trim()), // Notun kendisi
      subtitle: Text(todoDate), // Tarih alt metni
      trailing: const Icon(Icons.today), // Ajanda simgesi
      leading: Checkbox(
        value: isCompleted,
        onChanged: (bool? value) {
          setState(() {
            _todoList[todo] = value ?? false;
          });
          _saveTodoList();
        },
      ),
      onTap: () {
        // ListTile'a tıklama işlemleri
        //not edit yapilacak
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2025),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _addTodoItem(String todo) async {
    if (todo.isNotEmpty) {
      String selectedDateFormatted =
          DateFormat('yyyy-MM-dd').format(_selectedDate ?? DateTime.now());
      String todoItem = '$selectedDateFormatted: $todo';
      setState(() {
        _todoList[todoItem] = false;
        _selectedDate = null; // Seçili tarihi sıfırlama
      });
      await _saveTodoList();
      _textEditingController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task List'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _todoList.length,
              itemBuilder: (context, index) {
                String todo = _todoList.keys.elementAt(index);
                bool isCompleted = _todoList.values.elementAt(index);
                return ListTile(
                  title: Text(todo.split(':').last.trim()),
                  subtitle: Text(todo.split(':').first.trim()),
                  trailing: const Icon(Icons.today),
                  leading: Checkbox(
                    value: isCompleted,
                    onChanged: (bool? value) {
                      setState(() {
                        _todoList[todo] = value ?? false;
                      });
                      _saveTodoList();
                    },
                  ),
                  onTap: () {
                    // ListTile'a tıklama işlemleri
                    //not edit yapilacak
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      labelText: 'Add Task',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          _selectDate(context);
                        },
                        icon: const Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    _addTodoItem(_textEditingController.text);
                  },
                  child: const Text('Ekle'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
