import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/task.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  // Initialiser la base de données
  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [TaskSchema],
        directory: dir.path,
      );
    }
    return Future.value(Isar.getInstance());
  }

  // Créer une nouvelle tâche
  Future<void> createTask(Task task) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.collection<Task>().put(task);
    });
  }

  // Récupérer toutes les tâches
  Future<List<Task>> getAllTasks() async {
    final isar = await db;
    return await isar.collection<Task>().where().findAll();
  }

  // Mettre à jour une tâche
  Future<void> updateTask(Task task) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.collection<Task>().put(task);
    });
  }

  // Supprimer une tâche
  Future<void> deleteTask(int id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.collection<Task>().delete(id);
    });
  }
} 