import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../core/resources/app_colors.dart';
import '../Attendance/lecture_attendance.dart';
import '../Attendance/widgets/custom_student_card.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key, required this.nameStudent});
  final List<StudentData> nameStudent;
  @override
  Widget build(BuildContext context) {
    SuggestionsController<StudentData>? suggestionsController =
        SuggestionsController();
    TextEditingController customSearch = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("البحث"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 50,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: TypeAheadField<StudentData>(
            suggestionsController: suggestionsController,
            suggestionsCallback: (search) {
              return nameStudent.where((element) {
                
                return element.name.toUpperCase().contains(search.toUpperCase());
              }).toList();
            },
            builder: (context, controller, focusNode) {
              customSearch = controller;
              suggestionsController.refresh();

              return TextFormField(
                decoration: InputDecoration(
                  suffixIcon: const Icon(
                    Icons.search,
                    color: AppColors.primaryColorLight,
                  ),
                  hintText: "بحث عن طالب",
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.primaryColorLight)),
                  enabledBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.primaryColorLight)),
                ),
                controller: customSearch,
                focusNode: focusNode,
                onChanged: (value) {},
              );
            },
            itemBuilder: (context, item) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomStudenctCard(
                  name: item.name,
                  status: item.status,
                ),
              );
            },
            onSelected: (item) {
              customSearch.clear();
              suggestionsController.close();
            },
          ),
        ),
      ),
    );
  }
}
