abstract class ExportFileSaver {
  /// Preferred on platforms where the "save file" UX is SAF-driven (Android/iOS),
  /// because the picker owns the destination and writes the bytes itself.
  Future<void> saveStringWithPicker({
    required String suggestedFileName,
    required String contents,
  });

  Future<String?> pickSavePath({required String suggestedFileName});
  Future<void> writeString({required String path, required String contents});
}
