import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class DropdownComponent extends StatefulWidget {
  String? selectValue;
  final List<DropdownMenuItem<String>> items;
  final ValueChanged<String?> onChange;
  DropdownComponent({super.key, this.selectValue, required this.items, required this.onChange});

  @override
  State<DropdownComponent> createState() => _DropdownComponentState();
}

class _DropdownComponentState extends State<DropdownComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.grey, style: BorderStyle.solid, width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          buttonStyleData: const ButtonStyleData(
            padding: EdgeInsets.symmetric(horizontal: 13),
            height: 40,
            width: 140,
          ),
          dropdownStyleData: const DropdownStyleData(
            maxHeight: 160,
          ),
          hint: Text(
            'Select Item',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).hintColor,
            ),
          ),
          items: widget.items,
          value: widget.selectValue,
          onChanged: (String? newValue) {
            widget.onChange(newValue!);
            setState(() {
              widget.selectValue = newValue;
            });
          },
        ),
      ),
    );
  }
}
