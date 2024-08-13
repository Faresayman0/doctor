
import 'package:flutter/material.dart';

import '../../../core/resources/app_colors.dart';

class CustomStudenctCard extends StatelessWidget {
  const CustomStudenctCard(
      {super.key, required this.name, required this.status});
  final String name;
  final String status;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * .12,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 10,
        color: AppColors.colorWhite,
        child: Row(
          children: [
            Container(
              width: 10,
              decoration: BoxDecoration(
                  color: status == "غياب"
                      ? AppColors.colorRed
                      : AppColors.primaryColorLight),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "الاسم",
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(color: AppColors.colorGray),
                        ),
                        Text(
                          "الحاله",
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(color: AppColors.colorGray),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          name,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          status,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: status == "غياب"
                                      ? AppColors.colorRed
                                      : AppColors.primaryColorLight),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
