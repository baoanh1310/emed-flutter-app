import 'package:emed/shared/setting/app_router.dart';
import 'package:emed/shared/setting/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:emed/shared/setting/navigation_service.dart';
import 'package:emed/screen/prescription/prescription_search_logic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
                autofocus: false,
                style: DefaultTextStyle.of(context)
                    .style
                    .copyWith(fontStyle: FontStyle.italic),
                controller: _controller,
                decoration: kSearchInputDecoration.copyWith(
                    hintText: 'Nhập thông tin đơn thuốc cần tìm')),
            suggestionsCallback: (partialText) async {
              print(partialText);
              if (partialText != '') {
                setState(() {
                  showClearIcon = true;
                });
                // final matches = await getDrugByName(partialText);
                final matches = await PrescriptionSearchLogic()
                    .getPrescriptionByText(partialText: partialText);
                return matches;
              }
              return [];
            },
            suggestionsBoxDecoration: SuggestionsBoxDecoration(
                borderRadius: BorderRadius.circular(5), elevation: 1),
            itemBuilder: (context, suggestion) {
              return ListTile(
                leading: ImageIcon(
                    AssetImage('assets/icons/prescription_completed.png')),
                title: Text(suggestion.diagnose,
                    style: TextStyle(
                        color: Color.fromRGBO(162, 168, 191, 1),
                        fontWeight: FontWeight.w500,
                        fontFamily: "SanFrancisco",
                        fontSize: 14.sp)),
              );
            },
            onSuggestionSelected: _suggestionSelect,
            hideOnError: true,
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

  _suggestionSelect(suggestion) {
    setState(() {
      _controller.text = '';
      showClearIcon = false;
    });
    NavigationService().pushNamedAndRemoveUntil(ROUTER_PRESCRIPTION_DETAIL,
        (route) {
      return route.settings.name == ROUTER_MAIN;
    }, arguments: {
      'prescriptionId': suggestion.id,
      'prescription': suggestion
    });
  }
}
