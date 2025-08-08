import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/task_view_model.dart';
import 'widgets/task_card_widget.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Task Manager',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: Colors.grey.shade800,
      ),
      body: Consumer<TaskViewModel>(
        builder: (context, viewModel, child) {
          return CustomScrollView(
            slivers: [

              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final task = viewModel.tasks[index];
                    return TaskCardWidget(task: task);
                  },
                  childCount: viewModel.tasks.length,
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 20),
              ),
            ],
          );
        },
      ),
    );
  }
}