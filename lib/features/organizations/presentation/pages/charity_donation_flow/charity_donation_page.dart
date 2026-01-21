import 'package:flutter/material.dart';
import 'package:kiind_web/core/base_page.dart';
import 'package:kiind_web/core/models/charity_model.dart';
import 'package:kiind_web/core/models/payment_detail.dart';
import 'package:kiind_web/core/router/route_paths.dart';
import 'package:kiind_web/features/organizations/presentation/providers/charity_donation_page_provider.dart';

class CharityDonationPage extends StatefulWidget {
  final Map<String, dynamic>? arguments;
  const CharityDonationPage({Key? key, this.arguments}) : super(key: key);

  @override
  _CharityDonationPageState createState() => _CharityDonationPageState();
}

class _CharityDonationPageState extends State<CharityDonationPage> {
  @override
  Widget build(BuildContext context) {
    return BasePage<CharityDonationPageProvider>(
      child: null,
      provider: CharityDonationPageProvider(),
      builder: (context, provider, child) {
        // Initialize the provider with arguments if available
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (widget.arguments != null) {
            provider.setArguments(widget.arguments!);
          }
        });

        return Scaffold(
          appBar: AppBar(
            title: const Text('Donate to Charity'),
            centerTitle: true,
          ),
          body: provider.loading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    // Charity Info Section
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                              provider.charity?.imageUrl ?? '',
                            ),
                            backgroundColor: Colors.grey[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            provider.charity?.title ?? 'Loading...',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            provider.charity?.details ?? 'Details loading...',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Donation Amount Input
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Text(
                            'Enter donation amount',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: provider.amountController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: const InputDecoration(
                              labelText: 'Amount (£)',
                              border: OutlineInputBorder(),
                              prefixText: '£',
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => provider.validateAndProceed(context),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            child: const Text('Continue to Payment'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
