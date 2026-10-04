import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Android launcher is branded as NeuroCore', () {
    final manifest = File('android/app/src/main/AndroidManifest.xml').readAsStringSync();
    expect(manifest, contains('android:label="NeuroCore"'));
    expect(manifest, contains('android:icon="@drawable/ic_neurocore"'));
    expect(File('android/app/src/main/res/drawable/ic_neurocore.xml').existsSync(), isTrue);
  });

  test('audible local feedback is compiled without network audio', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    final feedback = File('lib/core/feedback/game_feedback_service.dart').readAsStringSync();
    expect(pubspec, contains('audioplayers: ^6.8.1'));
    expect(feedback, contains('BytesSource'));
    expect(feedback, contains('soundEnabled'));
    expect(feedback, isNot(contains('UrlSource')));
  });
}
