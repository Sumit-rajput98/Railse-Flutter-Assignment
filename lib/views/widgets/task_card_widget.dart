import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import '../../models/task_model.dart';
import '../../viewmodels/task_view_model.dart';

class TaskCardWidget extends StatelessWidget {
  final TaskModel task;

  const TaskCardWidget({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: _getCardColor(),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: _getBorderColor(),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            _buildContent(),
            const SizedBox(height: 16),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getTaskIdBackgroundColor(),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  task.id,
                  style: TextStyle(
                    color: _getTaskIdTextColor(),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              if (task.isHighPriority)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Ionicons.flame,
                        size: 12,
                        color: Colors.red.shade700,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'High Priority',
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        _buildStatusIndicator(),
      ],
    );
  }

  Widget _buildStatusIndicator() {
    IconData iconData;
    Color iconColor;

    switch (task.status) {
      case TaskStatus.notStarted:
        iconData = Ionicons.time_outline;
        iconColor = Colors.orange.shade600;
        break;
      case TaskStatus.started:
        iconData = Ionicons.play_circle;
        iconColor = Colors.blue.shade600;
        break;
      case TaskStatus.completed:
        iconData = Ionicons.checkmark_circle;
        iconColor = Colors.green.shade600;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        iconData,
        size: 20,
        color: iconColor,
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Ionicons.briefcase_outline,
              size: 16,
              color: _getTextColor(),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                task.title,
                style: TextStyle(
                  color: _getTextColor(),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              Ionicons.person_outline,
              size: 14,
              color: _getSubtextColor(),
            ),
            const SizedBox(width: 8),
            Text(
              task.assignee,
              style: TextStyle(
                color: _getSubtextColor(),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Column(
      children: [

        _buildDateSections(context),
        const SizedBox(height: 12),

        _buildStatusText(context),
        const SizedBox(height: 16),

        _buildActionButton(context),
      ],
    );
  }

  Widget _buildDateSections(BuildContext context) {
    return Column(
      children: [
        // Start Date Row
        Row(
          children: [
            Icon(
              Ionicons.play_outline,
              size: 16,
              color: _getSubtextColor(),
            ),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: task.status == TaskStatus.notStarted
                  ? () => _selectStartDate(context)
                  : null,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: task.status == TaskStatus.notStarted
                      ? Colors.grey.shade100
                      : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  'Start: ${DateFormat('MMM d').format(task.startDate)}',
                  style: TextStyle(
                    color: task.status == TaskStatus.notStarted
                        ? _getSubtextColor()
                        : Colors.grey.shade400,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            if (task.status == TaskStatus.notStarted) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _selectStartDate(context),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    Ionicons.create_outline,
                    size: 14,
                    color: Colors.blue.shade600,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),

        Row(
          children: [
            Icon(
              Ionicons.flag_outline,
              size: 16,
              color: _getSubtextColor(),
            ),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: (task.status == TaskStatus.notStarted || task.status == TaskStatus.started)
                  ? () => _selectDueDate(context)
                  : null,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: (task.status == TaskStatus.notStarted || task.status == TaskStatus.started)
                      ? Colors.grey.shade100
                      : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  'Due: ${DateFormat('MMM d').format(task.dueDate)}',
                  style: TextStyle(
                    color: (task.status == TaskStatus.notStarted || task.status == TaskStatus.started)
                        ? _getSubtextColor()
                        : Colors.grey.shade400,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            if (task.status == TaskStatus.notStarted || task.status == TaskStatus.started) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _selectDueDate(context),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    Ionicons.create_outline,
                    size: 14,
                    color: Colors.orange.shade600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildStatusText(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: _getStatusBackgroundColor(),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          context.read<TaskViewModel>().getStatusText(task),
          style: TextStyle(
            color: _getStatusTextColor(),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    final viewModel = context.read<TaskViewModel>();

    switch (task.status) {
      case TaskStatus.notStarted:
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade500, Colors.blue.shade600],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.shade200,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton.icon(
            onPressed: () => viewModel.startTask(task.id),
            icon: const Icon(Ionicons.play, size: 18),
            label: const Text(
              'Start Task',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        );

      case TaskStatus.started:
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade500, Colors.green.shade600],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.green.shade200,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton.icon(
            onPressed: () => viewModel.markAsComplete(task.id),
            icon: const Icon(Ionicons.checkmark_circle, size: 18),
            label: const Text(
              'Mark as Complete',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        );

      case TaskStatus.completed:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green.shade200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Ionicons.checkmark_circle,
                color: Colors.green.shade600,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Completed',
                style: TextStyle(
                  color: Colors.green.shade600,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
    }
  }

  Future<void> _selectStartDate(BuildContext context) async {
    if (task.status != TaskStatus.notStarted) return;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: task.startDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2026),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue.shade600,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != task.startDate) {
      context.read<TaskViewModel>().updateStartDate(task.id, picked);
    }
  }

  Future<void> _selectDueDate(BuildContext context) async {
    if (task.status == TaskStatus.completed) return;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: task.dueDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2026),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.orange.shade600,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != task.dueDate) {
      context.read<TaskViewModel>().updateDueDate(task.id, picked);
    }
  }


  Color _getCardColor() {
    switch (task.status) {
      case TaskStatus.notStarted:
        return Colors.white;
      case TaskStatus.started:
        return Colors.blue.shade50;
      case TaskStatus.completed:
        return Colors.grey.shade50;
    }
  }

  Color _getBorderColor() {
    switch (task.status) {
      case TaskStatus.notStarted:
        return Colors.orange.shade200;
      case TaskStatus.started:
        return Colors.blue.shade200;
      case TaskStatus.completed:
        return Colors.green.shade200;
    }
  }

  Color _getTaskIdBackgroundColor() {
    switch (task.status) {
      case TaskStatus.notStarted:
        return Colors.orange.shade100;
      case TaskStatus.started:
        return Colors.blue.shade100;
      case TaskStatus.completed:
        return Colors.grey.shade200;
    }
  }

  Color _getTaskIdTextColor() {
    switch (task.status) {
      case TaskStatus.notStarted:
        return Colors.orange.shade700;
      case TaskStatus.started:
        return Colors.blue.shade700;
      case TaskStatus.completed:
        return Colors.grey.shade600;
    }
  }

  Color _getTextColor() {
    return task.status == TaskStatus.completed
        ? Colors.grey.shade600
        : Colors.grey.shade800;
  }

  Color _getSubtextColor() {
    return task.status == TaskStatus.completed
        ? Colors.grey.shade500
        : Colors.grey.shade600;
  }

  Color _getStatusBackgroundColor() {
    switch (task.status) {
      case TaskStatus.notStarted:
      case TaskStatus.started:
        return Colors.red.shade50;
      case TaskStatus.completed:
        return Colors.green.shade50;
    }
  }

  Color _getStatusTextColor() {
    switch (task.status) {
      case TaskStatus.notStarted:
      case TaskStatus.started:
        return Colors.red.shade700;
      case TaskStatus.completed:
        return Colors.green.shade700;
    }
  }
}
