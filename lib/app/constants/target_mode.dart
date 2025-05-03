enum TargetMode { loss, gain }

String getTargetModeDisplayLabel(TargetMode value) {
  return switch (value) {
    TargetMode.loss => 'Weight Loss',
    TargetMode.gain => 'Weight Gain',
  };
}
