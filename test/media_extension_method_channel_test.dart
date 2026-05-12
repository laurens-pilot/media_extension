import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_extension/media_extension_method_channel.dart';

void main() {
  MethodChannelMediaExtension platform = MethodChannelMediaExtension();
  const MethodChannel channel = MethodChannel('media_extension');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        if (methodCall.method == 'readUriBytes') {
          return Uint8List.fromList(<int>[1, 2, 3]);
        }
        return '42';
      },
    );
  });

  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });

  test('readUriBytes', () async {
    expect(await platform.readUriBytes('content://media/item'), <int>[1, 2, 3]);
  });

  test('readUriBytes returns null on unsupported platforms', () async {
    var wasInvoked = false;
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      wasInvoked = true;
      return Uint8List.fromList(<int>[1, 2, 3]);
    });

    expect(await platform.readUriBytes('content://media/item'), isNull);
    expect(wasInvoked, isFalse);
  });
}
