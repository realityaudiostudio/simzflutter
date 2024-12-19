import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:simz_academy/views/UIHelper/home_ui_helper.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:simz_academy/models/attendance_model/student_attendance_model.dart';

class StudentAttendanceScreen extends StatefulWidget {
  const StudentAttendanceScreen({super.key});

  @override
  State<StudentAttendanceScreen> createState() =>
      _StudentAttendanceScreenState();
}

class _StudentAttendanceScreenState extends State<StudentAttendanceScreen> {
  final StudentAttendanceModel _attendanceModel = StudentAttendanceModel();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _loadAttendance();
  }

  Future<void> _loadAttendance() async {
    await _attendanceModel.getAttendance();
    setState(() {}); // Trigger rebuild after loading attendance
  }

  // Helper function to check if a day is in attendance
  bool _isDayPresent(DateTime day) {
    return _attendanceModel.attendance
        .any((attendanceDay) => isSameDay(attendanceDay, day));
  }

  bool _isDayAbsent(DateTime day) {
    return _attendanceModel.absentDates
        .any((attendanceDay) => isSameDay(attendanceDay, day));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Iconsax.arrow_square_left,
            color: Color.fromRGBO(56, 15, 67, 1),
          ),
        ),
        title: HomeUiHelper().customText(
          'Attendance Calendar',
          24,
          FontWeight.w400,
          Color(0xFF380F43),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2050, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: const TextStyle(
                color: Color(0xFF5B2867),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              leftChevronIcon: Icon(
                Iconsax.arrow_left_1,
                color: Color(0xFF380F43),
              ),
              rightChevronIcon: Icon(
                Iconsax.arrow_right_4,
                color: Color(0xFF380F43),
              ),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: const TextStyle(
                color: Color(0xFFCD8CE6),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              weekendStyle: const TextStyle(
                color: Color(0xFFCD8CE6),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            calendarStyle: CalendarStyle(
              // Customize the appearance of present days
              defaultTextStyle: const TextStyle(color: Color(0xFFCD8CE6), fontSize: 14, fontWeight: FontWeight.w600),
              weekendTextStyle: const TextStyle(color: Color(0xFFF7727B),fontSize: 14, fontWeight: FontWeight.w600),
              todayDecoration: BoxDecoration(
                color: Colors.blue.shade200,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.blue.shade500,
                shape: BoxShape.circle,
              ),
            ),
            // Custom builder to highlight present days
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                if (_isDayPresent(day)) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.green.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${day.day}',
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  );
                } else if (_isDayAbsent(day)) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.red.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${day.day}',
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  );
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Total Present Days: ${_attendanceModel.attendance.length}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(
                0xff2d6e39),),
          ),
          Text(
            'Total Absent Days: ${_attendanceModel.absentDates.length}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(
                0xffd93535),),
          ),
        ],
      ),
    );
  }
}
