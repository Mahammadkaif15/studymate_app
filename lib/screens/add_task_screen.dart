import 'package:flutter/material.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final titleController = TextEditingController();
  final subjectController = TextEditingController();

  String selectedPriority = 'MEDIUM';
  String selectedCategory = 'Study';
  String selectedDuration = '30 min';

  DateTime selectedDate = DateTime.now();

  static const primary = Color(0xFF4F46E5);
  static const background = Color(0xFFF8FAFC);
  static const navy = Color(0xFF1E293B);
  static const muted = Color(0xFF64748B);
  static const border = Color(0xFFE2E8F0);

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2025),
      lastDate: DateTime(2035),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  String _formattedDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _storageDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '${date.year}-$month-$day';
  }

  void _saveTask() {
    if (titleController.text.trim().isEmpty ||
        subjectController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter the task title and subject.',
          ),
        ),
      );
      return;
    }

    final newTask = <String, dynamic>{
      'title': titleController.text.trim(),
      'subject': subjectController.text.trim(),
      'duration': selectedDuration,
      'priority': selectedPriority,
      'category': selectedCategory,
      'date': _storageDate(selectedDate),
      'completed': false,
    };

    Navigator.pop(context, newTask);
  }

  @override
  void dispose() {
    titleController.dispose();
    subjectController.dispose();
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
          'New Study Task',
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
            _label('Task Title'),

            TextField(
              controller: titleController,
              decoration: _decoration(
                'e.g. Review Chapter 7',
              ),
            ),

            const SizedBox(height: 18),

            _label('Subject'),

            TextField(
              controller: subjectController,
              decoration: _decoration(
                'e.g. Chemistry',
              ),
            ),

            const SizedBox(height: 18),

            _label('Task Date'),

            InkWell(
              onTap: _selectDate,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: border),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_month_outlined,
                      color: primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _formattedDate(selectedDate),
                        style: const TextStyle(
                          color: navy,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      color: muted,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            _label('Duration'),

            DropdownButtonFormField<String>(
              initialValue: selectedDuration,
              decoration: _decoration('Duration'),
              items: const [
                DropdownMenuItem(
                  value: '20 min',
                  child: Text('20 min'),
                ),
                DropdownMenuItem(
                  value: '30 min',
                  child: Text('30 min'),
                ),
                DropdownMenuItem(
                  value: '45 min',
                  child: Text('45 min'),
                ),
                DropdownMenuItem(
                  value: '1 hr',
                  child: Text('1 hr'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedDuration = value;
                  });
                }
              },
            ),

            const SizedBox(height: 18),

            _label('Priority'),

            Wrap(
              spacing: 8,
              children: [
                'HIGH',
                'MEDIUM',
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

            _label('Category'),

            Wrap(
              spacing: 8,
              children: [
                'Study',
                'Revision',
                'Research',
              ].map((category) {
                return ChoiceChip(
                  label: Text(category),
                  selected:
                      selectedCategory == category,
                  onSelected: (_) {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _saveTask,
                icon: const Icon(
                  Icons.add_task_outlined,
                ),
                label: const Text(
                  'Save Task',
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
      padding: const EdgeInsets.only(bottom: 7),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: navy,
        ),
      ),
    );
  }

  InputDecoration _decoration(String hint) {
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