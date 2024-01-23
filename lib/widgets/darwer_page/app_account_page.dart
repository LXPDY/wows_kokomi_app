import 'package:flutter/material.dart';
import 'package:wows_kokomi_app/common/user_global.dart';
import 'package:wows_kokomi_app/models/server_name.dart';
import 'package:wows_kokomi_app/widgets/main_page/app_home_page.dart';

class AccountListPage extends StatefulWidget {
  const AccountListPage({Key? key}) : super(key: key);

  @override
  State<AccountListPage> createState() => _AccountListPageState();
}

class _AccountListPageState extends State<AccountListPage> {
  List<String> accountList = [];

  @override
  void initState() {
    super.initState();
    fetchAccountList();
  }

  Future<void> fetchAccountList() async {
    accountList = await LocalStorage.getAccountList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('已添加账户列表')),
      body: ListView.builder(
        itemCount: accountList.length,
        itemBuilder: (context, index) {
          final account = accountList[index];
          final aidAndServerName = account.split(':');
          final aid = aidAndServerName[0];
          final name = aidAndServerName[1];
          final serverName = ServerName.values
              .firstWhere((element) => element.name == aidAndServerName[2]);
          return InkWell(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyHomePage(
                        initialIndex: 0,
                        aid: aid.toString(),
                        serverName: serverName,
                      ),
                    ), (route) {
                  return false;
                });
              },
              child: ListTile(
                title: Text('$name - ${serverName.str}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await LocalStorage.removeAccountFromList(
                        aid, name, serverName);
                    fetchAccountList();
                  },
                ),
              ));
        },
      ),
    );
  }
}
