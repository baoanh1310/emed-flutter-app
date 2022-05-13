import 'package:emed/data/model/prescription.dart';
import 'package:emed/shared/setting/constant.dart';
import 'package:emed/shared/widget/my_icon.dart';
import 'package:emed/shared/extension/date.dart';
import 'package:flutter/material.dart';

typedef OnPrescriptionItemClick = Function(Prescription item);

class PrescriptionItem extends StatelessWidget {
  final Key key;
  final Prescription item;
  final OnPrescriptionItemClick onItemClick;

  PrescriptionItem({this.key, this.item, this.onItemClick});

  @override
  Widget build(BuildContext context) {
    final isCompleted = item.completedAt.isBefore(DateTime.now());
    final color = isCompleted ? kCompleteColor : kPrimaryColor;
    return GestureDetector(
      onTap: () {
        if (onItemClick != null) {
          onItemClick(item);
        }
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color.fromRGBO(4, 13, 58, 0.1),
              spreadRadius: 2,
              blurRadius: 7,
            ),
          ],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: color,
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    MyIcon(
                      svgIconPath: 'assets/icons/date_icon.svg',
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      '${item.listPill.length} loại thuốc',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(color: Colors.white),
                    ),
                    Spacer(),
                    Text(
                      'Ngày tạo: ',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(color: Colors.white.withOpacity(0.7)),
                    ),
                    Text(
                      item.createdAt.formatDate(),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.only(
                    top: 12.0, right: 8.0, bottom: 12.0, left: 3.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      child: MyIcon(
                        svgIconPath: 'assets/icons/prescription_list.svg',
                        color: color,
                      ),
                      backgroundColor: Color(0xFFF4FFFC),
                    ),
                    SizedBox(
                      width: 12.0,
                    ),
                    Flexible(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.diagnose,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 4.0,
                          ),
                          Text(
                            isCompleted
                                ? 'Hoàn thành'
                                : 'Uống 1 tuần ${item.nDaysPerWeek} ngày',
                            style: Theme.of(context).textTheme.bodyText2.copyWith(
                                  color: isCompleted
                                      ? kCompleteColor
                                      : Color(0xFFA3A8BF),
                                ),
                          ),
                        ],
                      ),
                    ),
                    // Expanded(
                    //   child: Text(
                    //     'Daily/08:00 - 12:00',
                    //     style: Theme.of(context).textTheme.bodyText2.copyWith(
                    //           color: Color(0xFFA3A8BF),
                    //         ),
                    //     textAlign: TextAlign.end,
                    //     maxLines: 2,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
