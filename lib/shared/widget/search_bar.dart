import 'package:emed/shared/setting/constant.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  SearchBar({Key key}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = TextEditingController();
  bool showClearIcon = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: Stack(
        children: [
          TextFormField(
            decoration: kSearchInputDecoration.copyWith(
                hintText: 'Nhập thông tin (đơn) thuốc cần tìm'),
            controller: _controller,
            onChanged: (value) {
              if ((value.isEmpty && showClearIcon) ||
                  (value.isNotEmpty && !showClearIcon)) {
                setState(() {
                  showClearIcon = !showClearIcon;
                });
              }
            },
          ),
          if (showClearIcon)
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  _controller.text = '';
                  setState(() {
                    showClearIcon = false;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }
}
