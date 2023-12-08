// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:intl/intl.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Task List',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: const TodoListScreen(),
//     );
//   }
// }

// class TodoListScreen extends StatefulWidget {
//   const TodoListScreen({Key? key}) : super(key: key);

//   @override
//   _TodoListScreenState createState() => _TodoListScreenState();
// }

// class _TodoListScreenState extends State<TodoListScreen> {
//   final TextEditingController _textEditingController = TextEditingController();
//   SharedPreferences? _prefs;
//   late Map<String, bool> _todoList;
//   DateTime? _selectedDate;

//   @override
//   void initState() {
//     super.initState();
//     _todoList = {};
//     _loadTodoList();
//   }

//   Future<void> _loadTodoList() async {
//     _prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _todoList = {
//         for (var key
//             in _prefs!.getKeys().where((key) => key.startsWith('todo_')))
//           key.substring(5): _prefs!.getBool(key) ?? false,
//       };
//     });
//   }

//   Future<void> _saveTodoList() async {
//     _todoList.forEach((key, value) async {
//       await _prefs!.setBool('todo_$key', value);
//     });
//   }

//   Widget _buildTodoItem(String todo, bool isCompleted) {
//     String todoDate = todo.split(':').first.trim(); // Notun tarihi

//     return ListTile(
//       title: Text(todo.split(':').last.trim()), // Notun kendisi
//       subtitle: Text(todoDate), // Tarih alt metni
//       trailing: const Icon(Icons.today), // Ajanda simgesi
//       leading: Checkbox(
//         value: isCompleted,
//         onChanged: (bool? value) {
//           setState(() {
//             _todoList[todo] = value ?? false;
//           });
//           _saveTodoList();
//         },
//       ),
//       onTap: () {
//         // ListTile'a tıklama işlemleri
//         //not edit yapilacak
//       },
//     );
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate ?? DateTime.now(),
//       firstDate: DateTime(2022),
//       lastDate: DateTime(2025),
//     );
//     if (pickedDate != null && pickedDate != _selectedDate) {
//       setState(() {
//         _selectedDate = pickedDate;
//       });
//     }
//   }

