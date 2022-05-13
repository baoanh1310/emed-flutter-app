import 'package:emed/shared/widget/my_icon.dart';
import 'package:flutter/material.dart';

const double kBottomNavigationBarHeight = 56.0;

class FABBottomAppBar extends StatefulWidget {
  final List<FABBottomAppBarItem> items;
  final Color backgroundColor;
  final Color selectedColor;
  final Color unselectedColor;
  final Color backgroundIconColor;
  final Widget actionButton;
  final double iconSize;
  final Function(int) onTabSelected;

  FABBottomAppBar(
      {this.items,
      this.backgroundColor,
      this.selectedColor,
      this.unselectedColor,
      this.backgroundIconColor,
      this.actionButton,
      this.iconSize,
      this.onTabSelected});

  @override
  _FABBottomAppBarState createState() => _FABBottomAppBarState();
}

class _FABBottomAppBarState extends State<FABBottomAppBar> {
  List<FABBottomAppBarItem> get items => widget.items;

  Color get backgroundColor => widget.backgroundColor;

  Color get selectedColor => widget.selectedColor;

  Color get unselectedColor => widget.unselectedColor;

  Color get backgroundIconColor => widget.backgroundIconColor ?? Color(0xFF1AADBB).withOpacity(0.07);

  Widget get actionButton => widget.actionButton;

  double get iconSize => widget.iconSize ?? 20;

  Function(int) get onTabSelected => widget.onTabSelected;

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> items = List.generate(widget.items.length, (int index) {
      return _buildTabItem(
        item: widget.items[index],
        index: index,
        onTap: _updateIndex,
        backgroundColor: backgroundColor
      );
    });
    items.insert(items.length >> 1, Expanded(child: actionButton));

    return BottomAppBar(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: items,
        ),
      ),
      color: backgroundColor,
    );
  }

  _updateIndex(int index) {
    onTabSelected(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  _buildTabItem({
    FABBottomAppBarItem item,
    int index,
    Function(int) onTap,
    Color backgroundColor,
  }) {
    // final double additionalBottomPadding = MediaQuery.of(context).padding.bottom;
    Color iconColor = _selectedIndex == index ? selectedColor : unselectedColor;
    Color bgIconColor = _selectedIndex == index ? backgroundIconColor : Colors.transparent;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          onTap(index);
        },
        child: Container(
          color: backgroundColor,
          height: kBottomNavigationBarHeight,
          child: Center(
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: bgIconColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(12.0),
                )
              ),
              child: MyIcon(
                iconData: item.iconData,
                svgIconPath: item.svgIconPath,
                color: iconColor,
                size: iconSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FABBottomAppBarItem {
  final IconData iconData;
  final String svgIconPath;

  FABBottomAppBarItem({this.iconData, this.svgIconPath});
}
