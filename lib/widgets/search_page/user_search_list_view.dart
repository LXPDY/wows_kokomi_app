import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wows_kokomi_app/common/user_global.dart';
import 'package:wows_kokomi_app/models/error_model.dart';
import 'package:wows_kokomi_app/models/server_name.dart';
import 'package:wows_kokomi_app/models/user_seach_model.dart';
import 'package:wows_kokomi_app/widgets/app_sys_page/error_widget.dart';
import 'package:wows_kokomi_app/widgets/main_page/app_home_page.dart';

const int limit = 10;
final ListUserData searchLastData =
    ListUserData.createData("列表最多展示$limit个用户数据,如果未搜到请更详细地搜索,或检查用户名", null);
final ListUserData searchErrorData =
    ListUserData.createData("获取用户列表为空,请检查网络环境以及用户名后刷新,或联系开发者", null);

class UserDataListPage extends StatefulWidget {
  const UserDataListPage(
      {Key? key, required this.serverName, required this.userName})
      : super(key: key);
  final ServerName serverName;
  final String userName;
  @override
  State<UserDataListPage> createState() => _UserDataListPageState();
}

class _UserDataListPageState extends State<UserDataListPage> {
  List<ListUserData>? data;
  List<String> accountList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchAccountList();
  }

  Future<void> fetchData() async {
    UserList userList = UserList();
    await userList.init(widget.serverName, widget.userName, limit);
    if (userList.userListModel != null) {
      data = userList.userListModel?.data;
      data?.add(searchLastData);
      setState(() {});
    } else {
      data = <ListUserData>[];
      data?.add(searchErrorData);
      setState(() {});
      errorWidge(userList.errorModel);
    }
  }

  void errorWidge(ErrorHttpModel? errorHttpModel) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => HttpErrorWidget(errorModel: errorHttpModel)),
    );
  }

  Future<void> fetchAccountList() async {
    accountList = await LocalStorage.getAccountList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('搜索结果')),
        body: data == null
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: fetchData,
                child: ListView.builder(
                  itemCount: data!.length,
                  itemBuilder: (context, index) {
                    final userData = data![index];
                    return InkWell(
                      onTap: () {
                        // 在这里处理点击事件
                        if (userData.aid == null) {
                          return;
                        }
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyHomePage(
                                initialIndex: 0,
                                aid: userData.aid!.toString(),
                                serverName: widget.serverName,
                              ),
                            ), (route) {
                          return false;
                        });
                      },
                      child: ListTile(
                        title: Text(userData.name ?? ''),
                        subtitle: Text('${userData.aid}'),
                        trailing: (!accountList.contains(
                                    '${userData.aid}:${userData.name}:${widget.serverName.name}') &&
                                userData.aid != null)
                            ? IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () async {
                                  await LocalStorage.addAccountToList(
                                      userData.aid.toString(),
                                      userData.name!,
                                      widget.serverName);
                                  fetchAccountList();
                                },
                              )
                            : null,
                      ),
                    );
                  },
                )));
  }
}
