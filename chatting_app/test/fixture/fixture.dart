import 'dart:io';

String fixture(String name) {
  return File('test/fixture/$name').readAsStringSync();
}
