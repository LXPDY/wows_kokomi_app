import 'package:flutter/material.dart';
import 'package:wows_kokomi_app/common/user_global.dart';
import 'package:wows_kokomi_app/models/server_name.dart';
import 'package:wows_kokomi_app/widgets/search_page/user_search_list_view.dart';

class UserInputPage extends StatefulWidget {
  const UserInputPage({Key? key}) : super(key: key);

  @override
  State<UserInputPage> createState() => _UserInputPageState();
}

class _UserInputPageState extends State<UserInputPage> {
  ServerName? _selectedServerName;
  final TextEditingController _userNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<String> searchHistory = [];

  @override
  void initState() {
    super.initState();
    loadSearchHistory();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    super.dispose();
  }

  Future<void> loadSearchHistory() async {
    searchHistory = await LocalStorage.getSearchHistory();
    setState(() {});
  }

  Future<void> addToSearchHistory(String userName) async {
    await LocalStorage.addSearchHistory(userName);
    loadSearchHistory();
  }

  Future<void> removeFromSearchHistory(String userName) async {
    await LocalStorage.removeSearchHistory(userName);
    loadSearchHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('搜索玩家')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  style: const TextStyle(fontSize: 18),
                  controller: _userNameController,
                  decoration: InputDecoration(
                    labelText: ' 用户名',
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 12),
                    border: const OutlineInputBorder(),
                    suffixIcon: PopupMenuButton<String>(
                      icon: const Icon(Icons.arrow_drop_down),
                      itemBuilder: (BuildContext context) {
                        return searchHistory
                            .map<PopupMenuItem<String>>((String value) {
                          return PopupMenuItem<String>(
                            value: value,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(value),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    removeFromSearchHistory(value);
                                  },
                                ),
                              ],
                            ),
                          );
                        }).toList();
                      },
                      onSelected: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _userNameController.text = newValue;
                          });
                        }
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '用户名不能为空';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: '选择服务器',
                    border: const OutlineInputBorder(),
                    suffixIcon: PopupMenuButton<ServerName>(
                      icon: const Icon(Icons.arrow_drop_down),
                      itemBuilder: (BuildContext context) {
                        return ServerName.values
                            .map<PopupMenuItem<ServerName>>((ServerName value) {
                          return PopupMenuItem<ServerName>(
                            value: value,
                            child: Text(value.name),
                          );
                        }).toList();
                      },
                      onSelected: (ServerName? newValue) {
                        setState(() {
                          _selectedServerName = newValue;
                        });
                      },
                    ),
                  ),
                  readOnly: true,
                  controller: TextEditingController(
                    text: _selectedServerName?.name ?? '点击选择服务器',
                  ),
                  onTap: () {
                    // 防止打开键盘
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (_selectedServerName != null) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserDataListPage(
                                  serverName: _selectedServerName!,
                                  userName: _userNameController.text,
                                ),
                              ),
                            );
                            addToSearchHistory(_userNameController.text);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('服务器不能为空'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        }
                      },
                      child: const Text('搜索'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
