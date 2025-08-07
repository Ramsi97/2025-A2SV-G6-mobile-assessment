import 'package:chatting_app/features/authentication/domain/entity/person.dart';

class PersonModel extends Person {
  const PersonModel({
    required super.name,
    required super.email,
    required super.password,
  });

  // You can add methods to convert to/from JSON if needed
  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'password': password};
  }

  factory PersonModel.fromJson(Map<String, dynamic> json) {
    return PersonModel(
      name: json['name'],
      email: json['email'],
      password: json['password'],
    );
  }

  PersonModel fromEntity(Person person) {
    return PersonModel(
      name: person.name,
      email: person.email,
      password: person.password,
    );
  }
}
