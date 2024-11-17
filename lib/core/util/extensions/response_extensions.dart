import 'package:dio/dio.dart';
import 'package:kiind_web/core/models/res_model.dart';
import 'package:kiind_web/core/util/extensions/string_extensions.dart';

extension Validation on Response {
  bool get isValid => isSuccessful && hasInfo;
  bool get isInValid => !isValid;

  bool get isSuccessful => ((statusCode ?? 300) < 300);
  bool get isUnSuccessful => !isSuccessful;

  String? get token => info?.token;
  bool get hasToken => isSuccessful && (info?.hasToken ?? false);

  String? get errorMessage =>
      (data is Map) ? _extractErrors(info) : 'It\'s not you; it\'s us. 😔';
  dynamic get payload => isSuccessful ? info?.data : null;

  bool get hasInfo => info != null;
  ClientResponse? get info => ClientResponse.fromMap(data);

  String? _extractErrors(ClientResponse? res) {
    String? errors;

    if (res?.message.isNotNullOrEmpty ?? false) {
      errors = '';
      for (var v in res!.message!.values) {
        errors = '${errors ?? ''} ' + v.join(' ');
      }
    } else {
      errors = res?.messageString;
    }

    return errors;
  }
}
