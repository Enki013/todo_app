import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TodoItemAdapter());
  await Hive.openBox<TodoItem>('todoBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  const TodoListScreen({super.key});

  @override
  TodoListScreenState createState() => TodoListScreenState();
}

class TodoListScreenState extends State<TodoListScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  late List<TodoItem> _todoList;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _todoList = [];
    _loadTodoList();
  }

  void _loadTodoList() {
    final box = Hive.box<TodoItem>('todoBox');
    setState(() {
      _todoList = box.values.toList();
    });
  }

  void _saveTodoList() {
    final box = Hive.box<TodoItem>('todoBox');
    box.clear();
    for (int i = 0; i < _todoList.length; i++) {
      box.put(i, _todoList[i]);
    }
  }

  Widget _buildTodoItem(TodoItem todo) {
    String formattedDate = DateFormat('E, MMM d', 'en_US').format(todo.date);

    return Dismissible(
      key: Key(todo.date.toString() + todo.content),
      onDismissed: (direction) {
        _removeTodoItem(todo);
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        color: const Color(0xff6750a4),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: Row(
            children: [
              Checkbox(
                value: todo.isDone,
                onChanged: (value) {
                  setState(() {
                    todo.isDone = value!;
                    _saveTodoList();
                  });
                },
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      todo.content,
                      style: todo.isDone
                          ? const TextStyle(
                              decoration: TextDecoration.lineThrough)
                          : null,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formattedDate,
                      style: const TextStyle(fontStyle: FontStyle.italic),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  _editTodoItem(todo);
                },
              ),
            ],
          ),
        ),
      ),
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

  Future<void> _addTodoItem(String content) async {
    if (content.isNotEmpty) {
      setState(() {
        _todoList.add(
            TodoItem(content: content, date: _selectedDate ?? DateTime.now()));
        _selectedDate = null;
      });
      _saveTodoList();
      _textEditingController.clear();
    }
  }

  Future<void> _removeTodoItem(TodoItem todo) async {
    setState(() {
      _todoList.remove(todo);
    });
    _saveTodoList();
  }

  Future<void> _editTodoItem(TodoItem oldTodo) async {
    TextEditingController editTextController =
        TextEditingController(text: oldTodo.content);
    DateTime? newSelectedDate = oldTodo.date;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Notu Düzenle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: editTextController,
                decoration: const InputDecoration(labelText: 'Not İçeriği'),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      readOnly: true,
                      controller: TextEditingController(
                          text: DateFormat('yyyy-MM-dd').format(oldTodo.date)),
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
                _updateTodoItem(
                    oldTodo, editTextController.text.trim(), newSelectedDate);
                Navigator.of(context).pop();
              },
              child: const Text('Kaydet'),
            ),
          ],
        );
      },
    );
  }

  void _updateTodoItem(
      TodoItem oldTodo, String editedContent, DateTime? newDate) {
    setState(() {
      oldTodo.content = editedContent;
      oldTodo.date = newDate ?? DateTime.now();
    });
    _saveTodoList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task List'),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<TodoItem>('todoBox').listenable(),
        builder: (context, Box<TodoItem> box, _) {
          return Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount: _todoList.length,
                  itemBuilder: (context, index) {
                    return _buildTodoItem(_todoList[index]);
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _textEditingController,
                        decoration: InputDecoration(
                          labelText: 'Yeni Not Ekle',
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
          );
        },
      ),
    );
  }
}

@HiveType(typeId: 0)
class TodoItem extends HiveObject {
  @HiveField(0)
  late String content;

  @HiveField(1)
  late DateTime date;

  @HiveField(2)
  bool isDone;

  TodoItem({required this.content, required this.date, this.isDone = false});
}

class TodoItemAdapter extends TypeAdapter<TodoItem> {
  @override
  final int typeId = 0;

  @override
  TodoItem read(BinaryReader reader) {
    return TodoItem(
      content: reader.read(),
      date: DateTime.parse(reader.read()),
      isDone: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, TodoItem obj) {
    writer.write(obj.content);
    writer.write(obj.date.toIso8601String());
    writer.write(obj.isDone);
  }
}
