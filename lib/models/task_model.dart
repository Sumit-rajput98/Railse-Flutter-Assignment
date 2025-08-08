

enum TaskStatus { notStarted, started, completed }

class TaskModel {
  final String id;
  final String title;
  final String description;
  final String assignee;
  final bool isHighPriority;
  TaskStatus status;
  DateTime startDate;
  DateTime dueDate;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.assignee,
    this.isHighPriority = false,
    this.status = TaskStatus.notStarted,
    required this.startDate,
    required this.dueDate,
  });

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    String? assignee,
    bool? isHighPriority,
    TaskStatus? status,
    DateTime? startDate,
    DateTime? dueDate,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      assignee: assignee ?? this.assignee,
      isHighPriority: isHighPriority ?? this.isHighPriority,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}