import 'package:flutter/foundation.dart';

class Url {
  static String getUrl() {
    var url = '';
    if (kReleaseMode) {
      url = 'https://budgetpals-399823.nn.r.appspot.com';
    } else {
      url = 'http://localhost:3333';
    }
    return url;
  }
}
