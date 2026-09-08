import 'package:flutter/material.dart';
import 'edit_assignment_screen.dart';

class AssignmentDetailsScreen extends StatefulWidget {
  final Map<String, String> assignment;

  const AssignmentDetailsScreen({
    super.key,
    required this.assignment,
  });

  @override
  State<AssignmentDetailsScreen> createState() =>
      _AssignmentDetailsScreenState();
}

class _AssignmentDetailsScreenState
    extends State<AssignmentDetailsScreen> {
  static const primary = Color(0xFF4F46E5);
  static const background = Color(0xFFF8FAFC);
  static const navy = Color(0xFF1E293B);
  static const muted = Color(0xFF64748B);
  static const border = Color(0xFFE2E8F0);

  Future<void> _editAssignment() async {
    final updatedAssignment =
        await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(
        builder: (_) => EditAssignmentScreen(
          assignment: widget.assignment,
        ),
      ),
    );

    if (updatedAssignment != null) {
      setState(() {
        widget.assignment.clear();
        widget.assignment.addAll(updatedAssignment);
      });
    }
  }

  Future<void> _deleteAssignment() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Assignment'),
          content: const Text(
            'Are you sure you want to delete this assignment?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true && mounted) {
      Navigator.pop(
        context,
        <String, String>{
          'action': 'delete',
        },
      );
    }
  }

  void _markComplete() {
    setState(() {
      widget.assignment['status'] = 'Done';
    });

    Navigator.pop(
      context,
      <String, String>{
        'action': 'completed',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final assignment = widget.assignment;

    final priority = assignment['priority'] ?? 'MED';
    final status = assignment['status'] ?? 'Pending';

    Color priorityColor;

    if (priority == 'HIGH') {
      priorityColor = Colors.red;
    } else if (priority == 'LOW') {
      priorityColor = Colors.green;
    } else {
      priorityColor = Colors.orange;
    }

    final bool completed = status == 'Done';

    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text(
          'Assignment Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: navy,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: _editAssignment,
            icon: const Icon(
              Icons.edit_outlined,
              size: 19,
            ),
            label: const Text('Edit'),
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: border,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          assignment['title'] ??
                              'Assignment',
                          style: const TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            color: navy,
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: priorityColor
                              .withValues(alpha: 0.10),
                          borderRadius:
                              BorderRadius.circular(20),
                        ),
                        child: Text(
                          priority,
                          style: TextStyle(
                            color: priorityColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Text(
                    assignment['subject'] ??
                        'No subject',
                    style: const TextStyle(
                      color: muted,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _infoCard(
                    Icons.calendar_month_outlined,
                    'Due Date',
                    assignment['due'] ?? 'Not set',
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _infoCard(
                    completed
                        ? Icons.check_circle_outline
                        : Icons.schedule_outlined,
                    'Status',
                    status,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: border,
                ),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Progress',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: navy,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value:
                              completed ? 1.0 : 0.6,
                          minHeight: 8,
                          borderRadius:
                              BorderRadius.circular(10),
                          backgroundColor:
                              const Color(0xFFE2E8F0),
                          color: completed
                              ? Colors.green
                              : primary,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Text(
                        completed ? '100%' : '60%',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: navy,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: border,
                ),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: navy,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    assignment['description']
                                ?.trim()
                                .isNotEmpty ==
                            true
                        ? assignment['description']!
                        : 'No description added.',
                    style: const TextStyle(
                      color: muted,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _deleteAssignment,
                    icon: const Icon(
                      Icons.delete_outline,
                    ),
                    label: const Text(
                      'Delete',
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(
                        color: Colors.red,
                      ),
                      minimumSize:
                          const Size(0, 52),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed:
                        completed ? null : _markComplete,
                    icon: Icon(
                      completed
                          ? Icons.check_circle
                          : Icons.check_circle_outline,
                    ),
                    label: Text(
                      completed
                          ? 'Completed'
                          : 'Mark Complete',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      minimumSize:
                          const Size(0, 52),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(
    IconData icon,
    String label,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: primary,
            size: 22,
          ),

          const SizedBox(height: 10),

          Text(
            label,
            style: const TextStyle(
              color: muted,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            value,
            style: const TextStyle(
              color: navy,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}