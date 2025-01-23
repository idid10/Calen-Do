import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class WholeSchedulePage extends StatefulWidget {
  const WholeSchedulePage({super.key});

  @override
  State<WholeSchedulePage> createState() => _WholeSchedulePageState();
}

class _WholeSchedulePageState extends State<WholeSchedulePage> {
  // 일정과 To-do List 데이터를 관리할 Map
  final Map<DateTime, List<Map<String, dynamic>>> _events = {};
  final Map<DateTime, List<Map<String, dynamic>>> _todoLists = {};
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
            Row(
              children: const [
                Icon(Icons.person, color: Colors.black),
                SizedBox(width: 8),
                Text(
                  '사용자의 일정',
                  style: TextStyle(color: Colors.black),
                ),
              ],
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
              eventLoader: (day) {
                final events = _events[day] ?? [];
                final todos = _todoLists[day] ?? [];
                return events + todos;
              },
            ),
          ),
          // 일정 표시 및 To-do List
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 일정 목록
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
                          children: (_events[_selectedDate] ?? []).map((event) {
                            return ListTile(
                              leading: const Icon(Icons.circle, color: Colors.blue, size: 16),
                              title: Text(event['title']),
                              subtitle: Text(event['time']),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _confirmDelete(event, isTodo: false),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  // To-do List
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'To-do List',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Column(
                          children: (_todoLists[_selectedDate] ?? []).map((todo) {
                            return Row(
                              children: [
                                Checkbox(
                                  value: todo['completed'],
                                  onChanged: (value) {
                                    setState(() {
                                      todo['completed'] = value!;
                                    });
                                  },
                                ),
                                Expanded(child: Text(todo['title'])),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _confirmDelete(todo, isTodo: true),
                                ),
                              ],
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

  // 일정 삭제 확인 다이얼로그
  void _confirmDelete(Map<String, dynamic> item, {required bool isTodo}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('일정을 삭제하시겠습니까?'),
          content: Text('"${item['title']}" 일정을 삭제하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 다이얼로그 닫기
              },
              child: const Text('아니요'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  if (isTodo) {
                    _todoLists[_selectedDate]?.remove(item);
                  } else {
                    _events[_selectedDate]?.remove(item);
                  }
                });
                Navigator.pop(context); // 다이얼로그 닫기
              },
              child: const Text('예', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // 일정 추가 창 UI
  Widget _buildScheduleBottomSheet() {
    String selectedType = 'Schedule'; // 기본 일정 타입
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
            DropdownButtonFormField<String>(
              value: selectedType,
              decoration: const InputDecoration(labelText: '유형 선택'),
              items: ['Schedule', 'To-do']
                  .map((type) => DropdownMenuItem(
                value: type,
                child: Text(type),
              ))
                  .toList(),
              onChanged: (value) {
                selectedType = value!;
              },
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
                  if (selectedType == 'Schedule') {
                    _events.putIfAbsent(_selectedDate, () => []);
                    _events[_selectedDate]?.add({
                      'title': _titleController.text,
                      'type': 'Schedule',
                      'time': selectedTime,
                    });
                  } else {
                    _todoLists.putIfAbsent(_selectedDate, () => []);
                    _todoLists[_selectedDate]?.add({
                      'title': _titleController.text,
                      'completed': false,
                    });
                  }
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








