import 'package:emed/data/model/drug.dart';
import 'package:emed/data/model/prescription.dart';
import 'package:emed/shared/api/drug_api.dart';
import 'package:flutter/material.dart';
import 'package:emed/shared/widget/roundImageButton.dart';
import 'package:emed/shared/utils/utils.dart';
import 'custom_text_form_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:emed/shared/setting/constant.dart';

class DrugList extends StatefulWidget {
  const DrugList({
    Key key,
    @required this.prescription,
    @required this.deleteDrugItem,
  }) : super(key: key);

  final Prescription prescription;
  final Function deleteDrugItem;

  @override
  DrugListState createState() => DrugListState();
}

class DrugListState extends State<DrugList> {
  final List<String> _unitSelections = numberToUnit.keys.toList();
  final String uid = getUserId();
  ScrollController _scrollController = ScrollController();
  final _drugNameController = TextEditingController();
  int get elementCount => widget.prescription.listPill.length;

  // String getDrugID(Drug drug) {
  //   if (drug.id != "" && '-'.allMatches(drug.id).length > 1) {
  //     return drug.id;
  //   } else {
  //     return genDrugID(drugName: drug.name);
  //   }
  // }

  setImagePathLocal({String imagePath = "", int index = 0}) {
    setState(() {
      widget.prescription.listPill[index].localImagePath = imagePath;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 250.h,
      padding: EdgeInsets.fromLTRB(0.w, 5.w, 0.w, 5.w),
      child: ListView.builder(
        controller: _scrollController,
        itemCount: widget.prescription.listPill.length,
        itemBuilder: (_, idx) {
          // String drugID = getDrugID(widget.prescription.listPill[idx]);
          var drugID = getDrugIDByName(widget.prescription.listPill[idx].name);
          print('DUYNA: drug name: $drugID');
          return Container(
            decoration: BoxDecoration(color: kPrimaryBackgroundColor),
            padding: EdgeInsets.only(left: 16.w, top: 8.h, bottom: 8.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 2,
                  child: ImageButton(
                    uploadedImage: drugID == '' ? false : true,
                    imageUrl: "images/${uid}/${drugID}.jpg",
                    setImagePathLocal: setImagePathLocal,
                    index: idx,
                    isCropped: false,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  flex: 4,
                  child: CustomTextFormField(
                    initialText: widget.prescription?.listPill[idx]?.name ?? '',
                    isFullRowTextField: false,
                    isEnabled: false,
                    onTapped: () =>
                        _displayTextDialogDrugName(widget.prescription, idx),
                  ),
                ),
                SizedBox(
                  width: 8.w,
                ),
                Expanded(
                  flex: 3,
                  child: CustomTextFormField(
                    initialText:
                        '${widget.prescription.listPill[idx].amount} ${numberToUnit[widget.prescription.listPill[idx].doseUnit]}',
                    isFullRowTextField: false,
                    isEnabled: false,
                    onTapped: () => _displayTextDialogDose(
                      widget.prescription,
                      idx,
                    ),
                  ),
                ),
                SizedBox(
                  width: 8.w,
                ),
                Expanded(
                  flex: 4,
                  child: CustomTextFormField(
                    initialText:
                        '${widget.prescription.listPill[idx].nTimesPerDay} lần/ngày' +
                            timeConsumToString[
                                widget.prescription.listPill[idx].timeConsume],
                    isFullRowTextField: false,
                    isEnabled: false,
                    onTapped: () =>
                        _displayTextDialogUsage(widget.prescription, idx),
                  ),
                ),
                SizedBox(
                  width: 8.w,
                ),
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
                          color: kPrimaryDarkColor,
                          size: 28.h,
                        ),
                      ),
                      onTap: () =>
                          widget.deleteDrugItem(widget.prescription, idx),
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

  _displayTextDialogDrugName(Prescription _prescription, int idx) async {
    var tmpDrugName = '';
    _drugNameController.text = _prescription.listPill[idx]?.name ?? '';
    await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child:
                  // new TextFormField(
                  //   autofocus: true,
                  //   decoration: new InputDecoration(
                  //     labelText: 'Tên thuốc',
                  //   ),
                  //   initialValue: _prescription.listPill[idx]?.name ?? '',
                  //   onChanged: (value) {
                  //     tmpDrugName = value;
                  //   },
                  // ),
                  TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(
                    autofocus: true,
                    controller: _drugNameController,
                    decoration: new InputDecoration(
                      labelText: 'Tên thuốc',
                    )),
                suggestionsCallback: (partialText) async {
                  print(partialText);
                  tmpDrugName = partialText;
                  if (partialText != '') {
                    final matches = await getDrugByName(partialText);
                    return matches;
                  }
                  return [];
                },
                suggestionsBoxDecoration: SuggestionsBoxDecoration(
                    borderRadius: BorderRadius.circular(5), elevation: 1),
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    leading: ImageIcon(
                        AssetImage('assets/icons/pill_uncompleted.png')),
                    title: Text(suggestion['tenThuoc'],
                        style: TextStyle(
                            color: Color.fromRGBO(162, 168, 191, 1),
                            fontWeight: FontWeight.w500,
                            fontFamily: "SanFrancisco",
                            fontSize: 14.sp)),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  tmpDrugName = suggestion['tenThuoc'];
                  _drugNameController.text = tmpDrugName;
                  print('DUYNA: ' + tmpDrugName);
                },
                hideOnError: true,
                hideOnEmpty: true,
              ),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('Save'),
              onPressed: () {
                setState(() {
                  if (tmpDrugName != '')
                    _prescription.listPill[idx].name = tmpDrugName;
                  _drugNameController.text = '';
                });
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

  _displayTextDialogDose(Prescription _prescription, int idx) async {
    var tmpDrugDose = _prescription.listPill[idx].amount;
    var tmpDrugUnit = _prescription.listPill[idx].doseUnit;

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
                    widget.prescription.listPill[idx].amount = tmpDrugDose;
                    widget.prescription.listPill[idx].doseUnit = tmpDrugUnit;
                  });
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

  _displayTextDialogUsage(Prescription _prescription, int idx) async {
    var tmpDrugFrequency = _prescription.listPill[idx].nTimesPerDay;
    var tmpDrugNote = _prescription.listPill[idx].timeConsume;

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
                            Text("Số lần uống "),
                            Spacer(),
                            TextFormField(
                              initialValue: '$tmpDrugFrequency',
                              onChanged: (value) {
                                tmpDrugFrequency = int.parse(value);
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
                                child: Text("Chú ý")),
                            Spacer(),
                            ButtonTheme(
                              alignedDropdown: true,
                              child: DropdownButton<String>(
                                  isExpanded: true,
                                  //set default value dua vao so ngay uong thuoc trong tuan
                                  value: timeConsumToString[tmpDrugNote],
                                  elevation: 1,
                                  icon: ImageIcon(
                                      AssetImage('assets/icons/dropdown.png')),
                                  iconSize: 30.w,
                                  underline: SizedBox(height: 5.w),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      print('new value');
                                      print(newValue);
                                      if (newValue == '') {
                                        tmpDrugNote = TimeConsume.NONE;
                                      } else if (newValue == 'trước bữa ăn') {
                                        tmpDrugNote = TimeConsume.BEFORE;
                                      } else if (newValue == 'trong bữa ăn') {
                                        tmpDrugNote = TimeConsume.WHEN;
                                      } else if (newValue == 'sau bữa ăn') {
                                        tmpDrugNote = TimeConsume.AFTER;
                                      }
                                    });
                                  },
                                  items: timeConsumToString.values
                                      .toList()
                                      .map<DropdownMenuItem<String>>(
                                          (String item) {
                                    return DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
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
                    _prescription.listPill[idx].nTimesPerDay = tmpDrugFrequency;
                    _prescription.listPill[idx].timeConsume = tmpDrugNote;
                  });

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

  scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 200),
      curve: Curves.linear,
    );
  }
}
