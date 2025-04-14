# Flutter Todo List App with Isar DB

A simple todo list management application developed with Flutter and using Isar DB for local data storage.

![App Screenshot](https://via.placeholder.com/750x400?text=Todo+List+App+Screenshot)

## ✨ Features

- Create, edit and delete tasks
- Mark tasks as completed
- Multi-selection mode to manage several tasks at once
- Persistent data storage with Isar DB

## 🏗️ Project Architecture

The application follows a modular architecture with separation of responsibilities:

### Models
- **Task**: Represents a task with its properties (title, description, status, creation date)
- Uses Isar annotations for data persistence

### Services
- **IsarService**: Manages database operations (CRUD) for tasks
- Initializes the connection to the Isar database

### Providers
- **TaskProvider**: Manages the application state and connects the UI with services
- Implements multi-selection features and task management

### Screens
- **TaskListScreen**: Displays the task list with filtering and selection options
- **TaskDetailScreen**: Allows creating or editing a task

## 🚀 Getting Started

### Prerequisites
- Flutter SDK installed
- Dart SDK installed
- An IDE (VS Code, Android Studio, etc.)

### Installation

1. Clone the repository
   ```bash
   git clone https://github.com/yourusername/flutter-todo-isar.git
   ```

2. Navigate to project directory
   ```bash
   cd flutter-todo-isar
   ```

3. Install dependencies
   ```bash
   flutter pub get
   ```

4. Run the app
   ```bash
   flutter run
   ```

## 📦 Dependencies

- **isar**: Fast NoSQL database for Flutter
- **provider**: State management for Flutter
- **path_provider**: Access to file system paths

## 🧱 Code Structure

```
lib/
├── models/
│   └── task.dart
├── services/
│   └── isar_service.dart
├── providers/
│   └── task_provider.dart
├── screens/
│   ├── task_list_screen.dart
│   └── task_detail_screen.dart
├── widgets/
│   ├── task_item.dart
│   └── task_form.dart
└── main.dart
```

The code is organized according to atomic architecture principles, with a clear separation between:
- Business logic (services, providers)
- Data models
- User interface (screens, widgets)

Each component is designed to be modular and reusable, making the application easier to maintain and evolve.

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!