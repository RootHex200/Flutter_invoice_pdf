

import 'package:flutter/material.dart';
import 'package:invoice/service/invoice_pdf_api_service.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

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