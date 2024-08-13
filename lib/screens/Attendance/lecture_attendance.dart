import 'package:attendance/screens/Attendance/widgets/custom_presencet_details.dart';
import 'package:flutter/material.dart';
import '../search/search_screen.dart';
import 'widgets/custom_student_card.dart';

class LectureAttendance  extends StatelessWidget {
  const LectureAttendance({super.key, required this.lectureName});
  final String lectureName;

  @override
  Widget build(BuildContext context) {
    List<StudentData> nameStudent = [
      StudentData(name: 'Ahmed (أحمد)', status: "حضور"),
      StudentData(name: 'Mohammed (محمد)', status: "غياب"),
      StudentData(name: 'Ali (علي)', status: "حضور"),
      StudentData(name: 'Omar (عمر)', status: "غياب"),
      StudentData(name: 'Yusuf (يوسف)', status: "حضور"),
      StudentData(name: 'Ibrahim (إبراهيم)', status: "حضور"),
      StudentData(name: 'Khalid (خالد)', status: "حضور"),
      StudentData(name: 'Hassan (حسن)', status: "غياب"),
      StudentData(name: 'Faisal (فيصل)', status: "حضور"),
      StudentData(name: 'Abdullah (عبد الله)', status: "غياب"),
      StudentData(name: 'Fatima (فاطمة)', status: "غياب"),
      StudentData(name: 'Aisha (عائشة)', status: "حضور"),
      StudentData(name: 'Zainab (زينب)', status: "حضور"),
      StudentData(name: 'Mariam (مريم)', status: "حضور"),
      StudentData(name: 'Noor (نور)', status: "حضور"),
      StudentData(name: 'Layla (ليلى)', status: "حضور"),
      StudentData(name: 'Salma (سلمى)', status: "غياب"),
    ];
    List absence = nameStudent
        .where(
          (element) => element.status == "غياب",
        )
        .toList();
    List presence = nameStudent
        .where(
          (element) => element.status == "حضور",
        )
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          lectureName,
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchScreen(
                        nameStudent: nameStudent,
                      ),
                    ));
              },
              icon: const Icon(
                Icons.search,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Row(
                children: [
                  Expanded(
                    child: IntrinsicHeight(
                      child: CustomPresencetDetails(
                          title: "الحضور", number: presence.length.toString()),
                    ),
                  ),
                  Expanded(
                    child: IntrinsicHeight(
                      child: CustomPresencetDetails(
                          title: "الغياب", number: absence.length.toString()),
                    ),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: ListView.builder(
                shrinkWrap: true,
                physics:const NeverScrollableScrollPhysics(),
                itemCount: nameStudent.length,
                itemBuilder: (context, index) {
                  return CustomStudenctCard(
                    name: nameStudent[index].name,
                    status: nameStudent[index].status,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class StudentData {
  final String name;
  final String status;

  StudentData({required this.name, required this.status});
}
