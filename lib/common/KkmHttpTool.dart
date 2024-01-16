import 'package:http/http.dart' as http;
import 'package:wows_kokomi_app/models/TestModel.dart';

class KkmHttpTool {
  Future<TestModel> httpGet() async {
    String text;
    try {
      final response = await http.get(Uri.parse("http://www.wows-coral.com:443/test/"));
      text = response.body;
    } catch (e) {
      text = "失败";
    } 
    return TestModel(text);
  }
}

