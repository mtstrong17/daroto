import './credentials.dart';

class Config {
  String _region;

  Credentials _credentials;

  String _endpoint;

  Config({region, credentials, endpoint})
      : _region = region,
        _credentials = credentials,
        _endpoint = endpoint;

  get region => _region;
  set region(String value) => _region = value;

  get credentials => _credentials;
  set credentials(Credentials value) => _credentials = value;

  get endpoint => _endpoint;
  set endpoint(String value) => _endpoint = value;

  factory Config.from(Config config) => Config(
      region: config.region,
      credentials: config.credentials,
      endpoint: config.endpoint);
}
