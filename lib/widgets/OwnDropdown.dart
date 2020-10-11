import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nomoni_app/comm/option.dart';

Container createDropdown({
  String dropdownName,
  List<Option> listOption,
  TextEditingController controller,
  Function onChanged
  }) {
    // DropdownMenuItem<> list = [];
    return Container(
      margin: EdgeInsets.only(top: 8.0),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 18.0),
            child: Icon(
              Icons.add_call,
              color: Colors.redAccent,
              size: 24.0,
            ),
          ),
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text(
                      dropdownName,
                      style: new TextStyle(color: Colors.black54),
                    )
                  ),
                  Center(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      // value: (controller.text ?? '').toString(),
                      value: controller.text,
                      items: listOption.map((Option option) {
                        return DropdownMenuItem<String>(
                          // value: (option.key ?? '').toString(),
                          value: (option.key.toString()),
                          child: new Text(
                            option.value,
                            style: new TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                      onChanged: onChanged,
                      // onChanged: (_) {
                      //   setState(() {
                      //     controller.text = _.toString();
                      //   });
                      // },
                    ),
                  ),
                ],
              )
            ),
          ),
        ],
      ),
    );
  }
