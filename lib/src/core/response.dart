import 'package:http/http.dart' as http;

class AWSResponse {
  http.Response rawResponse;
  AWSResponse(this.rawResponse);
}