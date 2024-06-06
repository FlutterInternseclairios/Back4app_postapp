import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

String? selecteValue;

class DropdownBtn extends StatelessWidget {
  final Function(String?) onselected;
  final List<String> item;
  final String text;
  const DropdownBtn(
      {super.key,
      required this.text,
      required this.item,
      required this.onselected});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.purple[100],
      child: Center(
        child: DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: false,
            hint: Text(
              textAlign: TextAlign.center,
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            items: item
                .map((String item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        textAlign: TextAlign.center,
                        item,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ))
                .toList(),
            value: selecteValue,
            onChanged: (String? value) {
              onselected(value);
            },
            buttonStyleData: const ButtonStyleData(
              padding: EdgeInsets.symmetric(horizontal: 16),
              // height: 40,
              // width: 140,
            ),
            menuItemStyleData: const MenuItemStyleData(
              height: 40,
            ),
          ),
        ),
      ),
    );
  }
}
