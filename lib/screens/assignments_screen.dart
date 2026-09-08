import 'package:flutter/material.dart';
import '../data/assignment_store.dart';
import 'add_assignment_screen.dart';
import 'assignment_details_screen.dart';

class AssignmentsScreen extends StatefulWidget {
  const AssignmentsScreen({super.key});

  @override
  State<AssignmentsScreen> createState() =>
      _AssignmentsScreenState();
}

class _AssignmentsScreenState
    extends State<AssignmentsScreen> {
  int selectedTab = 0;

  Future<void> _openAddAssignment() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const AddAssignmentScreen(),
      ),
    );

    if (result != null &&
        result is Map<String, String>) {
      setState(() {
        AssignmentStore.assignments.add(result);
      });
    }
  }

  Future<void> _openAssignmentDetails(
    Map<String, String> assignment,
  ) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AssignmentDetailsScreen(
          assignment: assignment,
        ),
      ),
    );

    if (result != null && result is Map) {
      if (result['action'] == 'delete') {
        setState(() {
          AssignmentStore.assignments.remove(
            assignment,
          );
        });
      }

      if (result['action'] == 'completed') {
        setState(() {
          assignment['status'] = 'Done';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF4F46E5);
    const background = Color(0xFFF8FAFC);

    final tabs = [
      'All',
      'Pending',
      'In Progress',
      'Done',
    ];

    final filteredAssignments =
        selectedTab == 0
            ? AssignmentStore.assignments
            : AssignmentStore.assignments
                .where(
                  (assignment) =>
                      assignment['status'] ==
                      tabs[selectedTab],
                )
                .toList();

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Assignments',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(
              Icons.sort,
              size: 18,
            ),
            label: const Text('Sort'),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: Row(
              children:
                  List.generate(
                tabs.length,
                (index) {
                  final selected =
                      selectedTab == index;

                  return Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedTab = index;
                        });
                      },
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                        decoration:
                            BoxDecoration(
                          border: Border(
                            bottom:
                                BorderSide(
                              color: selected
                                  ? primary
                                  : Colors
                                      .transparent,
                              width: 3,
                            ),
                          ),
                        ),
                        child: Text(
                          tabs[index],
                          textAlign:
                              TextAlign.center,
                          style:
                              TextStyle(
                            fontSize: 12,
                            fontWeight:
                                selected
                                    ? FontWeight
                                        .bold
                                    : FontWeight
                                        .w500,
                            color: selected
                                ? primary
                                : const Color(
                                    0xFF64748B,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          Expanded(
            child:
                filteredAssignments.isEmpty
                    ? const Center(
                        child: Text(
                          'No assignments found.',
                        ),
                      )
                    : ListView.separated(
                        padding:
                            const EdgeInsets
                                .symmetric(
                          vertical: 8,
                        ),
                        itemCount:
                            filteredAssignments
                                .length,
                        separatorBuilder:
                            (_, __) =>
                                const SizedBox(
                                  height: 1,
                                ),
                        itemBuilder:
                            (context, index) {
                          final assignment =
                              filteredAssignments[
                                  index];

                          return _assignmentCard(
                            assignment,
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton:
          FloatingActionButton(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        onPressed: _openAddAssignment,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _assignmentCard(
    Map<String, String> assignment,
  ) {
    final priority =
        assignment['priority']!;

    Color priorityColor;
    Color priorityBackground;

    if (priority == 'HIGH') {
      priorityColor =
          const Color(0xFFDC2626);
      priorityBackground =
          const Color(0xFFFEF2F2);
    } else if (priority == 'MED') {
      priorityColor =
          const Color(0xFFEA580C);
      priorityBackground =
          const Color(0xFFFFF7ED);
    } else {
      priorityColor =
          const Color(0xFF16A34A);
      priorityBackground =
          const Color(0xFFDCFCE7);
    }

    final completed =
        assignment['status'] == 'Done';

    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          _openAssignmentDetails(
            assignment,
          );
        },
        child: Padding(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      assignment['title']!,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight:
                            FontWeight.w600,
                        color: const Color(
                          0xFF1E293B,
                        ),
                        decoration: completed
                            ? TextDecoration
                                .lineThrough
                            : null,
                      ),
                    ),

                    const SizedBox(
                      height: 4,
                    ),

                    Text(
                      assignment['subject']!,
                      style:
                          const TextStyle(
                        fontSize: 12,
                        color: Color(
                          0xFF64748B,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 9,
                    ),

                    Row(
                      children: [
                        Container(
                          padding:
                              const EdgeInsets
                                  .symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration:
                              BoxDecoration(
                            color:
                                priorityBackground,
                            borderRadius:
                                BorderRadius
                                    .circular(
                              6,
                            ),
                          ),
                          child: Text(
                            priority,
                            style:
                                TextStyle(
                              fontSize: 10,
                              fontWeight:
                                  FontWeight
                                      .bold,
                              color:
                                  priorityColor,
                            ),
                          ),
                        ),

                        const SizedBox(
                          width: 10,
                        ),

                        Icon(
                          completed
                              ? Icons
                                  .check_circle
                              : assignment[
                                          'status'] ==
                                      'In Progress'
                                  ? Icons
                                      .timelapse
                                  : Icons.circle,
                          size: 12,
                          color: completed
                              ? const Color(
                                  0xFF16A34A,
                                )
                              : const Color(
                                  0xFF94A3B8,
                                ),
                        ),

                        const SizedBox(
                          width: 4,
                        ),

                        Text(
                          assignment['status']!,
                          style:
                              const TextStyle(
                            fontSize: 11,
                            color: Color(
                              0xFF64748B,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Text(
                'Due ${assignment['due']}',
                style:
                    const TextStyle(
                  fontSize: 11,
                  color:
                      Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}