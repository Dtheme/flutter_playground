import 'package:flutter/services.dart';
import 'package:wefriend_flutter/Util/global.dart';

class PlatformChannel {
  static const MethodChannel _methodChannel = MethodChannel('platform_channel');

  static Future<void> openNativePage() async {
    try {
      await _methodChannel.invokeMethod('openNativePage');
    } on PlatformException catch (e) {
      print("Failed to open native page: ${e.message}");
    }
  }

  static Future<void> showSystemAlert(String title, String message,
      Function() onConfirm, Function() onCancel) async {
    try {
      final Map<String, dynamic> arguments = {
        'title': title,
        'message': message,
      };

      // 在 MethodChannel 的 invokeMethod 中传入确定和取消按钮回调的名称
      final String result =
          await _methodChannel.invokeMethod('showSystemAlert', arguments);
      logger.i(result);
      // 根据原生点击 返回的结果，执行回调
      if (result == 'onNativeConfirm') {
        logger.t('Flutter side User tapped OK');
        onConfirm();
      } else if (result == 'onNativeCancel') {
        logger.t('Flutter side User tapped Cancel');
        onCancel();
      } else {
        logger.t('Flutter side User tapped other');
      }
    } on PlatformException catch (e) {
      print("Failed to show system alert: ${e.message}");
    }

    // 通过 MethodChannel 的 invokeMethod 方法，调用原生的方法
    // swift与flutter交互，swift调用原生函数
    // try {
    //   final Map<String, dynamic> arguments = {
    //     'title': title,
    //     'message': message,
    //   };
    //   final String result =
    //       await _methodChannel.invokeMethod('showSystemAlert', arguments);
    //   logger.i(result);
    //   if (result == 'onNativeConfirm') {
    //     logger.t('Flutter side User tapped OK');
    //     onConfirm();
    //   } else if (result == 'onNativeCancel') {
    //     logger.t('Flutter side User tapped Cancel');
    //     onCancel();
    //   } else {
    //     logger.t('Flutter side User tapped other');
    //   }
    // } on PlatformException catch (e) {
    //   print("Failed to show system alert: ${e.message}");
    // }
    


  }
}
