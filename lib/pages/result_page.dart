import 'package:bank_interest_simulator/services/calculadora_parcelas.dart';
import 'package:bank_interest_simulator/services/formatar_moeda.dart';
import 'package:flutter/material.dart';

List<String> list = <String>['1', '2', '3', '4.3'];

class ResultPage extends StatefulWidget {
  final double inputValue;

  const ResultPage({Key? key, required this.inputValue}) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  List<Map<String, dynamic>> gridData = []; // Declare a list here
  double taxaRetorno = 1.0;

  @override
  void initState() {
    gridData = CalculadoraParcelas.calcularParcelas(
        widget.inputValue, taxaRetorno); // Initialize it in initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String dropdownValue = taxaRetorno.toString();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            Text(
                'Valor Digitado: ${FormatarMoeda.formatarMoeda(widget.inputValue)}'),
            const SizedBox(height: 20),
            DropdownButton<String>(
              value: dropdownValue,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? value) {
                setState(() {
                  dropdownValue =
                      value!; // Update dropdownValue with the new selected value
                  taxaRetorno = double.parse(
                      value); // Update taxaRetorno with the new selected value
                  gridData = CalculadoraParcelas.calcularParcelas(
                      widget.inputValue, taxaRetorno);
                });
              },
              items: list.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text('Retorno ${value}'),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Modalidade')),
                  DataColumn(label: Text('Parcelas')),
                  DataColumn(label: Text('Valor da Parcela')),
                  DataColumn(label: Text('Valor Total')),
                ],
                rows: gridData.map((data) {
                  return DataRow(cells: [
                    DataCell(Text(data['Modalidade'])),
                    DataCell(Text(data['Parcelas'].toString())),
                    DataCell(Text(data['Valor da Parcela'])),
                    DataCell(Text(data['Valor Total'])),
                  ]);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
