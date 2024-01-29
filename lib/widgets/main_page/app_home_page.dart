import 'package:flutter/material.dart';
import 'package:wows_kokomi_app/models/error_model.dart';
import 'package:wows_kokomi_app/models/enum_name.dart';
import 'package:wows_kokomi_app/widgets/app_sys_page/error_widget.dart';
import 'package:wows_kokomi_app/widgets/darwer_page/app_darwer.dart';
import 'package:wows_kokomi_app/widgets/main_page/app_recent_page.dart';
import 'package:wows_kokomi_app/widgets/main_page/app_tools_page.dart';
import 'package:wows_kokomi_app/widgets/main_page/ship_list_page.dart';
import 'package:wows_kokomi_app/widgets/main_page/user_info_page.dart';

class MyHomePage extends StatefulWidget {
  final int initialIndex;
  final String aid;
  final ServerName serverName;
  const MyHomePage({Key? key, required this.initialIndex, required this.aid, required this.serverName}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  static final List<Widget> _pages = <Widget>[
    UserInfoPage(aid: '2023619512', serverName: ServerName.asia),
    const RecentPage(),
    const ShipListPage(aid: '2023619512', serverName: ServerName.asia),
    const ToolsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  void errorWidge(ErrorHttpModel? errorHttpModel) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => HttpErrorWidget(errorModel: errorHttpModel)),
    );
  }
  

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _pages[0] = UserInfoPage(aid: widget.aid, serverName: widget.serverName);
     _pages[2] = ShipListPage(aid: widget.aid, serverName: widget.serverName);
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
      ),
    );
  }
}
