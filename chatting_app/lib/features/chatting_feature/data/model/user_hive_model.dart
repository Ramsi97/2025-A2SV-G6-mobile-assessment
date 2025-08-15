import 'package:hive/hive.dart';
import '../../domain/entities/user.dart';

part 'user_hive_model.g.dart';

@HiveType(typeId: 1)
class UserHiveModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  UserHiveModel({
    required this.id,
    required this.name,
    required this.email,
  });

  factory UserHiveModel.fromEntity(User user) {
    return UserHiveModel(id: user.id, name: user.name, email: user.email);
  }

  User toEntity() => User(id: id, name: name, email: email);
}
