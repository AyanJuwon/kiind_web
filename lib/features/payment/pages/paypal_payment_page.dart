import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class KiindPaypalPayment extends StatelessWidget {
  final String clientId;
  final String amount;
  final String currencyCode;
  final String returnURL;
  final String cancelURL;
  final bool sandboxMode;
  final String note;
  final String secretKey;
  final Function(Map) onSuccess;
  final Function(String) onError;
  final VoidCallback onCancel;

  const KiindPaypalPayment({
    Key? key,
    required this.clientId,
    required this.amount,
    required this.currencyCode,
    required this.returnURL,
    required this.cancelURL,
    required this.sandboxMode,
    required this.note,
    required this.secretKey,
    required this.onSuccess,
    required this.onError,
    required this.onCancel,
  }) : super(key: key);

  // Method to launch PayPal URL in the system browser
  Future<void> _launchPayPal() async {
    // PayPal URL depending on sandboxMode
    String paypalUrl =
        sandboxMode
            ? "https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_xclick&business=$clientId&item_name=$note&amount=$amount&currency_code=$currencyCode&return=$returnURL&cancel_return=$cancelURL"
            : "https://www.paypal.com/cgi-bin/webscr?cmd=_xclick&business=$clientId&item_name=$note&amount=$amount&currency_code=$currencyCode&return=$returnURL&cancel_return=$cancelURL";

    try {
      if (await canLaunch(paypalUrl)) {
        await launch(paypalUrl);
      } else {
        onError('Could not launch PayPal URL');
      }
    } catch (e) {
      onError('Error launching PayPal URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PayPal Checkout'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _launchPayPal,
          child: const Text('Pay with PayPal'),
        ),
      ),
    );
  }
}
