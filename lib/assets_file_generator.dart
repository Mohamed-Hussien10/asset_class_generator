// Set this to true for debug output, or pass it as a command-line argument.
import 'package:universal_io/io.dart';

const bool debugMode = true;

/// Automatically generates Dart classes for assets in the assets/ folder.
///
/// Watches subfolders like images, svgs, etc., and creates corresponding
/// classes (e.g., AppImages, AppSvgs) in lib/assets.dart.
void generateAssetClasses() {
  _watchAssetsFolders();
}

void _watchAssetsFolders() {
  const List<String> folders = [
    'images',
    'icons',
    'svgs',
    'lotties',
    'fonts',
    'videos',
    'audios',
    'documents',
    'animations',
    'textures',
    'models',
    'raw',
  ];

  for (String folder in folders) {
    Directory dir = Directory('assets/$folder');

    if (!dir.existsSync()) {
      if (debugMode) {
        print('assets/$folder folder does not exist.');
      }
      continue;
    }

    dir.watch(events: FileSystemEvent.create).listen((event) {
      if (event.type == FileSystemEvent.create) {
        _generateAssetsClasses();
      }
    });

    if (debugMode) {
      print('Watching assets/$folder folder for changes...');
    }
  }

  // Generate initially
  _generateAssetsClasses();
}

void _generateAssetsClasses() {
  const String assetsPath = 'assets';
  const Map<String, String> folderPaths = {
    'images': '$assetsPath/images',
    'icons': '$assetsPath/icons',
    'svgs': '$assetsPath/svgs',
    'lotties': '$assetsPath/lotties',
    'fonts': '$assetsPath/fonts',
    'videos': '$assetsPath/videos',
    'audios': '$assetsPath/audios',
    'documents': '$assetsPath/documents',
    'animations': '$assetsPath/animations',
    'textures': '$assetsPath/textures',
    'models': '$assetsPath/models',
    'raw': '$assetsPath/raw',
  };

  Map<String, String> folderToClass = {
    for (var folder in folderPaths.keys)
      folder: 'App${folder[0].toUpperCase()}${folder.substring(1)}',
  };

  Map<String, List<String>> assetEntries = {
    for (var className in folderToClass.values) className: [],
  };
  Set<String> usedVariableNames = {};

  for (String folder in folderPaths.keys) {
    Directory dir = Directory(folderPaths[folder]!);
    if (!dir.existsSync()) continue;

    String className = folderToClass[folder]!;
    List<FileSystemEntity> files = dir.listSync();

    for (var file in files) {
      if (file is File) {
        String fileName = file.uri.pathSegments.last;
        String filePath = '${folderPaths[folder]}/$fileName'.replaceAll(
          r'\',
          '/',
        );
        String baseName = fileName.split('.').first;
        String variableName = _toCamelCase(baseName);

        String uniqueVariableName = variableName;
        int counter = 1;
        while (usedVariableNames.contains(uniqueVariableName)) {
          uniqueVariableName = '$variableName$counter';
          counter++;
        }
        usedVariableNames.add(uniqueVariableName);

        assetEntries[className]!.add(
          "  static const String $uniqueVariableName = '$filePath';",
        );
      }
    }
  }

  String classContent = """
class AssetsPaths {
  static const String assets = '$assetsPath';
  static const String svgs = '\$assets/svgs';
  static const String images = '\$assets/images';
  static const String icons = '\$assets/icons';
  static const String lotties = '\$assets/lotties';
  static const String fonts = '\$assets/fonts';
  static const String videos = '\$assets/videos';
  static const String audios = '\$assets/audios';
  static const String documents = '\$assets/documents';
  static const String animations = '\$assets/animations';
  static const String textures = '\$assets/textures';
  static const String models = '\$assets/models';
  static const String raw = '\$assets/raw';
}
""";

  for (var className in assetEntries.keys) {
    classContent += """

class $className {
${assetEntries[className]!.join('\n')}
}
""";
  }

  File('lib/assets.dart').writeAsStringSync(classContent);
  if (debugMode) {
    print('Updated assets.dart file with new assets.');
  }
}

String _toCamelCase(String input) {
  List<String> parts = input.split(RegExp(r'[-_]'));
  if (parts.length == 1) return parts[0];

  String result = parts[0].toLowerCase();
  for (int i = 1; i < parts.length; i++) {
    result +=
        parts[i].substring(0, 1).toUpperCase() +
        parts[i].substring(1).toLowerCase();
  }
  return result;
}
