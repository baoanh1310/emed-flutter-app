import 'package:emed/data/model/drug.dart';
import 'package:emed/data/model/drug_history_item_time.dart';
import 'package:emed/screen/pill_result/components/custom_text_form_field.dart';
import 'package:emed/shared/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:emed/shared/widget/imageButton.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class DrugList extends StatefulWidget {
  const DrugList(
      {Key key,
      @required this.listPill,
      @required this.todayList,
      @required this.coordList,
      @required this.imagePath,
      this.onPress,
      this.deleteDrugItem})
      : super(key: key);

  final List<Drug> listPill;
  final List<DrugHistoryItemTime> todayList;
  final List<dynamic> coordList;
  final String imagePath;
  final Function onPress;
  final Function deleteDrugItem;

  @override
  DrugListState createState() => DrugListState();
}

class DrugListState extends State<DrugList> {
  final List<String> _unitSelections = numberToUnit.keys.toList();
  ScrollController _scrollController = ScrollController();
  final TextEditingController _typeAheadController = TextEditingController();
  List<String> _drugListName = [];
  final String uid = getUserId();

  @override
  void initState() {
    print('Duyna: ${widget.todayList.toString()}');
    widget.todayList.forEach((element) {
      if (!element.isTaken) _drugListName.add(element.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    print(
        'Duyna: Reload the druglist..., the drug list has length ${widget.listPill.length}');
    return ConstrainedBox(
      // padding: EdgeInsets.symmetric(horizontal: 20.w),
      // decoration: BoxDecoration(color: Colors.black),
      constraints: BoxConstraints(maxHeight: 250.h),
      child: ListView.builder(
        controller: _scrollController,
        // padding: EdgeInsets.symmetric(horizontal: 8.w),
        itemCount: widget.listPill.length,
        shrinkWrap: true,
        itemBuilder: (_, idx) {
          var drugID = getDrugIDByName(widget.listPill[idx].name);
          print('ten thuoc: ${widget.listPill[idx].name}');
          print('[DRUG LIST] drugId: $drugID');
          return Container(
            margin: EdgeInsets.only(bottom: 5.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 4,
                  child: CustomTextFormField(
                    initialText: widget.listPill[idx]?.name ?? '',
                    isFullRowTextField: false,
                    isEnabled: false,
                    onTapped: () =>
                        _displayTextDialogDrugName(widget.listPill, idx),
                  ),
                ),
                SizedBox(
                  width: 8.w,
                ),
                Expanded(
                  flex: 4,
                  child: CustomTextFormField(
                    initialText:
                        '${widget.listPill[idx].amount} ${numberToUnit[widget.listPill[idx].doseUnit]}',
                    isFullRowTextField: false,
                    isEnabled: false,
                    onTapped: () => _displayTextDialogDose(
                      widget.listPill,
                      idx,
                    ),
                  ),
                ),
                SizedBox(
                  width: 8.w,
                ),
                Expanded(
                  flex: 4,
                  child: ImageButton(
                    imageUrl:
                        widget.coordList[idx] == null ? '' : widget.imagePath,
                    // : "images/$uid/$drugID.jpg",
                    coord: widget.coordList[idx],
                    // uploadedImage: true,
                    drugId: drugID,
                    userId: uid,
                    isCropped: true,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
                        child: Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 28.h,
                        ),
                      ),
                      onTap: () => widget.deleteDrugItem(widget.listPill, idx),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  _displayTextDialogDrugName(List<Drug> _listPill, int idx) async {
    this._typeAheadController.text = _listPill[idx].name;
    await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: this._typeAheadController,
                ),
                suggestionsCallback: (partialText) async {
                  print(partialText);

                  final matches = _getMatchSuggestion(partialText);
                  return matches;
                },
                suggestionsBoxDecoration: SuggestionsBoxDecoration(
                    borderRadius: BorderRadius.circular(5), elevation: 1),
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion,
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
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('Save'),
              onPressed: () {
                setState(() {
                  if (this._typeAheadController.text != '')
                    _listPill[idx].name = this._typeAheadController.text;
                });
                widget.onPress();
                Navigator.pop(context);
              }),
          new FlatButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ),
    );
  }

  _suggestionSelect(suggestion) {
    this._typeAheadController.text = suggestion;
  }

  _displayTextDialogDose(List<Drug> _listPill, int idx) async {
    var tmpDrugDose = _listPill[idx].amount;
    var tmpDrugUnit = _listPill[idx].doseUnit;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                height: 85.h,
                child: new Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(1.w),
                        child: Column(
                          children: [
                            Text("Số lượng"),
                            Spacer(),
                            TextFormField(
                              initialValue: '$tmpDrugDose',
                              onChanged: (value) {
                                tmpDrugDose = int.parse(value);
                              },
                              enabled: true,
                              keyboardType: TextInputType.number,
                              decoration: new InputDecoration(
                                isDense: true,
                                enabledBorder: const OutlineInputBorder(
                                  // width: 0.0 produces a thin "hairline" border
                                  borderSide: const BorderSide(
                                      color: Colors.grey, width: 0.0),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.black, width: 0.0),
                                ),
                                contentPadding: EdgeInsets.all(5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(1.w),
                        child: Column(
                          children: [
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 3.h),
                                child: Text("Đơn vị")),
                            Spacer(),
                            ButtonTheme(
                              alignedDropdown: true,
                              child: DropdownButton<String>(
                                  isExpanded: true,
                                  //set default value dua vao so ngay uong thuoc trong tuan
                                  value: numberToUnit[tmpDrugUnit],
                                  elevation: 1,
                                  icon: ImageIcon(
                                      AssetImage('assets/icons/dropdown.png')),
                                  iconSize: 30.w,
                                  underline: SizedBox(height: 5.w),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      if (newValue == numberToUnit['0']) {
                                        tmpDrugUnit = '0';
                                      } else if (newValue ==
                                          numberToUnit['1']) {
                                        tmpDrugUnit = '1';
                                      } else if (newValue ==
                                          numberToUnit['2']) {
                                        tmpDrugUnit = '2';
                                      } else if (newValue ==
                                          numberToUnit['3']) {
                                        tmpDrugUnit = '3';
                                      } else if (newValue ==
                                          numberToUnit['4']) {
                                        tmpDrugUnit = '4';
                                      } else if (newValue ==
                                          numberToUnit['5']) {
                                        tmpDrugUnit = '5';
                                      } else if (newValue ==
                                          numberToUnit['6']) {
                                        tmpDrugUnit = '6';
                                      } else if (newValue ==
                                          numberToUnit['7']) {
                                        tmpDrugUnit = '7';
                                      }
                                    });
                                  },
                                  items: _unitSelections
                                      .map<DropdownMenuItem<String>>(
                                          (String item) {
                                    return DropdownMenuItem<String>(
                                      value: numberToUnit[item],
                                      child: Text(
                                        numberToUnit[item],
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(12, 24, 39, 1),
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "SanFrancisco",
                                            fontSize: 12.sp),
                                      ),
                                    );
                                  }).toList()),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: <Widget>[
            new FlatButton(
                child: const Text('Save'),
                onPressed: () {
                  setState(() {
                    // print(tmpDiagnose);
                    widget.listPill[idx].amount = tmpDrugDose;
                    widget.listPill[idx].doseUnit = tmpDrugUnit;
                  });
                  widget.onPress();
                  Navigator.pop(context);
                }),
            new FlatButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                })
          ],
        );
      },
    );
  }

  _getMatchSuggestion(String partialText) {
    var suggestions = [];
    print('DUYNA: ${_drugListName.toString()}');
    if (partialText == '') return _drugListName;
    _drugListName.forEach((element) {
      if (element.contains(partialText)) suggestions.add(element);
    });

    return suggestions;
  }

  scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 200),
      curve: Curves.linear,
    );
  }
}
