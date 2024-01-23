import 'package:flutter/material.dart';
import 'package:wows_kokomi_app/widgets/darwer_page/app_contributer.dart';
import 'package:wows_kokomi_app/widgets/search_page/user_search_view.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'WOWS KOKOMI',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text('搜索玩家'),
            onTap: () {
              // 跳转到搜索界面的操作
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const UserInputPage()),
                (route) {
                  // 保留类型为 UserInputPage 的页面，删除其他类型为 UserInputPage 的页面
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
              // 跳转到感谢名单
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContributorsPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
