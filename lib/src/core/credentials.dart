
class Credentials {
  final String accessKey;

  final String secretKey;

  final String sessionToken;

  /// AWS credentials.
  Credentials({this.accessKey, this.secretKey, this.sessionToken}) {
    assert(accessKey != null);
    assert(secretKey != null);
  }
}

class SharedCredentials implements Credentials {
  String accessKey;

  String secretKey;

  String sessionToken;

  SharedCredentials({profile, configLocation}){
    //TODO: read config file and set creds
  }
}