import 'package:flutter/material.dart';
import 'package:wows_kokomi_app/models/error_model.dart';

class HttpErrorWidget extends StatelessWidget {
  final ErrorHttpModel? errorModel;

  const HttpErrorWidget({Key? key, this.errorModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('出错啦！')),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(26.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '错误状态(Status): ${errorModel?.status}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 18),
              Text(
                '错误消息(Message): ${errorModel?.message}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 18),
              Text(
                '错误返回类型(Error): ${errorModel?.error}',
                style: const TextStyle(fontSize: 16),
                
              ),
              const SizedBox(height: 18),
              const Text(
                '开发者联系方式: QQ:1747343655',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}