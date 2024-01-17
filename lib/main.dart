
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:wows_kokomi_app/common/kkm_http_tool.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WOWS KOKOMI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: '总战绩'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _loading = false;
  String? _text = "";
  final KkmHttpTool _httpTool = KkmHttpTool();
   getModle() async {
      setState(() {
      _loading = true;
    _text = "正在请求...";
    });
    Future<Response> response =_httpTool.httpGet("http://www.wows-coral.com:443/test/");
    response.then((res){
    setState(()  {
        _text = res.body;
        _loading = false;
    });
    });

  }

  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: _loading ? null : getModle,
            child: const Text("测试"),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width - 50.0,
            child: Text(_text!.replaceAll(RegExp(r"\s"), "")),
          )
        ],
      ),
    );
  }
}
