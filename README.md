# Simple To Do App

Simple to do app with fluter
Flutter kullanarak basit bir görev listesi uygulamasını oluşturur ve yönetir.
Genel mantığı, görevlerin eklenmesi, düzenlenmesi, silinmesi ve onaylanması üzerine kurulmuştur. Kullanıcı arayüzü, görevlerin listesi ve ekleme/düzenleme işlevleri için gerekli alanları sağlar.
- add tasks by dates
- firebase integration(soon)
- attachment files(soon)
- ✨Magic ✨

## Features

- The application stores the task list and the checkbox status (completed or not) of each task using SharedPreferences.
- The TodoListScreen class contains the screen where tasks are listed. This screen includes a ListView displaying the tasks. Each task has options for editing, deleting, and a checkbox for its completion status.
- To add a new task, users can input text and select a date.
- Users can access an editing screen with an AlertDialog to make changes to tasks. This screen allows users to edit the content and date of a task.
- Swipe-to-delete functionality for tasks is implemented using the Dismissible widget.
- The date for each task is formatted using the intl package and displayed as a formatted date.

## Screenshots
![Screenshot_1702072364 (Small)](https://github.com/Enki013/todo_app/assets/39771190/dbfe8143-a0c9-4f57-b2cc-bc8616b4e1ec)
