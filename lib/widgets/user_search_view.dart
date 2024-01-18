import 'package:flutter/material.dart';
import 'package:wows_kokomi_app/models/server_name.dart';
import 'package:wows_kokomi_app/widgets/user_search_list_view.dart';

class UserInputPage extends StatefulWidget {
  const UserInputPage({Key? key}) : super(key: key);

  @override
  State<UserInputPage> createState() => _UserInputPageState();
}

class _UserInputPageState extends State<UserInputPage> {
  ServerName? _selectedServerName;
  final TextEditingController _userNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _userNameController.dispose();
    super.dispose();
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
                  decoration: const InputDecoration(
                    labelText: ' 用户名',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 12),
                    border: OutlineInputBorder(),
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserDataListPage(
                                  serverName: _selectedServerName!,
                                  userName: _userNameController.text,
                                ),
                              ),
                            );
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
