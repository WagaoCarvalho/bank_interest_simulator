import 'dart:io';

import 'package:bank_interest_simulator/services/calculadora_parcelas.dart';
import 'package:bank_interest_simulator/services/formatar_moeda.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show rootBundle; // Importe rootBundle para carregar arquivos de fonte
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

List<String> list = <String>['1', '2', '3', '4.3'];

class ResultPDFPage extends StatefulWidget {
  final double inputValue;

  const ResultPDFPage({Key? key, required this.inputValue}) : super(key: key);

  @override
  State<ResultPDFPage> createState() => _ResultPDFPageState();
}

class _ResultPDFPageState extends State<ResultPDFPage> {
  List<Map<String, dynamic>> gridData = [];
  double taxaRetorno = 1.0;

  @override
  void initState() {
    gridData =
        CalculadoraParcelas.calcularParcelas(widget.inputValue, taxaRetorno);
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                      dropdownValue = value!;
                      taxaRetorno = double.parse(value);
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
                const SizedBox(
                  width: 40,
                ),
                ElevatedButton(
                  onPressed: () {
                    _createPdf(context, gridData);
                  },
                  child: const Text('Gerar PDF'),
                )
              ],
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

_createPdf(BuildContext context, List<Map<String, dynamic>> gridData) async {
  final pdfDocument = pw.Document();

  // Carregue a fonte 'Roboto' (ajuste o caminho conforme necessário)
  final font = await rootBundle.load('fonts/Roboto-Regular.ttf');

  pdfDocument.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        return pw.Table(
          border: pw.TableBorder(horizontalInside: pw.BorderSide(width: 1)),
          children: [
            pw.TableRow(children: [
              pw.Text('Modalidade'),
              pw.Text('Parcelas'),
              pw.Text('Valor da Parcela'),
              pw.Text('Valor Total'),
            ]),
            for (final data in gridData)
              pw.TableRow(children: [
                pw.Text(data['Modalidade']),
                pw.Text(data['Parcelas'].toString()),
                pw.Text(data['Valor da Parcela'].toString()),
                pw.Text(data['Valor Total'].toString()),
              ]),
          ],
        );
      },
    ),
  );

  final filename = 'resultado.pdf';
  final file = File(filename);
  await pdfDocument.save();

  //final bytes = await file.readAsBytes();

  //await Printing.sharePdf(bytes: bytes);
}
