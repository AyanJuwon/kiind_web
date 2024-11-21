// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

// class KiindPaypalPayment extends StatelessWidget {
//   final String itemName;
//   final String businessEmail; 
//   final String secretKey; 
//   final String clientId; 
//   final String amount;
//   final String currencyCode;
//   final String returnURL;
//   final String cancelURL;
//   final bool sandboxMode;
//   final String note;
  
//   final Function(Map<String, dynamic>) onSuccess;
//   final Function(String) onError;
//   final VoidCallback onCancel;

//   const KiindPaypalPayment({
//     Key? key,
//     required this.itemName,

//     required this.clientId,
//     required this.secretKey,
//     required this.businessEmail,
//     required this.amount,
//     required this.currencyCode,
//     required this.returnURL,
//     required this.cancelURL,
//     required this.sandboxMode,
//     required this.note,
//     required this.onSuccess,
//     required this.onError,
//     required this.onCancel,
//   }) : super(key: key);

//   // Method to launch PayPal URL in the system browser
//   Future<void> _launchPayPal() async {
//     try {
//       // Base PayPal URL
//       final baseUrl = sandboxMode
//           ? "https://www.sandbox.paypal.com/cgi-bin/webscr"
//           : "https://www.paypal.com/cgi-bin/webscr";

//       // Construct URL parameters
//       final queryParams = {
//         "cmd": "_xclick",
//         "business": businessEmail,
//         "item_name": Uri.encodeComponent(itemName),
//         "amount": amount,
//         "currency_code": currencyCode,
//         "return": Uri.encodeComponent(returnURL),
//         "cancel_return": Uri.encodeComponent(cancelURL),
//         "custom": note,
//       };

//       // Combine base URL with query parameters
//       final paypalUrl = Uri.parse(baseUrl).replace(queryParameters: queryParams).toString();

//       // Launch PayPal URL
//       if (await canLaunch(paypalUrl)) {
//         await launch(paypalUrl);
//       } else {
//         onError('Could not launch PayPal URL');
//       }
//     } catch (e) {
//       onError('Error launching PayPal URL: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('PayPal Checkout'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: _launchPayPal,
//           child: const Text('Pay with PayPal'),
//         ),
//       ),
//     );
//   }
// }
