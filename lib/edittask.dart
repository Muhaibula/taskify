import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditTaskPage extends StatefulWidget {
  final Map<String, dynamic> existingTask;
  final String taskId;

  const EditTaskPage({super.key, required this.existingTask, required this.taskId});

  @override
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _priority = "High";
  bool _notification = false;
  String _selectedCategory = "Default";

  @override
  void initState() {
    super.initState();
    _prefill();
  }

  void _prefill() {
    final data = widget.existingTask;
    _taskController.text = data['title'] ?? '';
    _descController.text = data['description'] ?? '';
    _priority = data['priority'] ?? _priority;
    _selectedCategory = data['category'] ?? _selectedCategory;
    _notification = data['notification'] ?? _notification;
    if (data['date'] != null) {
      try {
        _selectedDate = DateTime.parse(data['date']);
      } catch (_) {}
    }
    if (data['time'] != null) {
      final parts = (data['time'] as String).split(':');
      if (parts.length >= 2) {
        final h = int.tryParse(parts[0]) ?? 0;
        final m = int.tryParse(parts[1]) ?? 0;
        _selectedTime = TimeOfDay(hour: h, minute: m);
      }
    }
  }

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime() async {
    TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: _selectedTime ?? TimeOfDay.now());
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _saveTask() async {
    if (_taskController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Task title cannot be empty")),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('tasks').doc(widget.taskId).update({
      'title': _taskController.text.trim(),
      'description': _descController.text.trim(),
      'priority': _priority,
      'category': _selectedCategory,
      'notification': _notification,
      'date': _selectedDate?.toIso8601String(),
      'time': _selectedTime != null
          ? "${_selectedTime!.hour}:${_selectedTime!.minute.toString().padLeft(2, '0')}"
          : null,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Task updated successfully")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          "Edit Task",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Task Title", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _taskController,
                decoration: InputDecoration(
                  hintText: "Enter task name",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 20),

              const Text("Description", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _descController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Add description (optional)",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _pickDate,
                      icon: const Icon(Icons.calendar_today_outlined),
                      label: Text(
                        _selectedDate == null ? "Set Date" : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _pickTime,
                      icon: const Icon(Icons.access_time_outlined),
                      label: Text(
                        _selectedTime == null ? "Set Time" : "${_selectedTime!.hour}:${_selectedTime!.minute.toString().padLeft(2, '0')}",
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              const Text("Priority", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 10,
                children: ["Low", "Medium", "High"].map((level) {
                  return ChoiceChip(
                    label: Text(level),
                    selected: _priority == level,
                    onSelected: (_) {
                      setState(() {
                        _priority = level;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Notification", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Switch(
                    value: _notification,
                    onChanged: (val) {
                      setState(() {
                        _notification = val;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              const Text("Category", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: ["Default","education", "Work", "Personal", "Shopping"].map((category) => DropdownMenuItem(value: category, child: Text(category))).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),
              const SizedBox(height: 30),

              Center(
                child: ElevatedButton.icon(
                  onPressed: _saveTask,
                  icon: const Icon(Icons.check),
                  label: const Text("Save Changes"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
