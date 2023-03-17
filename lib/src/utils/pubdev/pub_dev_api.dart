import 'dart:convert';

import 'package:http/http.dart';
import 'package:vega_cli/src/utils/log/logger.dart';

class PubDevApi {
  static Future<String?> getLatestVersionFromPackage(String package) async {
    // final languageCode = Platform.localeName.split('_')[0];
    final pubSite = 'https://pub.dev/api/packages/$package';
    var uri = Uri.parse(pubSite);
    try {
      var value = await get(uri);
      if (value.statusCode == 200) {
        final version = json.decode(value.body)['latest']['version'] as String?;
        return version;
      } else if (value.statusCode == 404) {
        Logger2.info(
          'Package not found!',
          false,
          false,
        );
      }
      return null;
    } on Exception catch (err) {
      Logger2.error(err.toString());
      return null;
    }
  }
}
