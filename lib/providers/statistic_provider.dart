import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'progress_repository.dart';
import '../models/study_progress.dart';

final studyProgressProvider = FutureProvider.autoDispose<List<StudyProgress>>((ref) async {
  final repo = ref.watch(progressRepositoryProvider);
  await repo.sync();            // pulls remote + flushes queue
  return repo.localProgress();  // returns Hive‑cached data
});