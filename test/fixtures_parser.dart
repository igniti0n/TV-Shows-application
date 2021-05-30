import 'dart:io';

String readFile(String filename) {
  return File('fixtures/$filename.json').readAsStringSync();
}
