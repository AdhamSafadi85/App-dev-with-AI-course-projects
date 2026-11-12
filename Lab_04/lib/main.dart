import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ציונים',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // Force right-to-left layout for Hebrew.
      builder: (context, child) =>
          Directionality(textDirection: TextDirection.rtl, child: child!),
      home: const GradesPage(),
    );
  }
}

class Student {
  Student(this.name, this.grade);

  final String name;
  int grade;
}

class GradesPage extends StatefulWidget {
  const GradesPage({super.key});

  @override
  State<GradesPage> createState() => _GradesPageState();
}

class _GradesPageState extends State<GradesPage> {
  static const int passingGrade = 56;

  final List<Student> _students = [
    Student('נועה', 92),
    Student('דנה', 71),
    Student('יוסף', 54),
    Student('עומר', 48),
  ];

  bool _sortDescending = true;

  double get _average => _students.isEmpty
      ? 0
      : _students.map((s) => s.grade).reduce((a, b) => a + b) /
          _students.length;

  void _changeGrade(Student student, int delta) {
    setState(() {
      student.grade = (student.grade + delta).clamp(0, 100);
    });
  }

  void _sort() {
    setState(() {
      _students.sort(
        (a, b) => _sortDescending
            ? b.grade.compareTo(a.grade)
            : a.grade.compareTo(b.grade),
      );
      _sortDescending = !_sortDescending;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ממוצע: ${_average.toStringAsFixed(1)}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            tooltip: 'מיון לפי ציון',
            onPressed: _sort,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _students.length,
        itemBuilder: (context, index) {
          final student = _students[index];
          final passed = student.grade >= passingGrade;
          return ListTile(
            leading: Icon(
              passed ? Icons.check_circle : Icons.cancel,
              color: passed ? Colors.green : Colors.red,
            ),
            title: Text(student.name),
            subtitle: Text('ציון: ${student.grade}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  tooltip: 'הורד ציון',
                  onPressed: () => _changeGrade(student, -1),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: 'העלה ציון',
                  onPressed: () => _changeGrade(student, 1),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
