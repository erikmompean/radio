enum RadioStatus {
  playing,
  ready,
  stopped,
  paused,
  unInitialized,
  initializing
}

extension RadioStatusExtension on RadioStatus {
  bool get needsInitialization =>
      this == RadioStatus.unInitialized || this == RadioStatus.stopped;

  bool get isPlaying => this == RadioStatus.playing;
  bool get isInitialized =>
      this != RadioStatus.unInitialized && this != RadioStatus.stopped;
}
