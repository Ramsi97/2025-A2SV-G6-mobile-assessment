import 'dart:convert';

import 'package:chatting_app/features/authentication/data/model/person_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixture/fixture.dart';

void main() {
  PersonModel personModel = const PersonModel(
    name: 'Abebe',
    email: 'abebe@gmail.com',
    password: '123456',
  );

  final personJson = json.decode(fixture('user.json'));

  test('should convert Json to PersonModel', () {
    final personModel = PersonModel.fromJson(personJson);
    expect(personModel, isA<PersonModel>());
  });

  test('should convert PersonModel to Json', () {
    final result = personModel.toJson();
    expect(result, isA<Map<String, dynamic>>());
  });

  test('should convert Person to PersonModel', () {
    final person = personModel.fromEntity(personModel);
    expect(person, equals(personModel));
  });
}
