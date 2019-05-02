import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import './core/config.dart';
import './core/response.dart';
import './core/signer.dart';

import 's3.dart';

abstract class AWS {
  static Config globalConfig;

  @protected
  http.Client httpClient;
  
  final String service;

  Config config;

  AWS([this.service, config]) {
    this.config = config ?? Config.from(globalConfig);
  }

  factory AWS.S3([config]) => S3(config);

  @protected
  Future<AWSResponse> request(
      {String method: 'GET',
      Map<String, String> headers,
      String url,
      String regionOverride}) async {
    
    Uri uri = Uri.parse(url);
    String date = DateTime.now()
            .toUtc()
            .toIso8601String()
            .replaceAll('-', '')
            .replaceAll(':', '')
            .split('.')
            .first +
        'Z';
    headers.putIfAbsent('X-Amz-Date', () => date);
    headers.putIfAbsent('Host', () => uri.host);

    Signer.sign(
        method: 'GET',
        headers: headers,
        uri: uri,
        service: service,
        config: config,
        regionOverride: regionOverride);

    http.Response res = await httpClient.get(uri, headers: headers);

    return AWSResponse(res);
  }
}
