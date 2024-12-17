// To parse this JSON data, do
//
//     final gateway = gatewayFromMap(jsonString);

import 'dart:convert';

class Gateway {
  Gateway({
    this.notifyUrl,
    this.cancelUrl,
    this.mode,
    this.customerKey,
    this.publicKey,
    this.privateKey,
    this.plan,
    this.paymentIntent,  this.sessionId,
  });

  final String? notifyUrl;
  final String? cancelUrl;
  final String? mode;
  final String? publicKey;
  final String? privateKey;
  final String? paymentIntent;
  final String? sessionId;
  final String? customerKey;
  final String? plan;

  bool get sandbox => mode == 'sandbox';

  Gateway copyWith({
    String? notifyUrl,
    String? cancelUrl,
    String? mode,
    String? publicKey,
    String? customerKey,
    String? privateKey,
    String? paymentIntent,
    String? sessionId,
    String? plan,
  }) =>
      Gateway(
        notifyUrl: notifyUrl ?? this.notifyUrl,
        cancelUrl: cancelUrl ?? this.cancelUrl,
        mode: mode ?? this.mode,
        publicKey: publicKey ?? this.publicKey,
        privateKey: privateKey ?? this.privateKey,
        customerKey: customerKey ?? this.customerKey,
        paymentIntent: paymentIntent ?? this.paymentIntent,
        sessionId: sessionId ?? this.sessionId,
        plan: plan ?? this.plan,
      );

  factory Gateway.fromJson(String str) => Gateway.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Gateway.fromMap(Map<String, dynamic> json) => Gateway(
        notifyUrl: json["notifyURL"],
        cancelUrl: json["cancelURL"],
        mode: json["mode"],
        publicKey: json["public_key"],
        privateKey: json["private_key"],
        customerKey: (json["customer_key"] ?? {})['id'],
        paymentIntent: json["payment_intent"],
        sessionId: json["session_id"],
        plan: json["plan"],
      );

  Map<String, dynamic> toMap() => {
        "notifyURL": notifyUrl,
        "cancelURL": cancelUrl,
        "mode": mode,
        "public_key": publicKey,
        "customer_key": customerKey,
        "private_key": privateKey,
        "payment_intent": paymentIntent,
        "session_id": sessionId,
        "plan": plan,
      };
}

class PaymentIntent {
  PaymentIntent({
    this.id,
    this.object,
    this.allowedSourceTypes,
    this.amount,
    this.amountCapturable,
    this.amountReceived,
    this.application,
    this.applicationFeeAmount,
    this.automaticPaymentMethods,
    this.canceledAt,
    this.cancellationReason,
    this.captureMethod,
    this.charges,
    this.clientSecret,
    this.confirmationMethod,
    this.created,
    this.currency,
    this.customer,
    this.description,
    this.invoice,
    this.lastPaymentError,
    this.livemode,
    this.metadata,
    this.nextAction,
    this.nextSourceAction,
    this.onBehalfOf,
    this.paymentMethod,
    this.paymentMethodOptions,
    this.paymentMethodTypes,
    this.processing,
    this.receiptEmail,
    this.review,
    this.setupFutureUsage,
    this.shipping,
    this.source,
    this.statementDescriptor,
    this.statementDescriptorSuffix,
    this.status,
    this.transferData,
    this.transferGroup,
  });

  final String? id;
  final String? object;
  final List<String>? allowedSourceTypes;
  final int? amount;
  final int? amountCapturable;
  final int? amountReceived;
  final dynamic application;
  final dynamic applicationFeeAmount;
  final dynamic automaticPaymentMethods;
  final dynamic canceledAt;
  final dynamic cancellationReason;
  final String? captureMethod;
  final Charges? charges;
  final String? clientSecret;
  final String? confirmationMethod;
  final int? created;
  final String? currency;
  final dynamic customer;
  final dynamic description;
  final dynamic invoice;
  final dynamic lastPaymentError;
  final bool? livemode;
  final List<dynamic>? metadata;
  final dynamic nextAction;
  final dynamic nextSourceAction;
  final dynamic onBehalfOf;
  final dynamic paymentMethod;
  final PaymentMethodOptions? paymentMethodOptions;
  final List<String>? paymentMethodTypes;
  final dynamic processing;
  final dynamic receiptEmail;
  final dynamic review;
  final dynamic setupFutureUsage;
  final dynamic shipping;
  final dynamic source;
  final dynamic statementDescriptor;
  final dynamic statementDescriptorSuffix;
  final String? status;
  final dynamic transferData;
  final dynamic transferGroup;

