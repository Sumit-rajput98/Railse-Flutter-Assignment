import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskViewModel extends ChangeNotifier {
  final List<TaskModel> _tasks = [
    TaskModel(
      id: 'Order-1043',
      title: 'Arrange Pickup',
      description: 'High Priority',
      assignee: 'Sandhya',
      isHighPriority: true,
      status: TaskStatus.notStarted,
      startDate: DateTime(2025, 8, 10),
      dueDate: DateTime(2025, 8, 12),
    ),
    TaskModel(
      id: 'Entity-2559',
      title: 'Adhoc Task',
      description: '',
      assignee: 'Arman',
      status: TaskStatus.notStarted,
      startDate: DateTime(2025, 8, 12),
      dueDate: DateTime(2025, 8, 16),
    ),
    TaskModel(
      id: 'Order-1020',
      title: 'Collect Payment',
      description: 'High Priority',
      assignee: 'Sandhya',
      isHighPriority: true,
      status: TaskStatus.started,
      startDate: DateTime(2025, 8, 15),
      dueDate: DateTime(2025, 8, 20),
    ),
    TaskModel(
      id: 'Order-194',
      title: 'Arrange Delivery',
      description: '',
      assignee: 'Prashant',
      status: TaskStatus.completed,
      startDate: DateTime(2025, 8, 20),
      dueDate: DateTime(2025, 8, 21),
    ),
    TaskModel(
      id: 'Entity-2184',
      title: 'Share Company Profile',
      description: '',
      assignee: 'Asif Khan K',
      status: TaskStatus.completed,
      startDate: DateTime(2025, 8, 22),
      dueDate: DateTime(2025, 8, 23),
    ),
    TaskModel(
      id: 'Enquiry-3563',
      title: 'Convert Enquiry',
      description: '',
      assignee: 'Prashant',
      status: TaskStatus.notStarted,
      startDate: DateTime(2025, 8, 28),
      dueDate: DateTime(2025, 8, 30),
    ),
    TaskModel(
      id: 'Order-176',
      title: 'Arrange Pickup',
      description: 'High Priority',
      assignee: 'Prashant',
      isHighPriority: true,
      status: TaskStatus.notStarted,
      startDate: DateTime(2025, 9, 1),
      dueDate: DateTime(2025, 9, 2),
    ),
  ];

  List<TaskModel> get tasks => _tasks;

  void startTask(String taskId) {
    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
    if (taskIndex != -1 && _tasks[taskIndex].status == TaskStatus.notStarted) {
      _tasks[taskIndex] = _tasks[taskIndex].copyWith(status: TaskStatus.started);
      notifyListeners();
    }
  }

  void markAsComplete(String taskId) {
    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
    if (taskIndex != -1 && _tasks[taskIndex].status == TaskStatus.started) {
      _tasks[taskIndex] = _tasks[taskIndex].copyWith(status: TaskStatus.completed);
      notifyListeners();
    }
  }

  void updateStartDate(String taskId, DateTime newDate) {
    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
    if (taskIndex != -1 && _tasks[taskIndex].status == TaskStatus.notStarted) {
      _tasks[taskIndex] = _tasks[taskIndex].copyWith(startDate: newDate);
      notifyListeners();
    }
  }

  void updateDueDate(String taskId, DateTime newDate) {
    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
    if (taskIndex != -1 &&
        (_tasks[taskIndex].status == TaskStatus.notStarted ||
            _tasks[taskIndex].status == TaskStatus.started)) {
      _tasks[taskIndex] = _tasks[taskIndex].copyWith(dueDate: newDate);
      notifyListeners();
    }
  }

  String getStatusText(TaskModel task) {
    if (task.status == TaskStatus.completed) {
      return 'Completed: ${_formatDate(task.dueDate)}';
    }

    final now = DateTime.now();
    final difference = task.dueDate.difference(now);

    if (difference.isNegative) {
      final overdue = now.difference(task.dueDate);
      if (overdue.inDays > 0) {
        return 'Overdue - ${overdue.inDays}d ${overdue.inHours % 24}h';
      } else if (overdue.inHours > 0) {
        return 'Overdue - ${overdue.inHours}h ${overdue.inMinutes % 60}m';
      } else {
        return 'Overdue - ${overdue.inMinutes}m';
      }
    } else {
      if (difference.inDays > 1) {
        return 'Due in ${difference.inDays} days';
      } else if (difference.inDays == 1) {
        return 'Due Tomorrow';
      } else if (difference.inHours > 0) {
        return 'Due in ${difference.inHours}h ${difference.inMinutes % 60}m';
      } else {
        return 'Due in ${difference.inMinutes}m';
      }
    }
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}';
  }
}