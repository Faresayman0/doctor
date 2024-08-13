import 'package:attendance/screens/Attendance/lecture_attendance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../core/resources/app_colors.dart';

class LecturesScreen extends StatefulWidget {
  const LecturesScreen({super.key, required this.title});
  final String title;

  @override
  State<LecturesScreen> createState() => _LecturesScreenState();
}

class _LecturesScreenState extends State<LecturesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
        centerTitle: true,
      ),
      body: AnimationLimiter(
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.all(10),
          itemCount: 9,
          itemBuilder: (BuildContext context, int index) {
            return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 500),
                child: CustomLectures(
                    className: "Lecture ${index + 1}",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LectureAttendance(
                              lectureName: "Lecture ${index + 1}"),
                        ),
                      );
                    }));
          },
        ),
      ),
    );
  }
}

class CustomLectures extends StatelessWidget {
  const CustomLectures({
    super.key,
    required this.className,
    this.onTap,
  });
  final String className;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return SlideAnimation(
        verticalOffset: 50.0,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(vertical: 7),
            decoration: const BoxDecoration(
              color: AppColors.primaryColorLight,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(className,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: AppColors.colorWhite)),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.colorWhite,
                ),
              ],
            ),
          ),
        ));
  }
}
