import 'package:high_hat/domain/schedule/schedule_repository_base.dart';

class ScheduleService {
  const ScheduleService(ScheduleRepositoryBase repository)
      : _repository = repository;

  final ScheduleRepositoryBase _repository;
}
