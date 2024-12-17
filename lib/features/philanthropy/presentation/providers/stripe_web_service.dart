import 'dart:js_util' as js_util;
import 'dart:ui';

class StripeService {
  final dynamic stripe;

  StripeService(String publishableKey)
      : stripe = js_util.callMethod(window, 'Stripe', [publishableKey]);

  void createPaymentRequestButton({
    required String countryCode,
    required String currency,
    required int amount,
    required void Function(dynamic) onPaymentSuccess,
    required void Function(dynamic) onPaymentFailure,
  }) {
    final paymentRequest = js_util.callMethod(
      stripe,
      'paymentRequest',
      [
        {
          'country': countryCode,
          'currency': currency,
          'total': {
            'label': 'Total',
            'amount': amount, // In smallest currency unit (e.g., cents)
          },
          'requestPayerName': true,
          'requestPayerEmail': true,
        }
      ],
    );

    final elements = js_util.callMethod(stripe, 'elements', []);

    final prButton = js_util.callMethod(elements, 'create', [
      'paymentRequestButton',
      {'paymentRequest': paymentRequest}
    ]);

    paymentRequest.then((result) {
      if (result['canMakePayment']) {
        js_util.callMethod(prButton, 'mount', ['#payment-request-button']);
      } else {
        print('Payment Request Button not supported');
      }
    });

    paymentRequest.on('paymentmethod', (event) {
      // Call your backend to process the payment
      js_util.callMethod(event, 'complete', ['success']);
      onPaymentSuccess(event);
    }).catchError((error) {
      onPaymentFailure(error);
    });
  }
}
