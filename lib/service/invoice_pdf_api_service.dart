


import 'dart:io';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';
class InvoicePdfApi{

  Future<void> generateInvoicepdf()async{
    var myTheme = ThemeData.withFont(
  base: Font.ttf(await rootBundle.load("assets/fonts/OpenSans-Regular.ttf")),
  bold: Font.ttf(await rootBundle.load("assets/fonts/OpenSans-Bold.ttf")),
  italic: Font.ttf(await rootBundle.load("assets/fonts/OpenSans-Italic.ttf")),
);
    final pdf=Document(
      theme: myTheme
    );

    pdf.addPage(MultiPage(
      build: (context){

      return [
        Center(
          child: Text("hello world!!",style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ];
    }));

    final bytes=await pdf.save();
    print(bytes);
    final dir=await getApplicationCacheDirectory();
    final filepath=File("${dir.path}/invoice.pdf");
    
    await filepath.writeAsBytes(bytes);
        print(filepath);

    //open url
    final url=filepath.path;
    await OpenFile.open(url);
  }

}