import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ProjectSchedulePage extends StatefulWidget {
  const ProjectSchedulePage({super.key});

  @override
  State<ProjectSchedulePage> createState() => _ProjectSchedulePageState();
}

class _ProjectSchedulePageState extends State<ProjectSchedulePage> {
  // 프로젝트별 일정 데이터를 관리할 Map
  final Map<String, Map<DateTime, List<Map<String, dynamic>>>> _projectEvents = {
    '프로젝트1': {},
    '프로젝트2': {},
    '프로젝트3': {},
    '프로젝트4': {},
  };

  String _selectedProject = '프로젝트1'; // 선택된 프로젝트
  DateTime _selectedDate = DateTime.now(); // 선택된 날짜
  final TextEditingController _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 드롭다운 메뉴로 프로젝트 선택
            DropdownButton<String>(
              value: _selectedProject,
              underline: Container(),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
              items: _projectEvents.keys.map((project) {
                return DropdownMenuItem(
                  value: project,
                  child: Text(
                    project,
                    style: const TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedProject = value!;
                });
              },
            ),
            Row(
              children: const [
                Icon(Icons.notifications_outlined, color: Colors.black),
                SizedBox(width: 16),
                Icon(Icons.settings_outlined, color: Colors.black),
              ],
            ),
          ],
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          // 캘린더 뷰
          Expanded(
            flex: 2,
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _selectedDate,
              selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDate = selectedDay;
                });
              },
              eventLoader: (day) {
                return _projectEvents[_selectedProject]?[day] ?? [];
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.deepOrange,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
                markerDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // 일정 목록
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '일정',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Column(
                          children: (_projectEvents[_selectedProject]?[_selectedDate] ?? []).map((event) {
                            return ListTile(
                              leading: const Icon(Icons.circle, color: Colors.blue, size: 16),
                              title: Text(event['title']),
                              subtitle: Text(event['time']),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 일정 추가 창 띄우기
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            builder: (BuildContext context) {
              return _buildScheduleBottomSheet();
            },
          );
        },
        backgroundColor: Colors.redAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // 일정 추가 창 UI
  Widget _buildScheduleBottomSheet() {
    String selectedTime = '시간 없음'; // 기본 시간
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 16,
        left: 16,
        right: 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '일정 추가',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: '제목 입력',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: '시간 입력 (예: 12:30 - 1:30 PM)',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                selectedTime = value;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _projectEvents[_selectedProject]?.putIfAbsent(_selectedDate, () => []);
                  _projectEvents[_selectedProject]?[_selectedDate]?.add({
                    'title': _titleController.text,
                    'time': selectedTime,
                  });
                  _titleController.clear();
                });
                Navigator.pop(context); // 창 닫기
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              child: const Text(
                '저장',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
