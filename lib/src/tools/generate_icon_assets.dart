import 'dart:io';

void main() {
  const iconDirPath = 'assets/icons';
  const outputFilePath = 'lib/src/icon_assets.dart';
  const packageBasePath = 'packages/core/icons/$iconDirPath';

  final iconDir = Directory(iconDirPath);
  if (!iconDir.existsSync()) {
    print('❌ Folder $iconDirPath not found.');
    return;
  }

  final svgFiles = iconDir
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.svg'))
      .toList();

  if (svgFiles.isEmpty) {
    print('⚠️  No SVG files in$iconDirPath');
    return;
  }

  final buffer = StringBuffer();
  buffer.writeln('// GENERATED FILE - DO NOT MODIFY MANUALLY');
  buffer.writeln('// Run `./gen_icons.sh` to regenerate.');
  buffer.writeln();
  buffer.writeln('class IconAssets {');
  buffer.writeln("  static const _basePath = '$packageBasePath';");
  buffer.writeln();

  for (final file in svgFiles) {
    final fileName = file.uri.pathSegments.last;
    final iconName = fileName.replaceAll('.svg', '');
    final variableName = _toCamelCase(iconName);

    buffer.writeln("  static const String $variableName = '\$_basePath/$fileName';");
  }

  buffer.writeln('}');

  final outFile = File(outputFilePath);
  outFile.writeAsStringSync(buffer.toString());

  print('✅ The file $outputFilePath was successfully generated with ${svgFiles.length} icons.');
}

String _toCamelCase(String input) {
  final parts = input
      .toLowerCase()
      .split(RegExp(r'[_\-\s]+'))
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();

  if (parts.isEmpty) return input;

  return parts.first + parts.skip(1).map((e) => e[0].toUpperCase() + e.substring(1)).join();
}
