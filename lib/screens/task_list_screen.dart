import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import 'task_detail_screen.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Todo List'),
            actions: [
              if (taskProvider.isSelectionMode) ...[
                IconButton(
                  icon: const Icon(Icons.select_all),
                  onPressed: () => taskProvider.selectAllTasks(),
                  tooltip: 'Tout sélectionner',
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: taskProvider.selectedCount > 0
                      ? () => _confirmDeleteSelected(context, taskProvider)
                      : null,
                  tooltip: 'Supprimer la sélection',
                ),
                TextButton(
                  onPressed: () => taskProvider.toggleSelectionMode(),
                  child: const Text('Annuler', style: TextStyle(color: Colors.white)),
                ),
              ] else ...[
                IconButton(
                  icon: const Icon(Icons.checklist),
                  onPressed: () => taskProvider.toggleSelectionMode(),
                  tooltip: 'Mode sélection',
                ),
              ],
            ],
          ),
          body: _buildTaskList(context, taskProvider),
          floatingActionButton: !taskProvider.isSelectionMode
              ? FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TaskDetailScreen(),
                      ),
                    );
                  },
                  child: const Icon(Icons.add),
                )
              : null,
        );
      },
    );
  }

  Widget _buildTaskList(BuildContext context, TaskProvider taskProvider) {
    if (taskProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (taskProvider.tasks.isEmpty) {
      return const Center(child: Text('Aucune tâche pour le moment'));
    }
    
    return ListView.builder(
      itemCount: taskProvider.tasks.length,
      itemBuilder: (context, index) {
        final task = taskProvider.tasks[index];
        return TaskListItem(
          task: task,
          isSelectionMode: taskProvider.isSelectionMode,
          isSelected: taskProvider.selectedTaskIds.contains(task.id),
        );
      },
    );
  }

  void _confirmDeleteSelected(BuildContext context, TaskProvider taskProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content: Text(
          'Voulez-vous supprimer ${taskProvider.selectedCount} tâche(s) ?'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              taskProvider.deleteSelectedTasks();
              Navigator.pop(context);
            },
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}

class TaskListItem extends StatelessWidget {
  final Task task;
  final bool isSelectionMode;
  final bool isSelected;

  const TaskListItem({
    Key? key, 
    required this.task,
    this.isSelectionMode = false,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    return Dismissible(
      key: Key(task.id.toString()),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        taskProvider.deleteTask(task.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${task.title} supprimée')),
        );
      },
      // Désactiver le swipe en mode sélection
      confirmDismiss: (direction) async => !isSelectionMode,
      child: ListTile(
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: task.description != null ? Text(task.description!) : null,
        leading: isSelectionMode
            ? Checkbox(
                value: isSelected,
                onChanged: (_) => taskProvider.toggleTaskSelection(task.id),
              )
            : Checkbox(
                value: task.isCompleted,
                onChanged: (bool? value) {
                  taskProvider.toggleTaskCompletion(task);
                },
              ),
        onTap: () {
          if (isSelectionMode) {
            taskProvider.toggleTaskSelection(task.id);
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskDetailScreen(task: task),
              ),
            );
          }
        },
        // Ajouter une couleur de fond pour les éléments sélectionnés
        tileColor: isSelected ? Colors.blue.withOpacity(0.1) : null,
      ),
    );
  }
} 