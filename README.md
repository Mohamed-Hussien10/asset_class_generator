# Asset Class Generator

A Flutter package that automatically generates Dart classes for assets by watching the `assets` folder.

## Features
- Watches all subfolders under `assets/` (e.g., `images`, `svgs`, `fonts`, etc.).
- Generates classes like `AppImages`, `AppSvgs`, etc., with camelCase asset names.
- Updates `lib/assets.dart` whenever new assets are added.

## Installation
Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  asset_class_generator: ^0.0.1
```

Then, run:
```sh
flutter pub get
```

## Usage
To generate asset classes for your Flutter project, follow these steps:

### 1️⃣ Create a Script
1. Inside your project, create a folder named `tools/` (if it doesn’t exist).
2. Create a file named `generate_assets.dart` inside `tools/`.

### 2️⃣ Add the Following Code
```dart
import 'package:assets_file_generator/assets_file_generator.dart';

void main() {
  generateAssetClasses();
}
```

### 3️⃣ Run the Script
In your terminal, execute:
```sh
dart run tools/generate_assets.dart
```
This will scan your `assets/` folder and update `lib/assets.dart` automatically.

## Example Output (`lib/assets.dart`)
```dart
class AppImages {
  static const String logo = 'assets/images/logo.png';
  static const String banner = 'assets/images/banner.png';
}

class AppSvgs {
  static const String icon = 'assets/svgs/icon.svg';
}
```

Now, you can use it in your Flutter app like this:
```dart
Image.asset(AppImages.logo);
SvgPicture.asset(AppSvgs.icon);
```

## Development & Contribution
Feel free to contribute to this package! Fork the repo, submit a PR, or report issues.

## Future Improvements
- Add support for additional file types.
- Improve CLI automation.

## Links
- 📖 **Documentation**: [pub.dev](https://pub.dev/packages/asset_class_generator)
- 🛠 **Source Code**: [GitHub](https://github.com/Mohamed-Hussien10/assets_file_generator.git)
- 🐞 **Report Issues**: [GitHub Issues](https://github.com/Mohamed-Hussien10/asset_class_generator/issues)

