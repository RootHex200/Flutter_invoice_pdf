


import 'dart:io';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';
class InvoicePdfApi{
   var platform = const MethodChannel('samples.flutter.dev/battery');
  Future<void> generateInvoicepdf()async{
    final result=await platform.invokeMethod('bitmap');
    var myTheme = ThemeData.withFont(
  base: Font.ttf(await rootBundle.load("assets/fonts/Bangla.ttf")),
  // bold: Font.ttf(await rootBundle.load("assets/fonts/OpenSans-Bold.ttf")),
  // italic: Font.ttf(await rootBundle.load("assets/fonts/OpenSans-Italic.ttf")),
);
    final pdf=Document(
      theme: myTheme
    );

    pdf.addPage(MultiPage(
      build: (context){
      
      return [
        Image(MemoryImage(Uint8List.fromList(result))),
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