  PaymentIntent copyWith({
    String? id,
    String? object,
    List<String>? allowedSourceTypes,
    int? amount,
    int? amountCapturable,
    int? amountReceived,
    dynamic application,
    dynamic applicationFeeAmount,
    dynamic automaticPaymentMethods,
    dynamic canceledAt,
    dynamic cancellationReason,
    String? captureMethod,
    Charges? charges,
    String? clientSecret,
    String? confirmationMethod,
    int? created,
    String? currency,
    dynamic customer,
    dynamic description,
    dynamic invoice,
    dynamic lastPaymentError,
    bool? livemode,
    List<dynamic>? metadata,
    dynamic nextAction,
    dynamic nextSourceAction,
    dynamic onBehalfOf,
    dynamic paymentMethod,
    PaymentMethodOptions? paymentMethodOptions,
    List<String>? paymentMethodTypes,
    dynamic processing,
    dynamic receiptEmail,
    dynamic review,
    dynamic setupFutureUsage,
    dynamic shipping,
    dynamic source,
    dynamic statementDescriptor,
    dynamic statementDescriptorSuffix,
    String? status,
    dynamic transferData,
    dynamic transferGroup,
  }) =>
      PaymentIntent(
        id: id ?? this.id,
        object: object ?? this.object,
        allowedSourceTypes: allowedSourceTypes ?? this.allowedSourceTypes,
        amount: amount ?? this.amount,
        amountCapturable: amountCapturable ?? this.amountCapturable,
        amountReceived: amountReceived ?? this.amountReceived,
        application: application ?? this.application,
        applicationFeeAmount: applicationFeeAmount ?? this.applicationFeeAmount,
        automaticPaymentMethods:
            automaticPaymentMethods ?? this.automaticPaymentMethods,
        canceledAt: canceledAt ?? this.canceledAt,
        cancellationReason: cancellationReason ?? this.cancellationReason,
        captureMethod: captureMethod ?? this.captureMethod,
        charges: charges ?? this.charges,
        clientSecret: clientSecret ?? this.clientSecret,
        confirmationMethod: confirmationMethod ?? this.confirmationMethod,
        created: created ?? this.created,
        currency: currency ?? this.currency,
        customer: customer ?? this.customer,
        description: description ?? this.description,
        invoice: invoice ?? this.invoice,
        lastPaymentError: lastPaymentError ?? this.lastPaymentError,
        livemode: livemode ?? this.livemode,
        metadata: metadata ?? this.metadata,
        nextAction: nextAction ?? this.nextAction,
        nextSourceAction: nextSourceAction ?? this.nextSourceAction,
        onBehalfOf: onBehalfOf ?? this.onBehalfOf,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        paymentMethodOptions: paymentMethodOptions ?? this.paymentMethodOptions,
        paymentMethodTypes: paymentMethodTypes ?? this.paymentMethodTypes,
        processing: processing ?? this.processing,
        receiptEmail: receiptEmail ?? this.receiptEmail,
        review: review ?? this.review,
        setupFutureUsage: setupFutureUsage ?? this.setupFutureUsage,
        shipping: shipping ?? this.shipping,
        source: source ?? this.source,
        statementDescriptor: statementDescriptor ?? this.statementDescriptor,
        statementDescriptorSuffix:
            statementDescriptorSuffix ?? this.statementDescriptorSuffix,
        status: status ?? this.status,
        transferData: transferData ?? this.transferData,
        transferGroup: transferGroup ?? this.transferGroup,
      );

