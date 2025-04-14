import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../services/isar_service.dart';

class TaskProvider extends ChangeNotifier {
  final IsarService _isarService = IsarService();
  List<Task> _tasks = [];
  bool _isLoading = false;
  Set<int> _selectedTaskIds = {}; // Pour stocker les IDs des tâches sélectionnées
  bool _isSelectionMode = false; // Mode de sélection activé ou non

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  Set<int> get selectedTaskIds => _selectedTaskIds;
  bool get isSelectionMode => _isSelectionMode;
  int get selectedCount => _selectedTaskIds.length;

  TaskProvider() {
    loadTasks();
  }

  // Charger toutes les tâches
  Future<void> loadTasks() async {
    _isLoading = true;
    notifyListeners();
    
    _tasks = await _isarService.getAllTasks();
    
    _isLoading = false;
    notifyListeners();
  }

  // Ajouter une nouvelle tâche
  Future<void> addTask(Task task) async {
    await _isarService.createTask(task);
    await loadTasks();
  }

  // Mettre à jour une tâche
  Future<void> updateTask(Task task) async {
    await _isarService.updateTask(task);
    await loadTasks();
  }

  // Supprimer une tâche
  Future<void> deleteTask(int id) async {
    await _isarService.deleteTask(id);
    _selectedTaskIds.remove(id); // Supprimer de la sélection si présent
    await loadTasks();
  }

  // Basculer l'état d'achèvement d'une tâche
  Future<void> toggleTaskCompletion(Task task) async {
    task.isCompleted = !task.isCompleted;
    await updateTask(task);
  }

  // Activer/désactiver le mode sélection
  void toggleSelectionMode() {
    _isSelectionMode = !_isSelectionMode;
    if (!_isSelectionMode) {
      _selectedTaskIds.clear(); // Effacer la sélection si on quitte le mode
    }
    notifyListeners();
  }

  // Sélectionner/désélectionner une tâche
  void toggleTaskSelection(int taskId) {
    if (_selectedTaskIds.contains(taskId)) {
      _selectedTaskIds.remove(taskId);
    } else {
      _selectedTaskIds.add(taskId);
    }
    
    // Si plus aucune tâche n'est sélectionnée, désactiver le mode sélection
    if (_selectedTaskIds.isEmpty && _isSelectionMode) {
      _isSelectionMode = false;
    }
    
    notifyListeners();
  }

  // Sélectionner toutes les tâches
  void selectAllTasks() {
    _selectedTaskIds = _tasks.map((task) => task.id).toSet();
    notifyListeners();
  }

  // Désélectionner toutes les tâches
  void deselectAllTasks() {
    _selectedTaskIds.clear();
    notifyListeners();
  }

  // Supprimer les tâches sélectionnées
  Future<void> deleteSelectedTasks() async {
    _isLoading = true;
    notifyListeners();
    
    for (final id in _selectedTaskIds) {
      await _isarService.deleteTask(id);
    }
    
    _selectedTaskIds.clear();
    _isSelectionMode = false;
    await loadTasks();
  }
} 