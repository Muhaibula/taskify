import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'addtask.dart';
import 'edittask.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F8),

      drawer: Drawer(
        child: Column(
          children: [
            // Modern card-style header
            Container(
              width: double.infinity,
              height: 180,
              decoration: const BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
                  child: Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white24,
                        ),
                        child: const Icon(Icons.task_alt, color: Colors.white, size: 36),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Taskify', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Text(
                              'Organize your day',
                              style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14),
                            ),
                            const SizedBox(height: 8),
                            // optional small account hint
                            Text(
                              FirebaseAuth.instance.currentUser?.email ?? '',
                              style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Grouped items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 12, 16, 6),
                    child: Text('Main', style: TextStyle(fontSize: 12, color: Colors.black54)),
                  ),
                  ListTile(
                    leading: const Icon(Icons.home_outlined),
                    title: const Text('Home'),
                    onTap: () => Navigator.pushReplacementNamed(context, '/home'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings_outlined),
                    title: const Text('Settings'),
                    onTap: () => Navigator.pushNamed(context, '/settings'),
                  ),
                  const Divider(),

                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 6),
                    child: Text('Actions', style: TextStyle(fontSize: 12, color: Colors.black54)),
                  ),
                  ListTile(
                    leading: const Icon(Icons.feedback_outlined),
                    title: const Text('Send Feedback'),
                    onTap: () {
                      Navigator.pop(context);
                      final _controller = TextEditingController();
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Send Feedback'),
                          content: TextField(
                            controller: _controller,
                            maxLines: 4,
                            decoration: const InputDecoration(hintText: 'Describe your issue or suggestion'),
                          ),
                          actions: [
                            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
                            TextButton(
                              onPressed: () async {
                                final msg = _controller.text.trim();
                                if (msg.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter feedback')));
                                  return;
                                }
                                await FirebaseFirestore.instance.collection('feedback').add({
                                  'message': msg,
                                  'user': FirebaseAuth.instance.currentUser?.uid,
                                  'createdAt': FieldValue.serverTimestamp(),
                                });
                                if (ctx.mounted) Navigator.of(ctx).pop();
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Thanks for your feedback')));
                              },
                              child: const Text('Send'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.group_outlined),
                    title: const Text('Follow us'),
                    onTap: () {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Follow us'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.link),
                                title: const Text('Twitter'),
                                subtitle: const Text('https://twitter.com/yourhandle'),
                                onTap: () {
                                  Clipboard.setData(const ClipboardData(text: 'https://twitter.com/yourhandle'));
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Twitter link copied')));
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.link),
                                title: const Text('Instagram'),
                                subtitle: const Text('https://instagram.com/yourhandle'),
                                onTap: () {
                                  Clipboard.setData(const ClipboardData(text: 'https://instagram.com/yourhandle'));
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Instagram link copied')));
                                },
                              ),
                            ],
                          ),
                          actions: [TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Close'))],
                        ),
                      );
                    },
                  ),

                  const Divider(),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 6),
                    child: Text('About', style: TextStyle(fontSize: 12, color: Colors.black54)),
                  ),
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text('Version & Info'),
                    onTap: () {
                      Navigator.pop(context);
                      showAboutDialog(
                        context: context,
                        applicationName: 'Taskify',
                        applicationVersion: '1.0.0',
                        children: const [Text('Taskify helps you track tasks and stay productive.')],
                      );
                    },
                  ),
                ],
              ),
            ),

            // Footer: version and sign out
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('v1.0.0', style: TextStyle(color: Colors.black45)),
                  TextButton.icon(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Signed out')));
                        Navigator.pushReplacementNamed(context, '/welcome');
                      }
                    },
                    icon: const Icon(Icons.logout, size: 18),
                    label: const Text('Sign out'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      appBar: AppBar(
        backgroundColor: const Color(0xFFE7E1E8),
        elevation: 0,
        title: const Text(
          "All Your Tasks",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.account_circle_rounded,
              color: Colors.black54,
              size: 30,
            ),
            onPressed: () {
              final user = FirebaseAuth.instance.currentUser;
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Profile'),
                  content: user == null
                      ? const Text('No user signed in')
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 36,
                              backgroundImage: user.photoURL != null ? NetworkImage(user.photoURL!) : null,
                              child: user.photoURL == null ? const Icon(Icons.account_circle, size: 48) : null,
                            ),
                            const SizedBox(height: 12),
                            Text(user.displayName ?? 'No display name', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Text(user.email ?? 'No email', style: const TextStyle(color: Colors.black54)),
                            const SizedBox(height: 6),
                            Text('UID: ${user.uid}', style: const TextStyle(fontSize: 12, color: Colors.black45)),
                          ],
                        ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: const Text('Close'),
                    ),
                    TextButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        if (context.mounted) {
                          Navigator.of(ctx).pop();
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Signed out')));
                          Navigator.pushReplacementNamed(context, '/welcome');
                        }
                      },
                      child: const Text('Sign out'),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(width: 10),
        ],
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tasks')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, taskSnapshot) {
          if (!taskSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('quicktask')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, quickSnapshot) {
              if (!quickSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final allTasks = [
                ...taskSnapshot.data!.docs,
                ...quickSnapshot.data!.docs
              ];

              // Sort by priority (High -> Medium -> Low -> none) then by createdAt desc
              int priorityWeight(Map<String, dynamic> data) {
                final p = (data['priority'] ?? '').toString().toLowerCase();
                if (p == 'high') return 3;
                if (p == 'medium') return 2;
                if (p == 'low') return 1;
                return 0;
              }

              allTasks.sort((a, b) {
                final da = a.data() as Map<String, dynamic>;
                final db = b.data() as Map<String, dynamic>;
                final pa = priorityWeight(da);
                final pb = priorityWeight(db);
                if (pa != pb) return pb.compareTo(pa); // higher weight first

                // Tie-breaker: createdAt timestamp (newest first)
                final ca = da['createdAt'];
                final cb = db['createdAt'];
                try {
                  if (ca is Timestamp && cb is Timestamp) {
                    return cb.compareTo(ca);
                  }
                } catch (_) {}
                return 0;
              });

              if (allTasks.isEmpty) {
                return const Center(child: Text("No tasks yet"));
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 12),
                itemCount: allTasks.length,
                itemBuilder: (context, index) {
                  final task = allTasks[index].data() as Map<String, dynamic>;
                  final isQuick =
                      allTasks[index].reference.parent.id == "quicktask";

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        onTap: () {
                          // Open detail dialog
                          showDialog(
                            context: context,
                            builder: (ctx) => TaskDetailDialog(
                              doc: allTasks[index],
                              data: task,
                              isQuick: isQuick,
                            ),
                          );
                        },
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                // Priority chip
                                if (task['priority'] != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    margin: const EdgeInsets.only(right: 6),
                                    decoration: BoxDecoration(
                                      color: (task['priority'] == 'High')
                                          ? Colors.red.withOpacity(0.12)
                                          : (task['priority'] == 'Medium')
                                              ? Colors.orange.withOpacity(0.12)
                                              : Colors.green.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      (task['priority'] ?? '').toString(),
                                      style: TextStyle(
                                        color: (task['priority'] == 'High')
                                            ? Colors.red
                                            : (task['priority'] == 'Medium')
                                                ? Colors.orange
                                                : Colors.green,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),

                                // Status chip
                                if (task['status'] != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: (task['status'] == 'Done')
                                          ? Colors.green.withOpacity(0.12)
                                          : (task['status'] == 'Overdue')
                                              ? Colors.red.withOpacity(0.12)
                                              : Colors.orange.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      (task['status'] ?? '').toString(),
                                      style: TextStyle(
                                        color: (task['status'] == 'Done')
                                            ? Colors.green
                                            : (task['status'] == 'Overdue')
                                                ? Colors.red
                                                : Colors.orange,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              task['title'] ?? '',
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 6),
                            // Third line: description and meta
                            Row(
                              children: [
                                Expanded(
                                  child: (task['description'] != null && (task['description'] as String).trim().isNotEmpty)
                                      ? Text(
                                          task['description'],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(color: Colors.black54, fontSize: 13),
                                        )
                                      : const SizedBox.shrink(),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  task['date'] != null ? (task['date'].toString().split('T').first) : (task['category'] ?? ''),
                                  style: const TextStyle(fontSize: 12, color: Colors.black38),
                                ),
                              ],
                            ),
                          ],
                        ),
                        subtitle: (task['description'] != null && (task['description'] as String).trim().isNotEmpty)
                            ? Text(
                                task['description'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )
                            : null,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (isQuick) {
                                  showDialog(
                                    context: context,
                                    builder: (_) => EditQuickTaskDialog(
                                      id: allTasks[index].id,
                                      currentTitle: task['title'] ?? '',
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => EditTaskPage(
                                        existingTask: task,
                                        taskId: allTasks[index].id,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6.0),
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                  size: 20,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                allTasks[index].reference.delete();
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6.0),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.withOpacity(0.12),
                  blurRadius: 14,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    showSearch(
                      context: context,
                      delegate: TaskSearchDelegate(),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0ECF4),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.search, color: Colors.deepPurple),
                  ),
                ),

                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => const QuickAddDialog(),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F6FB),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.deepPurple.shade100),
                      ),
                      child: const Text(
                        "Add a quick task...",
                        style: TextStyle(fontSize: 16, color: Colors.black45),
                      ),
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddTaskPage(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.add, size: 26, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Task Detail Dialog
class TaskDetailDialog extends StatelessWidget {
  final QueryDocumentSnapshot doc;
  final Map<String, dynamic> data;
  final bool isQuick;

  const TaskDetailDialog({super.key, required this.doc, required this.data, required this.isQuick});

  @override
  Widget build(BuildContext context) {
    final title = data['title'] ?? '';
    final desc = data['description'] ?? '';
    final priority = data['priority'] ?? '';
    final status = data['status'] ?? (isQuick ? 'Pending' : 'Pending');
    final category = data['category'] ?? '';
    final date = data['date'] != null ? data['date'].toString() : '';

    return AlertDialog(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (desc.isNotEmpty) ...[
              Text(desc),
              const SizedBox(height: 12),
            ],
            Wrap(
              spacing: 8,
              children: [
                Chip(label: Text('Priority: $priority')),
                Chip(label: Text('Status: $status')),
                if (category.isNotEmpty) Chip(label: Text('Category: $category')),
              ],
            ),
            const SizedBox(height: 12),
            if (date.isNotEmpty) Text('Date: ${date.split('T').first}'),

            const SizedBox(height: 16),
            // Action icons below details: Complete and Missed with labels
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    IconButton(
                      tooltip: 'Mark complete',
                      iconSize: 36,
                      color: Colors.green,
                      icon: const Icon(Icons.check_circle),
                      onPressed: () async {
                        await doc.reference.update({'status': 'Done'});
                        if (context.mounted) {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Task marked complete')));
                        }
                      },
                    ),
                    const SizedBox(height: 4),
                    const Text('Completed', style: TextStyle(fontSize: 12)),
                  ],
                ),
                const SizedBox(width: 40),
                Column(
                  children: [
                    IconButton(
                      tooltip: 'Mark missed',
                      iconSize: 36,
                      color: Colors.red,
                      icon: const Icon(Icons.cancel),
                      onPressed: () async {
                        await doc.reference.update({'status': 'Overdue'});
                        if (context.mounted) {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Task marked missed')));
                        }
                      },
                    ),
                    const SizedBox(height: 4),
                    const Text('Missed', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

/// Quick Add Dialog
class QuickAddDialog extends StatelessWidget {
  const QuickAddDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _quickTaskController = TextEditingController();

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: const Text(
        "Quick Add Task",
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      content: TextField(
        controller: _quickTaskController,
        decoration: InputDecoration(
          hintText: "Enter task name",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_quickTaskController.text.trim().isNotEmpty) {
              await FirebaseFirestore.instance.collection("quicktask").add({
                "title": _quickTaskController.text.trim(),
                "createdAt": FieldValue.serverTimestamp(),
              });
            }
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple.shade300,
          ),
          child: const Text("Add"),
        ),
      ],
    );
  }
}

/// Edit Quick Task Dialog
class EditQuickTaskDialog extends StatelessWidget {
  final String id;
  final String currentTitle;
  const EditQuickTaskDialog({
    super.key,
    required this.id,
    required this.currentTitle,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController _editController =
        TextEditingController(text: currentTitle);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: const Text(
        "Edit Quick Task",
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      content: TextField(
        controller: _editController,
        decoration: InputDecoration(
          hintText: "Enter task name",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () async {
            await FirebaseFirestore.instance
                .collection("quicktask")
                .doc(id)
                .update({"title": _editController.text.trim()});
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple.shade300,
          ),
          child: const Text("Update"),
        ),
      ],
    );
  }
}

/// Search Delegate
class TaskSearchDelegate extends SearchDelegate {
  Future<List<Map<String, dynamic>>> _fetchAllTasks() async {
    final tasksSnap = await FirebaseFirestore.instance.collection('tasks').get();
    final quickSnap = await FirebaseFirestore.instance.collection('quicktask').get();

    final allDocs = [...tasksSnap.docs, ...quickSnap.docs];

    return allDocs.map((d) {
      final data = d.data();
      return {
        'id': d.id,
        'title': (data['title'] ?? '').toString(),
        'description': (data['description'] ?? '').toString(),
        'isQuick': d.reference.parent.id == 'quicktask',
      };
    }).toList();
  }

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchAllTasks(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snap.hasData || snap.data!.isEmpty) {
          return Center(child: Text('No tasks available'));
        }

        final results = snap.data!
            .where((t) {
              final combined = (t['title'] as String) + '\n' + (t['description'] as String);
              return combined.toLowerCase().contains(query.toLowerCase());
            })
            .toList();

        if (results.isEmpty) {
          return Center(child: Text('No results for "${query}"'));
        }

        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final item = results[index];
            return ListTile(
              title: Text(item['title']),
              subtitle: (item['description'] as String).isNotEmpty ? Text(item['description']) : null,
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchAllTasks(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snap.hasData || snap.data!.isEmpty) {
          return Center(child: Text('No tasks available'));
        }

        final data = snap.data!;

        final suggestions = query.trim().isEmpty
            ? data.take(10).toList()
            : data
                .where((t) => ((t['title'] as String) + (t['description'] as String))
                    .toLowerCase()
                    .contains(query.toLowerCase()))
                .toList();

        if (suggestions.isEmpty) {
          return Center(child: Text('No suggestions'));
        }

        return ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            final s = suggestions[index];
            return ListTile(
              title: Text(s['title']),
              subtitle: (s['description'] as String).isNotEmpty ? Text(s['description']) : null,
              onTap: () {
                query = s['title'];
                showResults(context);
              },
            );
          },
        );
      },
    );
  }
}
