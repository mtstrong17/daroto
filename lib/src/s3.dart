import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

import './aws.dart';

import './core/config.dart';
import './core/response.dart';

class S3 extends AWS {

  S3([Config config]) : super('s3', config) {
    httpClient = http.Client();
    this.config.endpoint = this.config.endpoint ?? "https://s3.amazonaws.com";
  }

  ///
  Future<String> listBuckets() async {
    Map<String, String> headers = {
      'X-Amz-Content-Sha256': sha256.convert(utf8.encode('')).toString()
    };
    AWSResponse res = await request(
      url: '${this.config.endpoint.toString()}/',
      headers: headers,
      regionOverride: 'us-east-1'
    );
    return res.rawResponse.body;
  }
}
