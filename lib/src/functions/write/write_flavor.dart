import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';
import 'package:recase/recase.dart';
import 'package:vega_cli/src/utils/pubspec/pubspec_utils.dart';

void writeAndroidFlavor() {
  var gradleFile = _findFileByName('build.gradle');

  var lineId = 'flutter {';

  var lines = <String>[];

  var content = gradleFile.readAsStringSync();
  lines = LineSplitter.split(content).toList();

  var index = lines.indexWhere((element) => element.contains(lineId));

  lines.insert(index - 2, _flavorContent);

  File(gradleFile.path).createSync(recursive: true);
  File(gradleFile.path).writeAsStringSync(lines.join('\n'));
}

File _findFileByName(String name) {
  var current = Directory('android/app/');
  final list = current.listSync(recursive: true, followLinks: false);
  var contains = list.firstWhere((element) {
    if (element is File) {
      return basename(element.path) == name;
    }
    return false;
  }, orElse: () {
    return File('');
  });
  return contains as File;
}

var _flavorContent = '''
    flavorDimensions "default"
    productFlavors {
        dev {
            applicationIdSuffix ".dev"
            dimension "default"
        }
        stage {
            applicationIdSuffix ".stage"
            dimension "default"
        }
        prod {
            dimension "default"
        }
    }

    applicationVariants.all { variant ->
        variant.outputs.all { output ->
            def project = "${PubspecUtils.projectName?.pascalCase}"
            def SEP = "_"
            def PLUS = "+"
            def flavor = variant.productFlavors[0].name
            def buildType = variant.buildType.name
            def version = variant.versionName
            def buildNumber = variant.versionCode

            def newApkName = project + SEP + flavor + SEP + version + PLUS + buildNumber + ".apk"

            outputFileName = new File(newApkName)
        }
    }

''';
