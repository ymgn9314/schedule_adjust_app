import 'package:high_hat/domain/user/user_repository_base.dart';

class UserService {
  UserService(UserRepositoryBase repository) : _repository = repository;
  final UserRepositoryBase _repository;
}
