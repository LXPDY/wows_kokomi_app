import 'package:flutter/material.dart';
import 'package:wows_kokomi_app/widgets/user_search_view.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  static const List<Widget> _pages = <Widget>[
    Text('TODO:个人信息'),
    Text('TODO:Recent战绩'),
    Text('TODO:小工具'),
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
      drawer: Drawer(
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
          ],
        ),
      ),
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '玩家信息',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Recent',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: '小工具',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}