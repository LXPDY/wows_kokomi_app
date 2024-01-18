import 'package:flutter/material.dart';
import 'package:wows_kokomi_app/models/error_model.dart';
import 'package:wows_kokomi_app/models/server_name.dart';
import 'package:wows_kokomi_app/models/user_seach_model.dart';
import 'package:wows_kokomi_app/widgets/error_widget.dart';

class UserDataListPage extends StatefulWidget {
  UserDataListPage({Key? key, required this.serverName, required this.userName}) : super(key: key);
  ServerName serverName;
  String userName;
  int limit = 10;
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

  void fetchData() async {
    UserList userList = UserList();
    await userList.init(widget.serverName, widget.userName, widget.limit);
    if (userList.userListModel != null) {
      data = userList.userListModel?.data;
      setState(() {});
    } else {
      errorWidge(userList.errorModel);
    }
  }
  void errorWidge(ErrorHttpModel? errorHttpModel){
          Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HttpErrorWidget(errorModel: errorHttpModel)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('User Data List')),
        body: data == null
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: data!.length,
                itemBuilder: (context, index) {
                  final userData = data![index];
                  return InkWell(
                    onTap: () {
                      // 在这里处理点击事件
                      print('Clicked on ${userData.name}');
                    },
                    child: ListTile(
                      title: Text(userData.name ?? ''),
                      subtitle: Text('AID: ${userData.aid}'),
                    ),
                  );
                },
              ));
  }
}
