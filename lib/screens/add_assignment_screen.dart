import 'package:flutter/material.dart';

class AddAssignmentScreen extends StatefulWidget {
  const AddAssignmentScreen({super.key});

  @override
  State<AddAssignmentScreen> createState() =>
      _AddAssignmentScreenState();
}

class _AddAssignmentScreenState
    extends State<AddAssignmentScreen> {
  final titleController = TextEditingController();
  final subjectController = TextEditingController();
  final descriptionController = TextEditingController();

  DateTime? selectedDate;
  String selectedPriority = 'MED';

  static const primary = Color(0xFF4F46E5);
  static const background = Color(0xFFF8FAFC);
  static const navy = Color(0xFF1E293B);
  static const secondary = Color(0xFF64748B);
  static const border = Color(0xFFE2E8F0);

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  void _saveAssignment() {
    if (titleController.text.trim().isEmpty ||
        subjectController.text.trim().isEmpty ||
        selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter title, subject and due date.',
          ),
        ),
      );
      return;
    }

    final newAssignment = {
      'title': titleController.text.trim(),
      'subject': subjectController.text.trim(),
      'due':
          '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
      'priority': selectedPriority,
      'status': 'Pending',
      'description': descriptionController.text.trim(),
    };

    Navigator.pop(context, newAssignment);
  }

  @override
  void dispose() {
    titleController.dispose();
    subjectController.dispose();
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
          'Add Assignment',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: navy,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _saveAssignment,
            child: const Text(
              'Save',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label('Assignment Title'),
            TextField(
              controller: titleController,
              decoration: _inputDecoration(
                'Enter assignment title',
              ),
            ),

            const SizedBox(height: 18),

            _label('Subject / Course'),
            TextField(
              controller: subjectController,
              decoration: _inputDecoration(
                'Enter subject or course',
              ),
            ),

            const SizedBox(height: 18),

            _label('Due Date'),
            InkWell(
              onTap: _selectDate,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 52,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: border),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_month_outlined,
                      color: secondary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        selectedDate == null
                            ? 'Select due date'
                            : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                        style: TextStyle(
                          color: selectedDate == null
                              ? secondary
                              : navy,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            _label('Priority'),

            Row(
              children: [
                Expanded(
                  child: _priorityButton(
                    'HIGH',
                    const Color(0xFFDC2626),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _priorityButton(
                    'MED',
                    const Color(0xFFEA580C),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _priorityButton(
                    'LOW',
                    const Color(0xFF16A34A),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            _label('Description'),

            TextField(
              controller: descriptionController,
              maxLines: 5,
              decoration: _inputDecoration(
                'Enter assignment description',
              ),
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _saveAssignment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save Assignment',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _priorityButton(
    String priority,
    Color color,
  ) {
    final selected = selectedPriority == priority;

    return InkWell(
      onTap: () {
        setState(() {
          selectedPriority = priority;
        });
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: selected
              ? color.withValues(alpha: 0.12)
              : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? color : border,
            width: selected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            priority,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: selected ? color : secondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: navy,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(
    String hint,
  ) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: secondary,
        fontSize: 13,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 15,
      ),
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