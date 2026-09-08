import 'package:flutter/material.dart';

class EditAssignmentScreen extends StatefulWidget {
  final Map<String, String> assignment;

  const EditAssignmentScreen({
    super.key,
    required this.assignment,
  });

  @override
  State<EditAssignmentScreen> createState() =>
      _EditAssignmentScreenState();
}

class _EditAssignmentScreenState
    extends State<EditAssignmentScreen> {
  late TextEditingController titleController;
  late TextEditingController subjectController;
  late TextEditingController dueController;
  late TextEditingController descriptionController;

  late String selectedPriority;
  late String selectedStatus;

  static const primary = Color(0xFF4F46E5);
  static const background = Color(0xFFF8FAFC);
  static const navy = Color(0xFF1E293B);
  static const border = Color(0xFFE2E8F0);

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(
      text: widget.assignment['title'] ?? '',
    );

    subjectController = TextEditingController(
      text: widget.assignment['subject'] ?? '',
    );

    dueController = TextEditingController(
      text: widget.assignment['due'] ?? '',
    );

    descriptionController = TextEditingController(
      text: widget.assignment['description'] ?? '',
    );

    selectedPriority =
        widget.assignment['priority'] ?? 'MED';

    selectedStatus =
        widget.assignment['status'] ?? 'Pending';
  }

  Future<void> _selectDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime(2035),
    );

    if (selectedDate != null) {
      setState(() {
        dueController.text =
            '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
      });
    }
  }

  void _saveChanges() {
    if (titleController.text.trim().isEmpty ||
        subjectController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter the assignment title and subject.',
          ),
        ),
      );
      return;
    }

    final updatedAssignment = <String, String>{
      'title': titleController.text.trim(),
      'subject': subjectController.text.trim(),
      'due': dueController.text.trim(),
      'priority': selectedPriority,
      'status': selectedStatus,
      'description': descriptionController.text.trim(),
    };

    Navigator.pop(
      context,
      updatedAssignment,
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    subjectController.dispose();
    dueController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text(
          'Edit Assignment',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: navy,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label('Assignment Title'),

            TextField(
              controller: titleController,
              decoration: _decoration(
                'Assignment title',
              ),
            ),

            const SizedBox(height: 18),

            _label('Subject'),

            TextField(
              controller: subjectController,
              decoration: _decoration(
                'Subject',
              ),
            ),

            const SizedBox(height: 18),

            _label('Due Date'),

            TextField(
              controller: dueController,
              readOnly: true,
              onTap: _selectDate,
              decoration: _decoration(
                'Select due date',
              ).copyWith(
                suffixIcon: const Icon(
                  Icons.calendar_month_outlined,
                ),
              ),
            ),

            const SizedBox(height: 18),

            _label('Priority'),

            Wrap(
              spacing: 8,
              children: [
                'HIGH',
                'MED',
                'LOW',
              ].map((priority) {
                return ChoiceChip(
                  label: Text(priority),
                  selected:
                      selectedPriority == priority,
                  onSelected: (_) {
                    setState(() {
                      selectedPriority = priority;
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 18),

            _label('Status'),

            DropdownButtonFormField<String>(
              initialValue: selectedStatus,
              decoration: _decoration(
                'Status',
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Pending',
                  child: Text('Pending'),
                ),
                DropdownMenuItem(
                  value: 'In Progress',
                  child: Text('In Progress'),
                ),
                DropdownMenuItem(
                  value: 'Done',
                  child: Text('Done'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedStatus = value;
                  });
                }
              },
            ),

            const SizedBox(height: 18),

            _label('Description'),

            TextField(
              controller: descriptionController,
              maxLines: 5,
              decoration: _decoration(
                'Assignment description',
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _saveChanges,
                icon: const Icon(
                  Icons.save_outlined,
                ),
                label: const Text(
                  'Save Changes',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 7,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: navy,
        ),
      ),
    );
  }

  InputDecoration _decoration(
    String hint,
  ) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: border,
        ),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: border,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: primary,
          width: 2,
        ),
      ),
    );
  }
}