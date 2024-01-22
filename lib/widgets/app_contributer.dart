import 'package:flutter/material.dart';

class ContributorsPage extends StatelessWidget {
  ContributorsPage({Key? key}) : super(key: key);

  final List<String> contributors = [
    '蓝色的蘑菇头奇诺比奥',
    // 在这里添加更多贡献者
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('贡献者名单'),
      ),
      body: ListView.builder(
        itemCount: contributors.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: const Icon(Icons.person),
            title: Text(contributors[index]),
          );
        },
      ),
    );
  }
}