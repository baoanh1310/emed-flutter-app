import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextBar extends StatelessWidget {
  const TextBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 5.w, 0.w, 5.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 1,
            child: _buildText(
              'Ảnh',
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            flex: 2,
            child: _buildText(
              'Tên thuốc',
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(width: 1.w),
          Expanded(
            flex: 2,
            child: _buildText(
              'Liều dùng',
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(width: 1.w),
          Expanded(
            flex: 3,
            child: _buildText(
              'Cách dùng',
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(width: 20.w),
          // Expanded(
          //   flex: 2,
          //   child: _buildText(
          //     "Xoá",
          //     textAlign: TextAlign.center,
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildText(String content, {TextAlign textAlign}) {
    return Text(
      content,
      style: TextStyle(
        color: Colors.grey,
        fontSize: 11.sp,
      ),
      textAlign: textAlign ?? TextAlign.start,
    );
  }
}
