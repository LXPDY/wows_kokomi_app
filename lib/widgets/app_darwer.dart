import 'package:flutter/material.dart';
import 'package:wows_kokomi_app/widgets/app_contributer.dart';
import 'package:wows_kokomi_app/widgets/user_search_view.dart';

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
              'TODO:玩家信息',
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
              // 在这里执行跳转到搜索界面的操作
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserInputPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.supervised_user_circle),
            title: const Text('感谢名单'),
            onTap: () {
              // 在这里执行跳转到搜索界面的操作
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
