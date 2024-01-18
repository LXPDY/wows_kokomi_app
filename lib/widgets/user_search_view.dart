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
      appBar: AppBar(title: const Text('搜索用户')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _userNameController,
                  decoration: const InputDecoration(
                    labelText: '用户名',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '用户名不能为空';
                    }
                    if (!RegExp(r'^[a-zA-Z0-9_!@#$%^&*(),.?":{}|<>]+$')
                        .hasMatch(value)) {
                      return '请不要输入特殊符号';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<ServerName>(
                  hint: const Text('选择账户所在服务器'),
                  value: _selectedServerName,
                  onChanged: (ServerName? newValue) {
                    setState(() {
                      _selectedServerName = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return '服务器不能为空';
                    }
                    return null;
                  },
                  items: ServerName.values
                      .map<DropdownMenuItem<ServerName>>((ServerName value) {
                    return DropdownMenuItem<ServerName>(
                      value: value,
                      child: Text(value.name),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserDataListPage(
                                serverName: _selectedServerName!,
                                userName: _userNameController.text,
                              ),
                            ),
                          );
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
