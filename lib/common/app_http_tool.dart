import 'package:http/http.dart' as http;
import 'package:http/http.dart';

/// Http请求工具类，通过url获得http返回
class AppHttpTool {
  Future<Response> httpGet(String url) async {
    Response response = http.Response("http_request_unknown_fail", 404);
    try {
      response = await http.get(
      Uri.parse(url),
        headers: {
          'Authorization': 'Bearer user123456', // 添加Authorization头
        },
      );
    } catch (e) {
      response = http.Response("http_request_fail", 404);
    } 
    return response;
  }
  
}

final AppHttpTool httpTool = AppHttpTool();