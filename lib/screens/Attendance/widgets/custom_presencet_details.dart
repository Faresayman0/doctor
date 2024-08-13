import 'package:flutter/material.dart';

import '../../../core/resources/app_colors.dart';

class CustomPresencetDetails extends StatelessWidget {
  const CustomPresencetDetails(
      {super.key, required this.title, required this.number});
  final String title;
  final String number;
  @override
  Widget build(BuildContext context) {
    return Card(
        color: AppColors.colorWhite,
        clipBehavior: Clip.antiAlias,
        elevation: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(title,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: AppColors.colorGray)),
                  Text(
                    number,
                    style: Theme.of(context).textTheme.headlineSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Container(
              width: 10,
              decoration: BoxDecoration(
                  color: title == "الغياب"
                      ? AppColors.colorRed
                      : AppColors.primaryColorLight),
            ),
          ],
        ));
  }
}
