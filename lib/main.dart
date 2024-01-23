import 'package:flutter/material.dart';
import 'package:wows_kokomi_app/common/user_global.dart';
import 'package:wows_kokomi_app/models/server_name.dart';
import 'package:wows_kokomi_app/widgets/darwer_page/app_account_page.dart';
import 'package:wows_kokomi_app/widgets/main_page/app_home_page.dart';
import 'package:wows_kokomi_app/widgets/search_page/user_search_list_view.dart';
import 'package:wows_kokomi_app/widgets/search_page/user_search_view.dart';

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.build(),
      home: FutureBuilder<String?>(
        future: LocalStorage.getDefaultAccount(),
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data != null) {
              final aidAndServerName = snapshot.data!.split(':');
              final aid = aidAndServerName[0];
              final serverName = ServerName.values
                  .firstWhere((element) => element.name == aidAndServerName[2]);
              return MyHomePage(
                  initialIndex: 0, aid: aid, serverName: serverName);
            } else {
              return const UserInputPage();
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      routes: {
        '/userInput': (context) => const UserInputPage(),
        '/userDataList': (context) => UserDataListPage(
            serverName:
                ModalRoute.of(context)!.settings.arguments as ServerName,
            userName: ModalRoute.of(context)!.settings.arguments as String),
        '/home': (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          final aid = args['aid'] as String;
          final serverName = args['serverName'] as ServerName;
          return MyHomePage(initialIndex: 0, aid: aid, serverName: serverName);
        },
        '/accountList': (context) => const AccountListPage(),
      },
    );
  }
}
