import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wows_kokomi_app/models/error_model.dart';
import 'package:wows_kokomi_app/models/server_name.dart';
import 'package:wows_kokomi_app/models/user_seach_model.dart';
import 'package:wows_kokomi_app/widgets/error_widget.dart';

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

  @override
  void initState() {
    super.initState();
    fetchData();
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
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (kDebugMode) {
                          print('Clicked on ${userData.name}');
                        }
                        if (userData.aid == null) {
                          return;
                        }
                      },
                      child: ListTile(
                        title: Text(userData.name ?? ''),
                        subtitle: Text('${userData.aid}'),
                      ),
                    );
                  },
                )));
  }
}
