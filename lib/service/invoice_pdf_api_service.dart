import 'dart:io';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class InvoicePdfApi {
  var platform = const MethodChannel('samples.flutter.dev/battery');
  Future<void> generateInvoicepdf() async {
    final result = await platform.invokeMethod('bitmap');
    var myTheme = ThemeData.withFont(
      base: Font.ttf(await rootBundle.load("assets/fonts/OpenSans-Bold.ttf")),
      bold: Font.ttf(await rootBundle.load("assets/fonts/OpenSans-Bold.ttf")),
      italic:
          Font.ttf(await rootBundle.load("assets/fonts/OpenSans-Italic.ttf")),
    );
    final pdf = Document(theme: myTheme);

    pdf.addPage(MultiPage(build: (context) {
      return [
        BuildPdf(),
      ];
    }));

    final bytes = await pdf.save();
    final dir = await getApplicationCacheDirectory();
    final filepath = File("${dir.path}/invoice.pdf");

    await filepath.writeAsBytes(bytes);

    //open url
    final url = filepath.path;
    await OpenFile.open(url);
  }

  // ignore: non_constant_identifier_names
  static Widget BuildPdf() {
    const paymentTerms = '7 days';
    final titles = <String>[
      'Invoice Number:',
      'Invoice Date:',
      'Payment Terms:',
      'Due Date:'
    ];
    final data = <String>[
      '123456',
      '2021-05-05',
      paymentTerms,
      "2021-05-05",
    ];
        final headers = [
      'Description',
      'Date',
      'Quantity',
      'Unit Price',
      'VAT',
      'Total'
    ];
    final productdata =[
      ["Product 1 is a very good product",
        "05-12-2023",
        '${12}',
        '\$ ${150}',
        '${10} %',
        '\$ ${200}',]
    ];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 1 * PdfPageFormat.cm),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("sabitur", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Cumilla,Bangladesh"),
              ],
            ),
            Container(
              height: 50,
              width: 50,
              child: BarcodeWidget(
                barcode: Barcode.qrCode(),
                data: "Hello",
              ),
            ),
          ],
        ),
        SizedBox(height: 1 * PdfPageFormat.cm),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(titles.length, (index) {
                final title = titles[index];
                final value = data[index];

                return RowText(title: title, value: value, width: 200);
              }),
            )
          ],
        ),
        SizedBox(height: 3 * PdfPageFormat.cm),
        Table.fromTextArray(
      headers: headers,
      data: productdata,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: const BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
      },
    ),
    Divider(),
    Container(
      child: Align(
        alignment: Alignment.center,
        child: Row(
          
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("Total Amount:   200 BDT  "),
          ]
        )
      )
    )
      ],
    );
  }

  static RowText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}
