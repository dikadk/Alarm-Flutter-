import 'package:flutter/services.dart';
import 'package:timezone/timezone.dart';

class TimeHelperService {
  TimeHelperService() {
    setup();
  }

  void setup() async {
    var byteData = await rootBundle.load('packages/timezone/data/2019c.tzf');
    initializeDatabase(byteData.buffer.asUint8List());
  }
}
