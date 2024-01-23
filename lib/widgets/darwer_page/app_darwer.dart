import 'package:flutter/material.dart';
import 'package:wows_kokomi_app/common/user_global.dart';
import 'package:wows_kokomi_app/models/server_name.dart';
import 'package:wows_kokomi_app/widgets/darwer_page/app_contributer.dart';
import 'package:wows_kokomi_app/widgets/main_page/app_home_page.dart';
import 'package:wows_kokomi_app/widgets/search_page/user_search_view.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: LocalStorage.getDefaultAccount(),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        String? userName;
        String? aid;
        ServerName? serverName;
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data != null) {
            final aidAndServerName = snapshot.data!.split(':');
            aid = aidAndServerName[0];
            userName = aidAndServerName[1];
            serverName = ServerName.values
                .firstWhere((element) => element.name == aidAndServerName[2]);
          }
        }
        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              GestureDetector(
                onTap: userName != null
                    ? () {
                        // 跳转到绑定用户主页的操作
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyHomePage(
                                initialIndex: 0,
                                aid: aid.toString(),
                                serverName: serverName!,
                              ),
                            ), (route) {
                          return false;
                        });
                      }
                    : null,
                child: DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Text(
                    userName ?? '未绑定',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.search),
                title: const Text('搜索玩家'),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UserInputPage()),
                    (route) {
                      if (route.settings.name == '/') {
                        return true;
                      }
                      if (route.settings.name == '/userInput') {
                        return true;
                      }
                      return !route.hashCode.runtimeType
                          .toString()
                          .contains('UserInputPage');
                    },
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.list),
                title: const Text('账户列表'),
                onTap: () {
                  Navigator.pushNamed(context, '/accountList');
                },
              ),
              ListTile(
                leading: const Icon(Icons.supervised_user_circle),
                title: const Text('感谢名单'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ContributorsPage()),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
