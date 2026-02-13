import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'speech_to_text_provider.g.dart';

@riverpod
SpeechToText speechToText(Ref ref) {
  return SpeechToText();
}
