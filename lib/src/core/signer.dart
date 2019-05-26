import 'dart:convert';

import 'package:crypto/crypto.dart';

import './config.dart';

class Signer {
  static sign(
      {String method,
      Map<String, String> headers,
      Uri uri,
      String body: '',
      String service,
      String regionOverride,
      Config config}) {
    List<String> sortedqueryKeys = uri.queryParameters.keys.toList()..sort();
    String canonicalQuery = sortedqueryKeys
        .map((key) => Uri.encodeFull('$key=${uri.queryParameters[key]}'))
        .join('&');
    List<String> canonicalHeaders = headers.keys
        .map((key) => '${key.toLowerCase()}:${headers[key].trim()}')
        .toList()
          ..sort();
    String signedHeaders =
        (headers.keys.toList()..sort()).map((s) => s.toLowerCase()).join(';');

    String payloadHash = headers['X-Amz-Content-Sha256'] ??
        sha256.convert(utf8.encode(body ?? '')).toString();
    String canonical = ([
      method.toUpperCase(),
      Uri.encodeFull(uri.path),
      canonicalQuery,
    ]
          ..addAll(canonicalHeaders)
          ..addAll([
            '',
            signedHeaders,
            payloadHash,
          ]))
        .join('\n');

    String date = headers['X-Amz-Date'];

    List<String> credentialList = [
      date.substring(0, 8),
      regionOverride ?? config.region,
      service,
      'aws4_request',
    ];

    String canonicalHash = sha256.convert(utf8.encode(canonical)).toString();

    String toSign = [
      'AWS4-HMAC-SHA256',
      date,
      credentialList.join('/'),
      canonicalHash,
    ].join('\n');

    List<int> signingKey = credentialList
        .fold(utf8.encode('AWS4${config.credentials.secretKey}'),
            (List<int> key, String s) {
      Hmac hmac = new Hmac(sha256, key);
      return hmac.convert(utf8.encode(s)).bytes;
    });
    String signature =
        new Hmac(sha256, signingKey).convert(utf8.encode(toSign)).toString();
    if (config.credentials.sessionToken != null) {
      headers['X-Amz-Security-Token'] = config.credentials.sessionToken;
    }

    String auth = 'AWS4-HMAC-SHA256 '
        'Credential=${config.credentials.accessKey}/${credentialList.join('/')}, '
        'SignedHeaders=$signedHeaders, '
        'Signature=$signature';

    headers['Authorization'] = auth;
  }
}
