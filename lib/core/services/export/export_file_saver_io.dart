import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';

import 'package:file_picker/file_picker.dart';

import 'export_file_saver_base.dart';

ExportFileSaver createExportFileSaverImpl() => _IoExportFileSaver();

class _IoExportFileSaver implements ExportFileSaver {
  @override
  Future<void> saveStringWithPicker({
    required String suggestedFileName,
    required String contents,
  }) async {
    // On Android/iOS, prefer SAF-backed save flow so the OS manages the location
    // and the file is visible to the system file manager.
    if (!(Platform.isAndroid || Platform.isIOS)) {
      throw UnsupportedError('saveStringWithPicker is mobile-only.');
    }

    // Many Android file managers won't open `.json` unless a text editor is installed.
    // Saving as `.txt` keeps the content identical (still JSON) but is easier to open.
    final effectiveName = Platform.isAndroid &&
            suggestedFileName.toLowerCase().endsWith('.json')
        ? '${suggestedFileName.substring(0, suggestedFileName.length - 5)}.txt'
        : suggestedFileName;

    final bytes = Uint8List.fromList(utf8.encode(contents));
    await FilePicker.saveFile(
      dialogTitle: 'Export backup',
      fileName: effectiveName,
      type: FileType.custom,
      allowedExtensions: const ['json', 'txt'],
      bytes: bytes,
    );
  }

  @override
  Future<String?> pickSavePath({required String suggestedFileName}) async {
    // file_picker v11 uses static methods; `.platform` does not exist.
    //
    // On Android/iOS, `saveFile()` may return non-file paths or behave inconsistently,
    // so we prefer picking a directory and writing with dart:io.
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      try {
        final path = await FilePicker.saveFile(
          dialogTitle: 'Export backup',
          fileName: suggestedFileName,
          type: FileType.custom,
          allowedExtensions: const ['json'],
        );
        if (path != null && path.isNotEmpty) return path;
      } catch (_) {
        // Fall through to directory picker.
      }
    }

    final dir = await FilePicker.getDirectoryPath(
      dialogTitle: 'Choose export location',
    );
    if (dir == null || dir.isEmpty) return null;

    final sep = Platform.pathSeparator;
    final normalizedDir =
        dir.endsWith(sep) ? dir.substring(0, dir.length - 1) : dir;
    return '$normalizedDir$sep$suggestedFileName';
  }

  @override
  Future<void> writeString({
    required String path,
    required String contents,
  }) async {
    final file = File(path);
    await file.create(recursive: true);
    await file.writeAsString(contents);
  }
}
