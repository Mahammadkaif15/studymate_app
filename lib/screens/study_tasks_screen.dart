import 'package:flutter/material.dart';
import '../data/task_store.dart';
import 'add_task_screen.dart';

class StudyTasksScreen extends StatefulWidget {
  const StudyTasksScreen({super.key});

  @override
  State<StudyTasksScreen> createState() =>
      _StudyTasksScreenState();
}

class _StudyTasksScreenState extends State<StudyTasksScreen> {
  String selectedFilter = 'All';

  static const primary = Color(0xFF4F46E5);
  static const background = Color(0xFFF8FAFC);
  static const navy = Color(0xFF1E293B);
  static const secondary = Color(0xFF64748B);
  static const muted = Color(0xFF94A3B8);
  static const border = Color(0xFFE2E8F0);
  static const green = Color(0xFF16A34A);
  static const greenLight = Color(0xFFDCFCE7);
  static const amber = Color(0xFFD97706);
  static const amberLight = Color(0xFFFFFBEB);
  static const primaryLight = Color(0xFFEEF2FF);

  Future<void> _openAddTask() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddTaskScreen(),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        TaskStore.tasks.add(result);
      });
    }
  }

  String _todayStorageDate() {
    final now = DateTime.now();
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');

    return '${now.year}-$month-$day';
  }

  @override
  Widget build(BuildContext context) {
    final completedCount =
        TaskStore.tasks.where((task) => task['completed'] == true).length;

    final pendingCount = TaskStore.tasks.length - completedCount;

    List<Map<String, dynamic>> filteredTasks;

    if (selectedFilter == 'All') {
      filteredTasks = TaskStore.tasks;
    } else if (selectedFilter == 'Today') {
      final today = _todayStorageDate();

      filteredTasks = TaskStore.tasks
          .where(
            (task) => task['date'] == today,
          )
          .toList();
    } else {
      filteredTasks = TaskStore.tasks
          .where(
            (task) => task['category'] == selectedFilter,
          )
          .toList();
    }

    final progress = TaskStore.tasks.isEmpty
        ? 0.0
        : completedCount / TaskStore.tasks.length;

    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor: background,
        surfaceTintColor: background,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Study Tasks',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: navy,
              ),
            ),
            Text(
              'Stay on top of your study plan',
              style: TextStyle(
                fontSize: 12,
                color: secondary,
              ),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: border),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          "Today's Progress",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: navy,
                          ),
                        ),
                      ),
                      Text(
                        '$completedCount / ${TaskStore.tasks.length}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: primary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(10),
                    backgroundColor: border,
                    color: green,
                  ),

                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Expanded(
                        child: _statCard(
                          '$completedCount',
                          'Completed',
                          green,
                          greenLight,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _statCard(
                          '$pendingCount',
                          'Pending',
                          amber,
                          amberLight,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _statCard(
                          '${TaskStore.tasks.length}',
                          'Total',
                          primary,
                          primaryLight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                'All',
                'Today',
                'Study',
                'Revision',
                'Research',
              ].map((filter) {
                final selected = selectedFilter == filter;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: selected,
                    onSelected: (_) {
                      setState(() {
                        selectedFilter = filter;
                      });
                    },
                    selectedColor: primary,
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: filteredTasks.isEmpty
                ? const Center(
                    child: Text(
                      'No tasks found.',
                      style: TextStyle(
                        color: secondary,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      8,
                      16,
                      90,
                    ),
                    itemCount: filteredTasks.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];

                      return _taskCard(task);
                    },
                  ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddTask,
        backgroundColor: primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text(
          'New Task',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: 1,
        indicatorColor: primaryLight,
        onDestinationSelected: (index) {
          if (index == 0) {
            Navigator.pop(context);
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.task_alt_outlined),
            selectedIcon: Icon(Icons.task_alt),
            label: 'Tasks',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Calendar',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _taskCard(Map<String, dynamic> task) {
    final completed = task['completed'] == true;
    final priority = task['priority'];

    Color priorityColor;

    if (priority == 'HIGH') {
      priorityColor = const Color(0xFFDC2626);
    } else if (priority == 'MEDIUM') {
      priorityColor = const Color(0xFFEA580C);
    } else {
      priorityColor = green;
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                task['completed'] = !completed;
              });
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: completed ? green : Colors.transparent,
                border: Border.all(
                  color: completed ? green : primary,
                  width: 2,
                ),
              ),
              child: completed
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    )
                  : null,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task['title'],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: completed ? muted : navy,
                    decoration:
                        completed ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${task['subject']} · ${task['duration']}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: muted,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: priorityColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              priority,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: priorityColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(
    String number,
    String label,
    Color color,
    Color bgColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            number,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}