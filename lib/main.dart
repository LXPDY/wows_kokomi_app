import 'package:flutter/material.dart';
import 'package:wows_kokomi_app/widgets/main_page/app_home_page.dart';

void main() {
  runApp(const MyApp());
}

class AppTheme {
  static ThemeData build() {
    return ThemeData(
      fontFamily: 'SourceHanSansCN',
      // 其他主题设置
      textTheme: const TextTheme(
        bodyText1: TextStyle(fontWeight: FontWeight.w500),
        bodyText2: TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.build(),
      home: const MyHomePage(),
      builder: (BuildContext context, Widget? child) {
        // 获取当前 MediaQuery 数据,限制字体大小
        final mediaQueryData = MediaQuery.of(context);
        final newMediaQueryData = mediaQueryData.copyWith(textScaleFactor: 1.0);
        return MediaQuery(
          data: newMediaQueryData,
          child: child!,
        );
      },
    );
  }
}
