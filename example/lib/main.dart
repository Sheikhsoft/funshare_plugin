import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:funshare_plugin/funshare_plugin.dart';
import 'package:funshare_plugin_example/media_picker.dart';


//void main() => runApp(MyApp());
void main() => runApp(MaterialApp(
  title: 'Navigation Basics',
  home: MyApp(),
));
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    
  }

  
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('FunShare Plugin'),
        ),
        body: Column(
          children: <Widget>[
            new MaterialButton(
              child: Text('Text Share'),
              onPressed: () async => await _shareText(),
            ),
            new MaterialButton(
              child: Text('Share image'),
              onPressed: () async => await _shareImage(),
            ),
            new MaterialButton(
              child: Text('Share Video'),
              onPressed: () async => await _shareVideo(),
            ),
            new MaterialButton(
              child: Text('open new Window'),
              onPressed: () {
                // Navigator.push(
                //         context,
                //         MaterialPageRoute(builder: (context) => MediaPickerScreen()),
                //       );
              },
            ),
          ],
        ),
      ),
    );
  }

   Future _shareText() async {
    try {
      await FunsharePlugin.shareText(
          'This is my text to share with other applications.', 'my text title');
    } catch (e) {
      print('error: $e');
    }
  }

  Future _shareLocalVideo() async {
    try {
      await FunsharePlugin.shareLocalVideo(
          '/private/var/mobile/Containers/Data/Application/88D84983-9063-44B1-9764-3D252E5977C8/tmp/image_picker_543C9411-FC32-47D8-9440-ADC78CF43393-2546-0000023105421427.MOV');
    } catch (e) {
      print('error: $e');
    }
  }

   Future _shareVideo() async {
    try {
      await FunsharePlugin.shareVideo('http://159.65.154.78:8002/storage/whatsapp-status/video/2018/07/26/Zd1XMyCZIpd3XHREyWFOou9ig98IzcJKxEYR8fzd.mp4');
    } catch (e) {
      print('error: $e');
    }
  }

  Future _shareImage() async {
    try {
      final ByteData bytes = await rootBundle.load('assets/image.png');
      await FunsharePlugin.shareImage(
          'myImageTest.png', bytes, 'my image title');
    } catch (e) {
      print('error: $e');
    }
  }
}
