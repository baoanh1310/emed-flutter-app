import 'package:emed/data/model/drug.dart';
import 'package:emed/shared/setting/app_router.dart';
import 'package:emed/shared/setting/constant.dart';
import 'package:emed/shared/widget/my_icon.dart';
import 'package:emed/shared/extension/date.dart';
import 'package:flutter/material.dart';
import 'package:emed/shared/api/drug_api.dart';
import 'package:emed/shared/setting/navigation_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DrugItem extends StatelessWidget {
  final Drug item;

  DrugItem({this.item});

  @override
  Widget build(BuildContext context) {
    final isCompleted = item.completedAt.isBefore(DateTime.now());
    final color = isCompleted ? kCompleteColor : kPrimaryColor;
    return InkWell(
      onTap: () => navigateToDrug(item),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color.fromRGBO(4, 13, 58, 0.07),
              spreadRadius: 1,
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
                      'Có trong ${item.presentInPrescriptions} đơn',
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
                      item.startedAt.formatDate(),
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
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    CircleAvatar(
                      child: MyIcon(
                        svgIconPath: 'assets/icons/drug_pill.svg',
                        color: color,
                      ),
                      backgroundColor: Color(0xFFF4FFFC),
                    ),
                    SizedBox(
                      width: 12.0,
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2.w),
                            child: Text(
                              item.name,
                              maxLines: 2,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Row(
                            children: [
                              SizedBox(
                                width: 4.0,
                              ),
                              Image(
                                image: AssetImage('assets/icons/dark_dot.png'),
                              ),
                              SizedBox(
                                width: 4.0,
                              ),
                              Text(
                                '${item.amount} ${numberToUnit[item.doseUnit]}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                        color: Color.fromRGBO(4, 13, 58, 0.5)),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 4.0,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Text(
                              item.timeConsume == TimeConsume.BEFORE
                                  ? 'Trước Khi Ăn'
                                  : (item.timeConsume == TimeConsume.WHEN
                                      ? 'Trong Khi Ăn'
                                      : 'Sau Khi Ăn'),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                    color: isCompleted
                                        ? Color(0xFFA3A8BF)
                                        : kPrimaryColor,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: isCompleted ? kCompleteColor : kPrimaryColor,
                      ),
                      child: Text(
                        isCompleted ? 'Hoàn Thành' : 'Hôm nay',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              color: Colors.white,
                            ),
                        textAlign: TextAlign.end,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  navigateToDrug(Drug drug) async {
    print('DUYNA: Navigating to drug detail..');
    final drugId = drug.id;
    if (drugId != '') {
      Map<String, dynamic> result = await getDrugByIdIfMatch(drugId);
      if (result != null) {
        print('Dugna: ${result['soDangKy']}');
        NavigationService()
            .pushNamed(ROUTER_DRUG_DETAIL, arguments: {'drug': result});
      }
    } else {
      final result = drug.toDrugDetailMap();
      NavigationService()
          .pushNamed(ROUTER_DRUG_DETAIL, arguments: {'drug': result});
    }
  }
}
