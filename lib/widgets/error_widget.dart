import 'package:flutter/material.dart';
import 'package:wows_kokomi_app/models/error_model.dart';

class HttpErrorWidge extends StatelessWidget{
  ErrorHttpModel? errorModel;

  HttpErrorWidge({Key? key, this.errorModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Status: ${errorModel?.status}'),
        Text('Message: ${errorModel?.message}'),
        Text('Error: ${errorModel?.error}'),
      ],
    );
  }
}