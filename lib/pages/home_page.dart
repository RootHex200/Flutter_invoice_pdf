

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:invoice/service/invoice_pdf_api_service.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
    var platform = const MethodChannel('samples.flutter.dev/battery');
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Invoice"),
      ),
      body:Center(
        child: ElevatedButton(
          onPressed: 
        ()async{

          InvoicePdfApi().generateInvoicepdf();
        }, child: const Text("Generate Invoice")),
      ),
    );
  }
}