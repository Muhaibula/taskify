import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskCard extends StatelessWidget {
  final String taskId;
  final String title;
  final String description;
  final String status;

  const TaskCard({
    super.key,
    required this.taskId,
    required this.title,
    required this.description,
    required this.status,
  });

  void _markAsCompleted() {
    FirebaseFirestore.instance
        .collection('tasks')
        .doc(taskId)
        .update({'status': 'Completed'});
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: ListTile(
        title: Text(title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: status == "Completed"
                    ? TextDecoration.lineThrough
                    : TextDecoration.none)),
        subtitle: Text(description),
        trailing: status == "Pending"
            ? IconButton(
                icon: const Icon(Icons.check_circle, color: Colors.green),
                onPressed: _markAsCompleted,
              )
            : const Icon(Icons.check_circle, color: Colors.grey),
      ),
    );
  }
}
