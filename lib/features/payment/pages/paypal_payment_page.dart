import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

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

  @override
  Widget build(BuildContext context) {
    String paypalUrl =
        "https://www.sandbox.paypal.com/sdk/js?client-id=$clientId&currency=$currencyCode";

    String escapedNote = note.replaceAll("'", "\\'").replaceAll("\"", "\\\"");
    String escapedAmount = amount.replaceAll("'", "\\'").replaceAll("\"", "\\\"");

    String htmlContent = """
    <!DOCTYPE html>
    <html>
      <head>
        <script src="$paypalUrl"></script>
      </head>
      <body>
        <div id="paypal-button-container"></div>
        <script>
          paypal.Buttons({
            createOrder: function(data, actions) {
              return actions.order.create({
                purchase_units: [{
                  amount: {
                    value: '$escapedAmount'
                  },
                  description: "$escapedNote"
                }]
              });
            },
            onApprove: function(data, actions) {
              return actions.order.capture().then(function(details) {
                window.onSuccess(JSON.stringify(details));
              });
            },
            onCancel: function(data) {
              window.onCancel();
            },
            onError: function(err) {
              window.onError(err.toString());
            }
          }).render('#paypal-button-container');
        </script>
      </body>
    </html>
    """;

    return Scaffold(
      appBar: AppBar(
        title: const Text('PayPal Checkout'),
      ),
      body: WebView(
        initialUrl: Uri.dataFromString(htmlContent, mimeType: 'text/html').toString(),
        javascriptMode: JavascriptMode.unrestricted,
        javascriptChannels: {
          JavascriptChannel(
            name: 'onSuccess',
            onMessageReceived: (message) {
              try {
                Map<String, dynamic> details = jsonDecode(message.message);
                onSuccess(details);
              } catch (e) {
                onError('Invalid response: ${message.message}');
              }
            },
          ),
          JavascriptChannel(
            name: 'onCancel',
            onMessageReceived: (message) {
              onCancel();
            },
          ),
          JavascriptChannel(
            name: 'onError',
            onMessageReceived: (message) {
              onError(message.message);
            },
          ),
        },
      ),
    );
  }
}
