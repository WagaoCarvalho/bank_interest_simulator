import 'package:flutter/material.dart';

class DropdownRetornoTaxa extends StatefulWidget {
  const DropdownRetornoTaxa({super.key});

  @override
  State<DropdownRetornoTaxa> createState() => _DropdownRetornoTaxaState();
}

List<String> list = <String>['1X', '2X', '3X', '4X'];

class _DropdownRetornoTaxaState extends State<DropdownRetornoTaxa> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text('Retorno ${value}'),
          onTap: () => print('teste'),
        );
      }).toList(),
    );
  }
}
