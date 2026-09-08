import 'package:flutter/material.dart';
import 'screens/assignments_screen.dart';
import 'screens/study_tasks_screen.dart';

void main() {
  runApp(const StudyMateApp());
}

class StudyMateApp extends StatelessWidget {
  const StudyMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StudyMate',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F46E5),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const primary = Color(0xFF4F46E5);
  static const primaryLight = Color(0xFFEEF2FF);
  static const background = Color(0xFFF8FAFC);
  static const navy = Color(0xFF1E293B);
  static const secondary = Color(0xFF64748B);
  static const muted = Color(0xFF94A3B8);
  static const border = Color(0xFFE2E8F0);
  static const orange = Color(0xFFEA580C);
  static const red = Color(0xFFDC2626);

  void _openAssignments(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AssignmentsScreen(),
      ),
    );
  }

  void _openTasks(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const StudyTasksScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Column(
          children: [
            _topHeader(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _summaryCards(),

                    const SizedBox(height: 14),

                    _quickActions(context),

                    const SizedBox(height: 14),

                    _sectionHeader(
                      title: 'Upcoming Deadlines',
                      actionText: 'See all',
                      onTap: () {
                        _openAssignments(context);
                      },
                    ),

                    const SizedBox(height: 8),

                    _deadlineCard(
                      title: 'Research Essay',
                      subject: 'HIST201',
                      due: 'Due Aug 8',
                      priority: 'High priority',
                      priorityColor: red,
                    ),

                    _deadlineCard(
                      title: 'Lab Report',
                      subject: 'CHEM102',
                      due: 'Due Aug 10',
                      priority: 'Medium priority',
                      priorityColor: orange,
                    ),

                    _deadlineCard(
                      title: 'Group Project',
                      subject: 'BUS305',
                      due: 'Due Aug 12',
                      priority: 'Medium priority',
                      priorityColor: orange,
                    ),

                    const SizedBox(height: 16),

                    _sectionHeader(
                      title: "Today's Classes",
                      actionText: 'Full timetable',
                      onTap: () {},
                    ),

                    const SizedBox(height: 8),

                    _classCard(
                      subject: 'Mathematics 301',
                      location: 'Room B204',
                      time: '9:00–10:30am',
                    ),

                    _classCard(
                      subject: 'History 201',
                      location: 'Room A101',
                      time: '1:00–2:30pm',
                    ),

                    const SizedBox(height: 18),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        indicatorColor: primaryLight,
        onDestinationSelected: (index) {
          if (index == 1) {
            _openTasks(context);
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.task_alt_outlined),
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

  Widget _topHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: border,
          ),
        ),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good morning,',
                  style: TextStyle(
                    fontSize: 12,
                    color: muted,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Mahammad Kaif',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: navy,
                  ),
                ),
              ],
            ),
          ),

          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.notifications_none,
              color: navy,
              size: 21,
            ),
          ),

          const SizedBox(width: 10),

          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Text(
                'MK',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCards() {
    return Row(
      children: [
        Expanded(
          child: _summaryCard(
            value: '4',
            label: 'Due Soon',
            icon: Icons.assignment_late_outlined,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _summaryCard(
            value: '2',
            label: 'Exams',
            icon: Icons.school_outlined,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _summaryCard(
            value: '7',
            label: 'Tasks',
            icon: Icons.task_alt_outlined,
          ),
        ),
      ],
    );
  }

  Widget _summaryCard({
    required String value,
    required String label,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 14,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: border,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: primary,
            size: 21,
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: navy,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: navy,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _quickActionButton(
                  icon: Icons.add_task,
                  label: 'Assignment',
                  onTap: () {
                    _openAssignments(context);
                  },
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: _quickActionButton(
                  icon: Icons.school_outlined,
                  label: 'Exam',
                  onTap: () {},
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: _quickActionButton(
                  icon: Icons.task_alt_outlined,
                  label: 'Task',
                  onTap: () {
                    _openTasks(context);
                  },
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: _quickActionButton(
                  icon: Icons.calendar_view_week_outlined,
                  label: 'Timetable',
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 4,
        ),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: border,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 19,
              color: primary,
            ),
            const SizedBox(height: 5),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: navy,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader({
    required String title,
    required String actionText,
    required VoidCallback onTap,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: navy,
            ),
          ),
        ),
        TextButton(
          onPressed: onTap,
          child: Text(
            actionText,
            style: const TextStyle(
              fontSize: 12,
              color: primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _deadlineCard({
    required String title,
    required String subject,
    required String due,
    required String priority,
    required Color priorityColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: priorityColor,
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$title — $subject',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: navy,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  priority,
                  style: TextStyle(
                    fontSize: 11,
                    color: priorityColor,
                  ),
                ),
              ],
            ),
          ),

          Text(
            due,
            style: const TextStyle(
              fontSize: 11,
              color: secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _classCard({
    required String subject,
    required String location,
    required String time,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.menu_book_outlined,
              size: 18,
              color: primary,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: navy,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '$location • $time',
                  style: const TextStyle(
                    fontSize: 11,
                    color: secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}