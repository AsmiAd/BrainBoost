import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../models/study_progress.dart';
import '../../services/api_service.dart';

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  final api = ref.watch(apiServiceProvider);
  final box = Hive.box<StudyProgress>('progress');
  return ProgressRepository(api, box);
});

class ProgressRepository {
  ProgressRepository(this._api, this._box);

  final ApiService _api;
  final Box<StudyProgress> _box;

  /// Pull latest progress from server → cache in Hive
  Future<void> sync() async {
    final remote = await _api.fetchProgress();   // we’ll add this endpoint next
    await _box.clear();
    for (final p in remote) _box.put(p.id, p);
  }

  List<StudyProgress> localProgress() => _box.values.toList();

  Future<void> updateProgress(StudyProgress prog) async {
    await _api.updateProgress(prog);             // endpoint to implement
    await _box.put(prog.id, prog);
  }
}
