import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import '../../models/task_model.dart';
import '../../viewmodels/task_view_model.dart';

class TaskCardWidget extends StatelessWidget {
  final TaskModel task;
  const TaskCardWidget({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TaskViewModel>();
    final isCompleted = task.status == TaskStatus.completed;
    const linkBlue = Color(0xFF5046E4);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE8E8E8), width: 1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 4, height: 78, color: _leftBarColor(task.status)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  _linkText(task.id, linkBlue, () {}),
                  const SizedBox(width: 6),
                  _iconButton(Ionicons.ellipsis_vertical, () {}, Colors.grey[600]),
                ]),
                const SizedBox(height: 4),
                _titleText(task.title, isCompleted),
                const SizedBox(height: 6),
                Row(children: [
                  _assigneeText(task.assignee, isCompleted),
                  if (task.isHighPriority) ...[
                    const SizedBox(width: 8),
                    _priorityBadge(),
                  ]
                ]),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(mainAxisSize: MainAxisSize.min, children: [
                _statusText(vm.getStatusText(task), isCompleted, task.status),
                if (!isCompleted) ...[
                  const SizedBox(width: 6),
                  _iconButton(Ionicons.create_outline, () => _editDueDate(context, vm, task), Colors.grey[500]),
                ],
              ]),
              const SizedBox(height: 8),
              Row(children: [
                Text(
                  task.status == TaskStatus.notStarted
                      ? 'Start: ${DateFormat('MMM d').format(task.startDate)}'
                      : 'Started: ${DateFormat('MMM d').format(task.startDate)}',
                  style: TextStyle(fontSize: 11, color: isCompleted ? Colors.grey[350] : Colors.grey[600]),
                ),
                if (task.status == TaskStatus.notStarted) ...[
                  const SizedBox(width: 6),
                  _iconButton(Ionicons.create_outline, () => _selectStartDate(context), Colors.grey[500]),
                ]
              ]),
              const SizedBox(height: 8),
              _actionButton(context, vm, linkBlue, isCompleted),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _linkText(String text, Color color, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Text(
      text,
      style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w700, decoration: TextDecoration.underline),
    ),
  );

  static Widget _iconButton(IconData icon, VoidCallback onTap, Color? color) =>
      GestureDetector(onTap: onTap, child: Icon(icon, size: 16, color: color));

  static Widget _titleText(String title, bool isCompleted) => Text(
    title,
    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: isCompleted ? Colors.grey[400] : Colors.black87),
  );

  static Widget _assigneeText(String name, bool isCompleted) => Text(
    name,
    style: TextStyle(fontSize: 12, color: isCompleted ? Colors.grey[400] : Colors.black87, fontWeight: FontWeight.w500),
  );

  static Widget _priorityBadge() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(
      color: const Color(0xFFFFEBEE),
      border: Border.all(color: const Color(0xFFEF9A9A)),
      borderRadius: BorderRadius.circular(4),
    ),
    child: const Text(
      'High Priority',
      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFFD32F2F)),
    ),
  );

  static Widget _statusText(String text, bool isCompleted, TaskStatus status) => Text(
    text,
    style: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w700,
      color: isCompleted ? Colors.green.shade400 : _statusColor(status),
    ),
  );

  Widget _actionButton(BuildContext context, TaskViewModel vm, Color linkBlue, bool isCompleted) {
    if (task.status == TaskStatus.notStarted) {
      return GestureDetector(
        onTap: () => vm.startTask(task.id),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Ionicons.play_circle, size: 14, color: linkBlue),
          const SizedBox(width: 6),
          Text('Start Task', style: TextStyle(fontSize: 12, color: linkBlue, fontWeight: FontWeight.w700)),
        ]),
      );
    } else if (task.status == TaskStatus.started) {
      return GestureDetector(
        onTap: () => vm.markAsComplete(task.id),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Ionicons.checkmark_circle, size: 14, color: Colors.green.shade700),
          const SizedBox(width: 6),
          Text('Mark as complete',
              style: TextStyle(fontSize: 12, color: Colors.green.shade700, fontWeight: FontWeight.w700)),
        ]),
      );
    }
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(Ionicons.checkmark_circle, size: 14, color: Colors.green.shade400),
      const SizedBox(width: 6),
      const Text('Completed', style: TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.w700)),
    ]);
  }

  static Color _statusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.notStarted:
        return Colors.orange.shade700;
      case TaskStatus.started:
        return Colors.red.shade700;
      case TaskStatus.completed:
        return Colors.green.shade600;
    }
  }

  static Color _leftBarColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.notStarted:
        return Colors.grey.shade300;
      case TaskStatus.started:
        return const Color(0xFF5046E4);
      case TaskStatus.completed:
        return Colors.green.shade200;
    }
  }

  static Future<void> _editDueDate(BuildContext context, TaskViewModel vm, TaskModel task) async {
    final picked = await _pickDate(context, task.dueDate);
    if (picked != null) vm.updateDueDate(task.id, picked);
  }

  static Future<DateTime?> _pickDate(BuildContext context, DateTime initial) {
    return showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (ctx, child) {
        return Theme(
          data: Theme.of(ctx).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue.shade700,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
  }

  Future<void> _selectStartDate(BuildContext context) async {
    if (task.status != TaskStatus.notStarted) return;
    final picked = await _pickDate(context, task.startDate);
    if (picked != null && picked != task.startDate) {
      context.read<TaskViewModel>().updateStartDate(task.id, picked);
    }
  }
}
