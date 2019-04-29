import 'dart:typed_data';
import 'dart:convert';

import 'package:http/http.dart' as http;

import './config.dart';
import './signer.dart';

class AWSRequest extends http.BaseRequest {
  String service;
  Config config;
  String _body;
  Uint8List _bodyBytes;
  String regionOverride;

  AWSRequest(
      {String method: 'GET',
      Uri url,
      this.service,
      this.config,
      this.regionOverride,
      Map<String, String> requestHeaders,
      String body: ''})
      : _body = (body),
        _bodyBytes = Uint8List.fromList(utf8.encode(body ?? '')),
        super(method, url) {
    headers..addAll(requestHeaders);
    String date = DateTime.now()
                .toUtc()
                .toIso8601String()
                .replaceAll('-', '')
                .replaceAll(':', '')
                .split('.')
                .first + 'Z';
    headers.putIfAbsent('X-Amz-Date', () => date);
    headers.putIfAbsent('Host', () => url.host);
  }

  @override
  http.ByteStream finalize() {
    Signer.sign(method: method, headers: headers, body: _body, url: url, service: service, config: config, regionOverride: regionOverride);
    super.finalize();
    return http.ByteStream.fromBytes(_bodyBytes);
  }
}
