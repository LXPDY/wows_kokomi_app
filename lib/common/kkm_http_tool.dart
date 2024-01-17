import 'package:http/http.dart' as http;
import 'package:http/http.dart';

/// Http请求工具类，通过url获得http返回
class KkmHttpTool {
  Future<Response> httpGet(String url) async {
    Response response = http.Response("http_request_unknown_fail", 404);
    try {
      response = await http.get(Uri.parse(url));
    } catch (e) {
      response = http.Response("http_request_fail", 404);
    } 
    return response;
  }
}

KkmHttpTool httpTool = KkmHttpTool();