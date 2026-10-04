import 'dart:math' as math;
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

import '../accessibility/accessibility_service.dart';

/// Feedback audiovisual leve, local e não punitivo para a área infantil.
/// Os sons são sintetizados em memória e não dependem de rede, anúncios ou SDKs de analytics.
class GameFeedbackService {
  GameFeedbackService({required AccessibilityService accessibility})
    : _accessibility = accessibility;

  final AccessibilityService _accessibility;
  final AudioPlayer _player = AudioPlayer();

  static final Uint8List _startTone = _tone(
    frequencies: const [523.25, 659.25],
    durationMs: 170,
    amplitude: 0.20,
  );
  static final Uint8List _correctTone = _tone(
    frequencies: const [659.25, 783.99, 1046.50],
    durationMs: 230,
    amplitude: 0.22,
  );
  static final Uint8List _gentleTone = _tone(
    frequencies: const [440.00, 392.00],
    durationMs: 155,
    amplitude: 0.15,
  );
  static final Uint8List _completeTone = _tone(
    frequencies: const [523.25, 659.25, 783.99, 1046.50],
    durationMs: 330,
    amplitude: 0.22,
  );

  Future<void> start() async {
    await _play(_startTone, volume: 0.52);
    if (_accessibility.preferences.hapticsEnabled) {
      await HapticFeedback.selectionClick();
    }
  }

  Future<void> correct() async {
    await _play(_correctTone, volume: 0.58);
    if (_accessibility.preferences.hapticsEnabled) {
      await HapticFeedback.lightImpact();
    }
  }

  Future<void> gentleMiss() async {
    await _play(_gentleTone, volume: 0.38);
    if (_accessibility.preferences.hapticsEnabled) {
      await HapticFeedback.selectionClick();
    }
  }

  Future<void> complete() async {
    await _play(_completeTone, volume: 0.60);
    if (_accessibility.preferences.hapticsEnabled) {
      await HapticFeedback.mediumImpact();
    }
  }

  Future<void> _play(Uint8List bytes, {required double volume}) async {
    if (!_accessibility.preferences.soundEnabled) return;
    try {
      await _player.stop();
      await _player.setPlayerMode(PlayerMode.lowLatency);
      await _player.setVolume(volume.clamp(0.0, 1.0));
      await _player.play(BytesSource(bytes));
    } catch (_) {
      // O áudio nunca deve interromper a missão.
      await SystemSound.play(SystemSoundType.click);
    }
  }

  static Uint8List _tone({
    required List<double> frequencies,
    required int durationMs,
    required double amplitude,
  }) {
    const sampleRate = 22050;
    const channels = 1;
    const bitsPerSample = 16;
    final sampleCount = (sampleRate * durationMs / 1000).round();
    final dataSize = sampleCount * channels * (bitsPerSample ~/ 8);
    final bytes = ByteData(44 + dataSize);

    void ascii(int offset, String text) {
      for (var i = 0; i < text.length; i += 1) {
        bytes.setUint8(offset + i, text.codeUnitAt(i));
      }
    }

    ascii(0, 'RIFF');
    bytes.setUint32(4, 36 + dataSize, Endian.little);
    ascii(8, 'WAVE');
    ascii(12, 'fmt ');
    bytes.setUint32(16, 16, Endian.little);
    bytes.setUint16(20, 1, Endian.little);
    bytes.setUint16(22, channels, Endian.little);
    bytes.setUint32(24, sampleRate, Endian.little);
    bytes.setUint32(28, sampleRate * channels * (bitsPerSample ~/ 8), Endian.little);
    bytes.setUint16(32, channels * (bitsPerSample ~/ 8), Endian.little);
    bytes.setUint16(34, bitsPerSample, Endian.little);
    ascii(36, 'data');
    bytes.setUint32(40, dataSize, Endian.little);

    for (var i = 0; i < sampleCount; i += 1) {
      final t = i / sampleRate;
      final position = i / sampleCount;
      final attack = (position / 0.08).clamp(0.0, 1.0);
      final release = ((1 - position) / 0.20).clamp(0.0, 1.0);
      final envelope = math.min(attack, release);
      var signal = 0.0;
      for (final frequency in frequencies) {
        signal += math.sin(2 * math.pi * frequency * t);
      }
      signal /= frequencies.length;
      final sample = (signal * envelope * amplitude * 32767)
          .clamp(-32767.0, 32767.0)
          .round();
      bytes.setInt16(44 + (i * 2), sample, Endian.little);
    }

    return bytes.buffer.asUint8List();
  }
}
