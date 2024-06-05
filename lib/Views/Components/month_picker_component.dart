
import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import '../../Configs/constant.dart';

class MonthPickerComponent extends StatefulWidget {
  final ValueChanged<DateTime?> onChange;
  const MonthPickerComponent({super.key, required this.onChange});

  @override
  State<MonthPickerComponent> createState() => _MonthPickerComponentState();
}

class _MonthPickerComponentState extends State<MonthPickerComponent> {
  DateTime selectedDate = DateTime.now();

  Future<void> _selectMonth(BuildContext context) async {
    final DateTime? picked = await showMonthPicker(
      currentMonthTextColor: primaryColor,
      unselectedMonthTextColor: textColor,
      cancelWidget: const Text(
        'Hủy',
        style: TextStyle(color: primaryColor),
      ),
      confirmWidget: const Text(
        'Chọn',
        style: TextStyle(color: primaryColor),
      ),
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),

    );
    if (picked != null && picked != selectedDate) {
      widget.onChange(picked);
      setState(() {
        selectedDate = picked;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, bottom: 3),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(borderSide: BorderSide.none),
                ),
                controller: TextEditingController(
                  text: '${selectedDate.month}/${selectedDate.year}',
                ),
                onTap: () => _selectMonth(context),
                readOnly: true,
                textAlignVertical: TextAlignVertical.center),
          ),
          IconButton(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            icon: const Icon(
              Icons.calendar_today,
              size: 19,
            ),
            onPressed: () => _selectMonth(context),
          ),
        ],
      ),
    );
  }
}