  factory PaymentIntent.fromJson(String str) =>
      PaymentIntent.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PaymentIntent.fromMap(Map<String, dynamic> json) => PaymentIntent(
        id: json["id"],
        object: json["object"],
        allowedSourceTypes: json["allowed_source_types"] == null
            ? null
            : List<String>.from(
                (json["allowed_source_types"] ?? []).map((x) => x)),
        amount: json["amount"],
        amountCapturable: json["amount_capturable"],
        amountReceived: json["amount_received"],
        application: json["application"],
        applicationFeeAmount: json["application_fee_amount"],
        automaticPaymentMethods: json["automatic_payment_methods"],
        canceledAt: json["canceled_at"],
        cancellationReason: json["cancellation_reason"],
        captureMethod: json["capture_method"],
        charges:
            json["charges"] == null ? null : Charges.fromMap(json["charges"]),
        clientSecret: json["client_secret"],
        confirmationMethod: json["confirmation_method"],
        created: json["created"],
        currency: json["currency"],
        customer: json["customer"],
        description: json["description"],
        invoice: json["invoice"],
        lastPaymentError: json["last_payment_error"],
        livemode: json["livemode"] ?? false,
        metadata: List<dynamic>.from((json["metadata"] ?? []).map((x) => x)),
        nextAction: json["next_action"],
        nextSourceAction: json["next_source_action"],
        onBehalfOf: json["on_behalf_of"],
        paymentMethod: json["payment_method"],
        paymentMethodOptions: json["payment_method_options"] == null
            ? null
            : PaymentMethodOptions.fromMap(json["payment_method_options"]),
        paymentMethodTypes: json["payment_method_types"] == null
            ? null
            : List<String>.from(json["payment_method_types"].map((x) => x)),
        processing: json["processing"],
        receiptEmail: json["receipt_email"],
        review: json["review"],
        setupFutureUsage: json["setup_future_usage"],
        shipping: json["shipping"],
        source: json["source"],
        statementDescriptor: json["statement_descriptor"],
        statementDescriptorSuffix: json["statement_descriptor_suffix"],
        status: json["status"],
        transferData: json["transfer_data"],
        transferGroup: json["transfer_group"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "object": object,
        "allowed_source_types":
            List<dynamic>.from((allowedSourceTypes ?? []).map((x) => x)),
        "amount": amount,
        "amount_capturable": amountCapturable,
        "amount_received": amountReceived,
        "application": application,
        "application_fee_amount": applicationFeeAmount,
        "automatic_payment_methods": automaticPaymentMethods,
        "canceled_at": canceledAt,
        "cancellation_reason": cancellationReason,
        "capture_method": captureMethod,
        "charges": charges?.toMap(),
        "client_secret": clientSecret,
        "confirmation_method": confirmationMethod,
        "created": created,
        "currency": currency,
        "customer": customer,
        "description": description,
        "invoice": invoice,
        "last_payment_error": lastPaymentError,
        "livemode": livemode,
        "metadata": List<dynamic>.from((metadata ?? []).map((x) => x)),
        "next_action": nextAction,
        "next_source_action": nextSourceAction,
        "on_behalf_of": onBehalfOf,
        "payment_method": paymentMethod,
        "payment_method_options": paymentMethodOptions?.toMap(),
        "payment_method_types":
            List<dynamic>.from((paymentMethodTypes ?? []).map((x) => x)),
        "processing": processing,
        "receipt_email": receiptEmail,
        "review": review,
        "setup_future_usage": setupFutureUsage,
        "shipping": shipping,
        "source": source,
        "statement_descriptor": statementDescriptor,
        "statement_descriptor_suffix": statementDescriptorSuffix,
        "status": status,
        "transfer_data": transferData,
        "transfer_group": transferGroup,
      };
}

class Charges {
  Charges({
    this.object,
    this.data,
    this.hasMore,
    this.totalCount,
    this.url,
  });

  final String? object;
  final List<dynamic>? data;
  final bool? hasMore;
  final int? totalCount;
  final String? url;

  Charges copyWith({
    String? object,
    List<dynamic>? data,
    bool? hasMore,
    int? totalCount,
    String? url,
  }) =>
      Charges(
        object: object ?? this.object,
        data: data ?? this.data,
        hasMore: hasMore ?? this.hasMore,
        totalCount: totalCount ?? this.totalCount,
        url: url ?? this.url,
      );

  factory Charges.fromJson(String str) => Charges.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Charges.fromMap(Map<String, dynamic> json) => Charges(
        object: json["object"],
        data: List<dynamic>.from((json["data"] ?? []).map((x) => x)),
        hasMore: json["has_more"],
        totalCount: json["total_count"],
        url: json["url"],
      );

  Map<String, dynamic> toMap() => {
        "object": object,
        "data": List<dynamic>.from((data ?? []).map((x) => x)),
        "has_more": hasMore,
        "total_count": totalCount,
        "url": url,
      };
}

class PaymentMethodOptions {
  PaymentMethodOptions({
    this.card,
  });

  final Card? card;

  PaymentMethodOptions copyWith({
    Card? card,
  }) =>
      PaymentMethodOptions(
        card: card ?? this.card,
      );

  factory PaymentMethodOptions.fromJson(String str) =>
      PaymentMethodOptions.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PaymentMethodOptions.fromMap(Map<String, dynamic> json) =>
      PaymentMethodOptions(
        card: json["card"] == null ? null : Card.fromMap(json["card"]),
      );

  Map<String, dynamic> toMap() => {
        "card": card?.toMap(),
      };
}

class Card {
  Card({
    this.installments,
    this.network,
    this.requestThreeDSecure,
  });

  final dynamic installments;
  final dynamic network;
  final String? requestThreeDSecure;

  Card copyWith({
    dynamic installments,
    dynamic network,
    String? requestThreeDSecure,
  }) =>
      Card(
        installments: installments ?? this.installments,
        network: network ?? this.network,
        requestThreeDSecure: requestThreeDSecure ?? this.requestThreeDSecure,
      );

  factory Card.fromJson(String str) => Card.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Card.fromMap(Map<String, dynamic> json) => Card(
        installments: json["installments"],
        network: json["network"],
        requestThreeDSecure: json["request_three_d_secure"],
      );

  Map<String, dynamic> toMap() => {
        "installments": installments,
        "network": network,
        "request_three_d_secure": requestThreeDSecure,
      };
}
