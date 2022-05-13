import 'package:emed/data/model/user_question_notify.dart';
import 'package:emed/screen/ocr_result/components/custom_text_form_field.dart';
import 'package:emed/screen/question_screen/text_dialog_symptom.dart';
import 'package:emed/shared/setting/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DummyScreen extends StatefulWidget {
  @override
  _DummyScreenState createState() => _DummyScreenState();
}

class _DummyScreenState extends State<DummyScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Material App Bar'),
        ),
        body: SafeArea(
          child: Container(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 50),
                  CustomTextFormField(
                    initialText: 'afafa',
                    isFullRowTextField: true,
                    isEnabled: false,
                    onTapped: () => {},
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
