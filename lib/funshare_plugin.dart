import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class FunsharePlugin {
  static const MethodChannel _channel =
      const MethodChannel('funshare_plugin');

  static Future shareText(String text, String droidTitle) async {
    Map argsMap = <String, String>{'text': '$text', 'title': '$droidTitle'};
    _channel.invokeMethod('shareText', argsMap);
  }

  static Future shareLocalVideo(String text) async {
    Map argsMap = <String, String>{'localVideoPath': '$text'};
    _channel.invokeMethod('shareLocalVideo', argsMap);
  }

  static Future shareVideo(String videoUrl) async {
    Map argsMap = <String, String>{'videoUrl': '$videoUrl'};
    _channel.invokeMethod('shareVideo', argsMap);
  }


  /// Shares images with other supported applications on Android and iOS.
  /// The title parameter is just supported on Android and does nothing on iOS.S
  static Future shareImage(
      String fileName, ByteData imageBytes, String droidTitle) async {
    Map argsMap = <String, String>{
      'fileName': '$fileName',
      'title': '$droidTitle'
    };

    final Uint8List list = imageBytes.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();
    final file = await new File('${tempDir.path}/$fileName').create();
    await file.writeAsBytes(list);

    _channel.invokeMethod('shareImage', argsMap);
  }
}
