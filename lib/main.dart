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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: '总战绩'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return  SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ElevatedButton(
            child: const Text("测试"),
            onPressed: _loading ? null : getModle,
          ),
          Container(
            width: MediaQuery.of(context).size.width - 50.0,
            child: Text(_text!.replaceAll(RegExp(r"\s"), "")),
          )
        ],
      ),
    );
  }
}
