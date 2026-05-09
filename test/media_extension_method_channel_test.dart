import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_extension/media_extension_method_channel.dart';

void main() {
  MethodChannelMediaExtension platform = MethodChannelMediaExtension();
  const MethodChannel channel = MethodChannel('media_extension');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async => '42',
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
