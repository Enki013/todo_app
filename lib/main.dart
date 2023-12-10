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
  late SharedPreferences _prefs;
  late List<String> _todoList;
  late List<bool> _checkedStateList;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _todoList = [];
    _checkedStateList = [];
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _loadTodoList();
  }

  void _loadTodoList() {
    setState(() {
      _todoList = _prefs.getStringList('todo_list') ?? [];
      _checkedStateList = _todoList.map((_) => false).toList();
      for (int i = 0; i < _todoList.length; i++) {
        _checkedStateList[i] = _prefs.getBool('checkbox_status_$i') ?? false;
      }
    });
  }

  void _saveTodoList() {
    _prefs.setStringList('todo_list', _todoList);
    for (int i = 0; i < _checkedStateList.length; i++) {
      _prefs.setBool('checkbox_status_$i', _checkedStateList[i]);
    }
  }

  Widget _buildTodoItem(String todo, int index) {
    String formattedDate = DateFormat('E, MMM d', 'en_US')
        .format(DateTime.parse(todo.split(':').first.trim()));

    // String formattedDate = DateFormat.E()
    //     .add_MMMd()
    //     .format(DateTime.parse(todo.split(':').first.trim()));
    bool isChecked = _checkedStateList[index];
    TextStyle textStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontStyle: isChecked ? FontStyle.italic : FontStyle.normal,
      decoration: isChecked ? TextDecoration.lineThrough : TextDecoration.none,
    );

    return Dismissible(
        key: Key(todo),
        onDismissed: (direction) {
          setState(() {
            _todoList.removeAt(index);
            _checkedStateList.removeAt(index);
            _saveTodoList();
          });
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
            child: ListTile(
              leading: Checkbox(
                value: _checkedStateList[index],
                onChanged: (bool? value) {
                  setState(() {
                    _checkedStateList[index] = value ?? false;
                    _saveTodoList();
                  });
                },
              ),
              title: Text(
                todo.split(':').last.trim(),
                // style: const TextStyle(fontWeight: FontWeight.bold),
                style: textStyle,

                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Container(
                padding:
                    const EdgeInsets.only(top: 8.0), // Alt boşluk eklemek için

                child: Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 16), // Tarih ikonu eklendi
                    const SizedBox(width: 4), // Aralık için boşluk eklendi
                    Expanded(
                      child: Text(
                        formattedDate,
                        style: const TextStyle(fontStyle: FontStyle.italic),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      _editTodoItem(todo, index);
                    },
                  ),

                  // Checkbox(
                  //   value: _checkedStateList[index],
                  //   onChanged: (bool? value) {
                  //     setState(() {
                  //       _checkedStateList[index] = value ?? false;
                  //       _saveTodoList();
                  //     });
                  //   },
                  // ),//checkbox yeri değiştirildi en sola
                ],
              ),
            ),
          ),
        ));
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
        _todoList.add(todoItem);
        _checkedStateList.add(false);
        _selectedDate = null;
      });
      _saveTodoList();
      _textEditingController.clear();
    }
  }

  Future<void> _editTodoItem(String oldTodo, int index) async {
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
                _todoList[index] = newTodo;
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
        title: const Text('Task List'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _todoList.length,
              itemBuilder: (context, index) {
                return _buildTodoItem(_todoList[index], index);
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
                      //border: const OutlineInputBorder(),
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
