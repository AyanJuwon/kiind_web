import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class KiindPaypalPayment extends StatelessWidget {
  final String clientId;
  final String secretKey;
  final String amount;
  final String currencyCode;
  final String returnURL;
  final String cancelURL;
  final bool sandboxMode;
  final String note;
  final Function(Map) onSuccess;
  final Function(String) onError;
  final VoidCallback onCancel;

  const KiindPaypalPayment({
    Key? key,
    required this.clientId,
    required this.secretKey,
    required this.amount,
    required this.currencyCode,
    required this.returnURL,
    required this.cancelURL,
    required this.sandboxMode,
    required this.note,
    required this.onSuccess,
    required this.onError,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Updated PayPal SDK URL with debug parameter
    String paypalUrl = "https://www.paypal.com/sdk/js?client-id=$clientId&currency=$currencyCode&debug=true&intent=capture";

    // Escape special characters in JavaScript strings
    String escapedNote = note.replaceAll("'", "\\'");
    String escapedAmount = amount.replaceAll("'", "\\'");

    String htmlContent = """
    <!DOCTYPE html>
    <html>
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <script src="$paypalUrl"></script>
        <style>
          body { margin: 0; padding: 0; display: flex; justify-content: center; align-items: center; height: 100vh; }
          #paypal-button-container { width: 100%; max-width: 350px; }
        </style>
      </head>
      <body>
        <div id="paypal-button-container"></div>
        <script>
          console.log('PayPal SDK Loaded');
          try {
            paypal.Buttons({
              createOrder: function(data, actions) {
                console.log('Creating order');
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
                console.log('Order approved');
                return actions.order.capture().then(function(details) {
                  console.log('Order captured', details);
                  window.flutter_inappwebview.callHandler('onSuccess', JSON.stringify(details));
                });
              },
              onCancel: function(data) {
                console.log('Payment cancelled');
                window.flutter_inappwebview.callHandler('onCancel');
              },
              onError: function(err) {
                console.error('PayPal Error', err);
                window.flutter_inappwebview.callHandler('onError', err.toString());
              }
            }).render('#paypal-button-container').catch(function(error) {
              console.error('Failed to render PayPal Buttons', error);
              window.flutter_inappwebview.callHandler('onError', 'Failed to render buttons: ' + error.toString());
            });
          } catch (error) {
            console.error('PayPal Buttons initialization error', error);
            window.flutter_inappwebview.callHandler('onError', 'Initialization error: ' + error.toString());
          }
        </script>
      </body>
    </html>
    """;

    return Scaffold(
      appBar: AppBar(
        title: const Text('PayPal Checkout'),
      ),
      body: InAppWebView(
        initialData: InAppWebViewInitialData(data: htmlContent),
        onWebViewCreated: (controller) {
          controller.addJavaScriptHandler(
            handlerName: 'onSuccess',
            callback: (args) {
              try {
                Map<String, dynamic> details = jsonDecode(args[0]);
                onSuccess(details);
              } catch (e) {
                onError('Invalid response: ${args[0]}');
              }
            },
          );
          controller.addJavaScriptHandler(
            handlerName: 'onCancel',
            callback: (args) {
              onCancel();
            },
          );
          controller.addJavaScriptHandler(
            handlerName: 'onError',
            callback: (args) {
              onError(args.isNotEmpty ? args[0] : 'Unknown error');
            },
          );
        },
        onLoadStop: (controller, url) {
          debugPrint("WebView loaded: $url");
        },
        onLoadError: (controller, url, code, message) {
          debugPrint("WebView load error: $message (Code: $code)");
          onError("Failed to load PayPal payment page: $message");
        },
      ),
    );
  }
}