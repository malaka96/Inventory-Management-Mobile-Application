import 'export_file_saver_base.dart';

ExportFileSaver createExportFileSaverImpl() => _StubExportFileSaver();

class _StubExportFileSaver implements ExportFileSaver {
  @override
  Future<void> saveStringWithPicker({
    required String suggestedFileName,
    required String contents,
  }) {
    throw UnsupportedError('Export is not supported on this platform.');
  }

  @override
  Future<String?> pickSavePath({required String suggestedFileName}) {
    throw UnsupportedError('Export is not supported on this platform.');
  }

  @override
  Future<void> writeString({required String path, required String contents}) {
    throw UnsupportedError('Export is not supported on this platform.');
  }
}
