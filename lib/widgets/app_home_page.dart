import 'package:flutter/material.dart';
import 'package:wows_kokomi_app/widgets/app_darwer.dart';
import 'package:wows_kokomi_app/widgets/app_recent_page.dart';
import 'package:wows_kokomi_app/widgets/app_tools_page.dart';
import 'package:wows_kokomi_app/widgets/ship_list_page.dart';
import 'package:wows_kokomi_app/widgets/user_info_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  static const List<Widget> _pages = <Widget>[
    UserInfoPage(),
    RecentPage(),
    ShipListPage(),
    ToolsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('KOKOMI APP')),
      drawer: const AppDrawer(),
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.grey),
            label: '玩家信息',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business, color: Colors.grey),
            label: 'Recent',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_boat, color: Colors.grey),
            label: '船只列表',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.school,
              color: Colors.grey,
            ),
            label: '小工具',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.grey, // 设置选中项的文字颜色
        unselectedItemColor: Colors.grey, // 设置未选中项的文字颜色
      ),
    );
  }
}