//   Future<void> _addTodoItem(String todo) async {
//     if (todo.isNotEmpty) {
//       String selectedDateFormatted =
//           DateFormat('yyyy-MM-dd').format(_selectedDate ?? DateTime.now());
//       String todoItem = '$selectedDateFormatted: $todo';
//       setState(() {
//         _todoList[todoItem] = false;
//         _selectedDate = null; // Seçili tarihi sıfırlama
//       });
//       await _saveTodoList();
//       _textEditingController.clear();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Task List'),
//       ),
//       body: Column(
//         children: <Widget>[
//           Expanded(
//             child: ListView.builder(
//               itemCount: _todoList.length,
//               itemBuilder: (context, index) {
//                 String todo = _todoList.keys.elementAt(index);
//                 bool isCompleted = _todoList.values.elementAt(index);
//                 return Dismissible(
//                     key: Key(todo),
//                     onDismissed: (direction) {
//                       setState(() {
//                         _todoList.remove(todo);
//                         _saveTodoList();
//                       });
//                     },
//                     background: Container(
//                       alignment: Alignment.centerRight,
//                       margin: const EdgeInsets.symmetric(
//                           vertical: 4.0, horizontal: 8.0),
//                       decoration: BoxDecoration(
//                         color: const Color(0xff6750a4),
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                       padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                       child: const Icon(
//                         Icons.delete,
//                         color: Colors.white,
//                       ),
//                     ),
//                     child: Container(
//                       margin: const EdgeInsets.symmetric(
//                           vertical: 4.0, horizontal: 8.0),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(8.0),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.5),
//                             spreadRadius: 2,
//                             blurRadius: 5,
//                             offset: const Offset(0, 3),
//                           ),
//                         ],
//                       ),
//                       child: ListTile(
//                         title: Text(todo.split(':').last.trim()),
//                         subtitle: Text(todo.split(':').first.trim()),
//                         trailing: const Icon(Icons.today),
//                         leading: Checkbox(
//                           value: isCompleted,
//                           onChanged: (bool? value) {
//                             setState(() {
//                               _todoList[todo] = value ?? false;
//                             });
//                             _saveTodoList();
//                           },
//                         ),
//                         onTap: () {
//                           // ListTile'a tıklama işlemleri
//                           //not edit yapilacak
//                         },
//                       ),
//                     ));
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: <Widget>[
//                 Expanded(
//                   child: TextField(
//                     controller: _textEditingController,
//                     decoration: InputDecoration(
//                       labelText: 'Add Task',
//                       border: const OutlineInputBorder(),
//                       suffixIcon: IconButton(
//                         onPressed: () {
//                           _selectDate(context);
//                         },
//                         icon: const Icon(Icons.calendar_today),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8.0),
//                 ElevatedButton(
//                   onPressed: () {
//                     _addTodoItem(_textEditingController.text);
//                   },
//                   child: const Text('Ekle'),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:intl/intl.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Tarihli Notlar',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: const TodoListScreen(),
//     );
//   }
// }

// class TodoListScreen extends StatefulWidget {
//   const TodoListScreen({Key? key}) : super(key: key);

//   @override
//   _TodoListScreenState createState() => _TodoListScreenState();
// }

// class _TodoListScreenState extends State<TodoListScreen> {
//   final TextEditingController _textEditingController = TextEditingController();
//   SharedPreferences? _prefs;
//   late Map<String, bool> _todoList;
//   DateTime? _selectedDate;

//   @override
//   void initState() {
//     super.initState();
//     _todoList = {};
//     _loadTodoList();
//   }

//   Future<void> _loadTodoList() async {
//     _prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _todoList = {
//         for (var key
//             in _prefs!.getKeys().where((key) => key.startsWith('todo_')))
//           key.substring(5): _prefs!.getBool(key) ?? false,
//       };
//     });
//   }

//   Future<void> _saveTodoList() async {
//     _todoList.forEach((key, value) async {
//       await _prefs!.setBool('todo_$key', value);
//     });
//   }

//   Widget _buildTodoItem(String todo) {
//     String todoDate = todo.split(':').first.trim(); // Notun tarihi

//     return Dismissible(
//       key: Key(todo),
//       onDismissed: (direction) {
//         setState(() {
//           _todoList.remove(todo);
//           _saveTodoList();
//         });
//       },
//       background: Container(
//         alignment: Alignment.centerRight,
//         padding: const EdgeInsets.only(right: 20.0),
//         color: const Color(0xff6750a4),
//         child: const Icon(
//           Icons.delete,
//           color: Colors.white,
//         ),
//       ),
//       child: Card(
//         elevation: 3,
//         margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12.0),
//         ),
//         child: ListTile(
//           title: Text(
//             todo.split(':').last.trim(),
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//           subtitle: Text(
//             todo.split(':').first.trim(),
//             style: const TextStyle(fontStyle: FontStyle.italic),
//           ),
//           trailing: const Icon(Icons.today),
//           leading: Checkbox(
//             value: _todoList[todo],
//             onChanged: (bool? value) {
//               setState(() {
//                 _todoList[todo] = value ?? false;
//               });
//               _saveTodoList();
//             },
//           ),
//           onTap: () {
//             _editTodoItem(todo);
//           },
//         ),
//       ),
//     );
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate ?? DateTime.now(),
//       firstDate: DateTime(2022),
//       lastDate: DateTime(2025),
//     );
//     if (pickedDate != null && pickedDate != _selectedDate) {
//       setState(() {
//         _selectedDate = pickedDate;
//       });
//     }
//   }

//   Future<void> _addTodoItem(String todo) async {
//     if (todo.isNotEmpty) {
//       String selectedDateFormatted =
//           DateFormat('yyyy-MM-dd').format(_selectedDate ?? DateTime.now());
//       String todoItem = '$selectedDateFormatted: $todo';
//       setState(() {
//         _todoList[todoItem] = false;
//         _selectedDate = null;
//       });
//       await _saveTodoList();
//       _textEditingController.clear();
//     }
//   }

//   Future<void> _editTodoItem(String oldTodo) async {
//     TextEditingController editTextController = TextEditingController();
//     DateTime? newSelectedDate = _selectedDate;

//     String oldTodoDate = oldTodo.split(':').first.trim();
//     String oldTodoContent = oldTodo.split(':').last.trim();

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Notu Düzenle'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: editTextController..text = oldTodoContent,
//                 decoration: const InputDecoration(labelText: 'Not İçeriği'),
//               ),
//               const SizedBox(height: 10),
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       readOnly: true,
//                       controller: TextEditingController(text: oldTodoDate),
//                       decoration: const InputDecoration(labelText: 'Tarih'),
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.calendar_today),
//                     onPressed: () async {
//                       DateTime? pickedDate = await showDatePicker(
//                         context: context,
//                         initialDate: newSelectedDate ?? DateTime.now(),
//                         firstDate: DateTime(2022),
//                         lastDate: DateTime(2025),
//                       );
//                       if (pickedDate != null && pickedDate != newSelectedDate) {
//                         setState(() {
//                           newSelectedDate = pickedDate;
//                         });
//                       }
//                     },
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('İptal'),
//             ),
//             TextButton(
//               onPressed: () {
//                 String editedContent = editTextController.text.trim();
//                 String newDateFormatted = DateFormat('yyyy-MM-dd')
//                     .format(newSelectedDate ?? DateTime.now());
//                 String newTodo = '$newDateFormatted: $editedContent';
//                 _todoList[newTodo] = _todoList.remove(oldTodo) ?? false;
//                 _saveTodoList();
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Kaydet'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Tarihli Notlar'),
//       ),
//       body: Column(
//         children: <Widget>[
//           Expanded(
//             child: ListView.builder(
//               itemCount: _todoList.length,
//               itemBuilder: (context, index) {
//                 String todo = _todoList.keys.elementAt(index);
//                 return _buildTodoItem(todo);
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: <Widget>[
//                 Expanded(
//                   child: TextField(
//                     controller: _textEditingController,
//                     decoration: InputDecoration(
//                       labelText: 'Yeni Not Ekle',
//                       border: const OutlineInputBorder(),
//                       suffixIcon: IconButton(
//                         onPressed: () {
//                           _selectDate(context);
//                         },
//                         icon: const Icon(Icons.calendar_today),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8.0),
//                 ElevatedButton(
//                   onPressed: () {
//                     _addTodoItem(_textEditingController.text);
//                   },
//                   child: const Text('Ekle'),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:intl/intl.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Tarihli Notlar',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: const TodoListScreen(),
//     );
//   }
// }

// class TodoListScreen extends StatefulWidget {
//   const TodoListScreen({Key? key}) : super(key: key);

//   @override
//   _TodoListScreenState createState() => _TodoListScreenState();
// }

// class _TodoListScreenState extends State<TodoListScreen> {
//   final TextEditingController _textEditingController = TextEditingController();
//   late SharedPreferences _prefs;
//   late List<String> _todoList;
//   DateTime? _selectedDate;

//   @override
//   void initState() {
//     super.initState();
//     _todoList = [];
//     _initPrefs();
//   }

//   Future<void> _initPrefs() async {
//     _prefs = await SharedPreferences.getInstance();
//     _loadTodoList();
//   }

//   void _loadTodoList() {
//     setState(() {
//       _todoList = _prefs.getStringList('todo_list') ?? [];
//     });
//   }

//   void _saveTodoList() {
//     _prefs.setStringList('todo_list', _todoList);
//   }

//   Widget _buildTodoItem(String todo) {

//     return Dismissible(
//       key: Key(todo),
//       onDismissed: (direction) {
//         setState(() {
//           _todoList.remove(todo);
//           _saveTodoList();
//         });
//       },
//       background: Container(
//         alignment: Alignment.centerRight,
//         padding: const EdgeInsets.only(right: 20.0),
//         color: const Color(0xff6750a4),
//         child: const Icon(
//           Icons.delete,
//           color: Colors.white,
//         ),
//       ),
//       child: Card(
//         elevation: 3,
//         margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12.0),
//         ),
//         child: ListTile(
//           title: Text(
//             todo.split(':').last.trim(),
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//           subtitle: Text(
//             todo.split(':').first.trim(),
//             style: const TextStyle(fontStyle: FontStyle.italic),
//           ),
//           trailing: const Icon(Icons.today),
//           leading: Checkbox(
//             value: _todoList.contains(todo),
//             onChanged: (bool? value) {
//               setState(() {
//                 if (value ?? false) {
//                   _todoList.add(todo);
//                 } else {
//                   _todoList.remove(todo);
//                 }
//               });
//               _saveTodoList();
//             },
//           ),
//           onTap: () {
//             _editTodoItem(todo);
//           },
//         ),
//       ),
//     );
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate ?? DateTime.now(),
//       firstDate: DateTime(2022),
//       lastDate: DateTime(2025),
//     );
//     if (pickedDate != null && pickedDate != _selectedDate) {
//       setState(() {
//         _selectedDate = pickedDate;
//       });
//     }
//   }

//   Future<void> _addTodoItem(String todo) async {
//     if (todo.isNotEmpty) {
//       String selectedDateFormatted =
//           DateFormat('yyyy-MM-dd').format(_selectedDate ?? DateTime.now());
//       String todoItem = '$selectedDateFormatted: $todo';
//       setState(() {
//         _todoList.add(todoItem);
//         _selectedDate = null;
//       });
//       _saveTodoList();
//       _textEditingController.clear();
//     }
//   }

//   Future<void> _editTodoItem(String oldTodo) async {
//     TextEditingController editTextController = TextEditingController();
//     DateTime? newSelectedDate = _selectedDate;

//     String oldTodoDate = oldTodo.split(':').first.trim();
//     String oldTodoContent = oldTodo.split(':').last.trim();

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Notu Düzenle'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: editTextController..text = oldTodoContent,
//                 decoration: const InputDecoration(labelText: 'Not İçeriği'),
//               ),
//               const SizedBox(height: 10),
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       readOnly: true,
//                       controller: TextEditingController(text: oldTodoDate),
//                       decoration: const InputDecoration(labelText: 'Tarih'),
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.calendar_today),
//                     onPressed: () async {
//                       DateTime? pickedDate = await showDatePicker(
//                         context: context,
//                         initialDate: newSelectedDate ?? DateTime.now(),
//                         firstDate: DateTime(2022),
//                         lastDate: DateTime(2025),
//                       );
//                       if (pickedDate != null && pickedDate != newSelectedDate) {
//                         setState(() {
//                           newSelectedDate = pickedDate;
//                         });
//                       }
//                     },
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('İptal'),
//             ),
//             TextButton(
//               onPressed: () {
//                 String editedContent = editTextController.text.trim();
//                 String newDateFormatted = DateFormat('yyyy-MM-dd')
//                     .format(newSelectedDate ?? DateTime.now());
//                 String newTodo = '$newDateFormatted: $editedContent';
//                 _todoList.add(newTodo);
//                 _todoList.remove(oldTodo);
//                 _saveTodoList();
//                 setState(() {
//                   //refresh list
//                   _todoList = List.from(_todoList);
//                 });
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Kaydet'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Tarihli Notlar'),
//       ),
//       body: Column(
//         children: <Widget>[
//           Expanded(
//             child: ListView.builder(
//               itemCount: _todoList.length,
//               itemBuilder: (context, index) {
//                 return _buildTodoItem(_todoList[index]);
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: <Widget>[
//                 Expanded(
//                   child: TextField(
//                     controller: _textEditingController,
//                     decoration: InputDecoration(
//                       labelText: 'Yeni Not Ekle',
//                       border: const OutlineInputBorder(),
//                       suffixIcon: IconButton(
//                         onPressed: () {
//                           _selectDate(context);
//                         },
//                         icon: const Icon(Icons.calendar_today),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8.0),
//                 ElevatedButton(
//                   onPressed: () {
//                     _addTodoItem(_textEditingController.text);
//                   },
//                   child: const Text('Ekle'),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }