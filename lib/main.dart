
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
      title: 'Tarihli Notlar',
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
  late SharedPreferences _prefs;
  late List<String> _todoList;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _todoList = [];
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _loadTodoList();
  }

  void _loadTodoList() {
    setState(() {
      _todoList = _prefs.getStringList('todo_list') ?? [];
    });
  }

  void _saveTodoList() {
    _prefs.setStringList('todo_list', _todoList);

    for (int i = 0; i < _todoList.length; i++) {
      _prefs.setBool(
          'checkbox_status_$i', _prefs.getBool('checkbox_status_$i') ?? false);
    }
  }

  Widget buildTodoItem(String todo, int index) {
    return CheckboxListTile(
      title: Text(
        todo.split(':').last.trim(),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        todo.split(':').first.trim(),
        style: const TextStyle(fontStyle: FontStyle.italic),
      ),
      value: _prefs.getBool('checkbox_status_$index') ?? false,
      onChanged: (bool? value) {
        setState(() {
          _prefs.setBool('checkbox_status_$index', value ?? false);
          _saveTodoList();
        });
      },
      secondary: IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () {
          editTodoItem(todo);
        },
      ),
    );
  }

  Future<void> selectDate(BuildContext context) async {
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

  Future<void> addTodoItem(String todo) async {
    if (todo.isNotEmpty) {
      String selectedDateFormatted =
          DateFormat('yyyy-MM-dd').format(_selectedDate ?? DateTime.now());
      String todoItem = '$selectedDateFormatted: $todo';
      setState(() {
        _todoList.add(todoItem);
        _selectedDate = null;
      });
      _saveTodoList();
      _textEditingController.clear();
    }
  }

  Future<void> editTodoItem(String oldTodo) async {
    TextEditingController editTextController = TextEditingController();
    DateTime? newSelectedDate = _selectedDate;

    String oldTodoDate = oldTodo.split(':').first.trim();
    String oldTodoContent = oldTodo.split(':').last.trim();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Notu Düzenle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: editTextController..text = oldTodoContent,
                decoration: const InputDecoration(labelText: 'Not İçeriği'),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      readOnly: true,
                      controller: TextEditingController(text: oldTodoDate),
                      decoration: const InputDecoration(labelText: 'Tarih'),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: newSelectedDate ?? DateTime.now(),
                        firstDate: DateTime(2022),
                        lastDate: DateTime(2025),
                      );
                      if (pickedDate != null && pickedDate != newSelectedDate) {
                        setState(() {
                          newSelectedDate = pickedDate;
                        });
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                String editedContent = editTextController.text.trim();
                String newDateFormatted = DateFormat('yyyy-MM-dd')
                    .format(newSelectedDate ?? DateTime.now());
                String newTodo = '$newDateFormatted: $editedContent';
                _todoList.add(newTodo);
                _todoList.remove(oldTodo);
                _saveTodoList();
                setState(() {
                  _todoList = List.from(_todoList);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Kaydet'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarihli Notlar'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _todoList.length,
              itemBuilder: (context, index) {
                return buildTodoItem(_todoList[index], index);
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
                      labelText: 'Yeni Not Ekle',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          selectDate(context);
                        },
                        icon: const Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    addTodoItem(_textEditingController.text);
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
