import 'dart:io';
import 'package:assets_file_generator/assets_file_generator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AssetClassGenerator Tests', () {
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('assets_test_');
      Directory('${tempDir.path}/assets/images').createSync(recursive: true);
      Directory('${tempDir.path}/assets/svgs').createSync(recursive: true);
      Directory('${tempDir.path}/assets/fonts').createSync(recursive: true);

      File('${tempDir.path}/assets/images/test_image.png').createSync();
      File('${tempDir.path}/assets/svgs/arrow_down.svg').createSync();
      File('${tempDir.path}/assets/fonts/roboto.ttf').createSync();
    });

    tearDown(() {
      tempDir.deleteSync(recursive: true);
    });

    test('Generates asset classes correctly', () {
      Directory.current = tempDir;
      generateAssetClasses();

      final assetsFile = File('${tempDir.path}/lib/assets.dart');
      expect(
        assetsFile.existsSync(),
        true,
        reason: 'assets.dart should be generated',
      );

      String content = assetsFile.readAsStringSync();

      expect(content, contains('class AssetsPaths {'));
      expect(
        content,
        contains("static const String images = '\$assets/images';"),
      );
      expect(content, contains("static const String svgs = '\$assets/svgs';"));
      expect(
        content,
        contains("static const String fonts = '\$assets/fonts';"),
      );

      expect(content, contains('class AppImages {'));
      expect(
        content,
        contains(
          "static const String testImage = 'assets/images/test_image.png';",
        ),
      );

      expect(content, contains('class AppSvgs {'));
      expect(
        content,
        contains(
          "static const String arrowDown = 'assets/svgs/arrow_down.svg';",
        ),
      );

      expect(content, contains('class AppFonts {'));
      expect(
        content,
        contains("static const String roboto = 'assets/fonts/roboto.ttf';"),
      );
    });

    test('Handles missing folders gracefully', () {
      Directory.current = tempDir;
      Directory('${tempDir.path}/assets/svgs').deleteSync(recursive: true);

      generateAssetClasses();

      final assetsFile = File('${tempDir.path}/lib/assets.dart');
      expect(assetsFile.existsSync(), true);

      String content = assetsFile.readAsStringSync();
      expect(
        content,
        contains('class AppSvgs {\n}'),
        reason: 'AppSvgs should be empty',
      );
      expect(
        content,
        contains(
          "static const String testImage = 'assets/images/test_image.png';",
        ),
      );
      expect(
        content,
        contains("static const String roboto = 'assets/fonts/roboto.ttf';"),
      );
    });
  });
}
