import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_flutter/secondpage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  String route;
  Map<String, dynamic> params;

  HomePage(this.route, this.params);

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  static const nativeChannel =
      const MethodChannel('com.example.flutter/native');
  static const flutterChannel =
      const MethodChannel('com.example.flutter/flutter');
  final _nameController = TextEditingController();
  Map<dynamic, dynamic> params;

  @override
  void initState() {
    super.initState();
    Future<dynamic> handler(MethodCall call) async {
      switch (call.method) {
        case 'onActivityResult':
          Fluttertoast.showToast(
            msg: call.arguments['message'],
            toastLength: Toast.LENGTH_SHORT,
          );
          break;
        case 'goBack':
          // 返回上一页
          if (Navigator.canPop(context)) {
            Navigator.of(context).pop();
          } else {
            nativeChannel.invokeMethod('goBack');
          }
          break;
      }
    }

    flutterChannel.setMethodCallHandler(handler);
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter页面'),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '我是Flutter页面，route=${widget.route}，原生页面传过来的参数：name=${widget.params['name']}',
              style: TextStyle(fontSize: 16.0),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(hintText: "请输入要传递到原生端的参数"),
            ),
            Container(
              width: double.infinity,
              child: RaisedButton(
                  child: Text('返回上一页'),
                  onPressed: () {
                    Map<String, dynamic> result = {'message': '我从Flutter页面回来了'};
                    nativeChannel.invokeMethod('goBackWithResult', result);
                  }),
            ),
            Container(
              width: double.infinity,
              child: RaisedButton(
                  child: Text('跳转Flutter页面'),
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return SecondPage();
                    }));
                  }),
            ),
            Container(
              width: double.infinity,
              child: RaisedButton(
                  child: Text('跳转Android原生页面'),
                  onPressed: () {
                    // 跳转原生页面
                    Map<String, dynamic> result = {
                      'name': _nameController.text
                    };
                    nativeChannel.invokeMethod('jumpToNative', result);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
