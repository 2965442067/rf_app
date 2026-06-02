import 'package:http/http.dart' as http;

class RFApi {
  final String baseUrl;

  RFApi(this.baseUrl);

  Future<void> sendRf(String id) async {
    await http.get(Uri.parse("$baseUrl/sendRf?id=$id"));
  }

  Future<String> getList() async {
    final res = await http.get(Uri.parse("$baseUrl/JsRf"));
    return res.body;
  }
}