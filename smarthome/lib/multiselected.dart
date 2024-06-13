import 'package:flutter/material.dart';

class multiselected extends StatefulWidget {
  final List<String> items;
  const multiselected({Key? key, required this.items}) : super(key: key);

  @override
  State<multiselected> createState() => _multiselectedState();
}

class _multiselectedState extends State<multiselected> {
  final List<String> _selecteditems = [];

  void _itemchange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selecteditems.add(itemValue);
      } else {
        _selecteditems.remove(itemValue);
      }
    });
  }

  void _cancel() {
    Navigator.pop(context);
  }

  void _submit() {
    Navigator.pop(context, _selecteditems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("selecione os tipos de lixo "),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items
              .map((item) => CheckboxListTile(
                    value: _selecteditems.contains(item),
                    title: Text(item),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (isChecked) => _itemchange(item, isChecked!),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
