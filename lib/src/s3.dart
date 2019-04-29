import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

import './aws.dart';

import './core/request.dart';
import './core/config.dart';

class S3 extends AWS {
  static const String _service = 's3';

  http.Client _httpClient;
  S3([Config config])
      : _httpClient = http.Client(),
        super(config) {
    this.config.endpoint = this.config.endpoint ?? "https://s3.amazonaws.com";
    // this.config.endpoint = this.config.endpoint ?? "https://${_service}.${this.config.region}.amazonaws.com";
  }

  ///
  Future<String> listBuckets() async {
    print("MIKE1: ${DateTime.now().millisecondsSinceEpoch}");
    http.StreamedResponse responseStream = await _httpClient.send(AWSRequest(
      method: 'GET',
      url: Uri.parse("${config.endpoint}/"),
      service: _service,
      regionOverride: 'us-east-1',
      config: config,
      requestHeaders: {
        'X-Amz-Content-Sha256': sha256.convert(utf8.encode('')).toString()
      },
    ));
    print("MIKE2: ${DateTime.now().millisecondsSinceEpoch}");

    http.Response response = await http.Response.fromStream(responseStream);
    print("MIKE3: ${DateTime.now().millisecondsSinceEpoch}");

    return String.fromCharCodes(response.bodyBytes);
  }
}
