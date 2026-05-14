import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/mock_wilaya_repository.dart';
import '../../domain/entities/wilaya_entity.dart';
import '../../domain/repositories/wilaya_repository.dart';

final wilayaRepositoryProvider = Provider<WilayaRepository>(
  (_) => MockWilayaRepository(),
);

final allWilayasProvider = FutureProvider<List<WilayaEntity>>((ref) async {
  final repo = ref.watch(wilayaRepositoryProvider);
  final result = await repo.getAllWilayas();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (wilayas) => wilayas,
  );
});

final wilayaByIdProvider = FutureProvider.family<WilayaEntity, String>(
  (ref, id) async {
    final repo = ref.watch(wilayaRepositoryProvider);
    final result = await repo.getWilayaById(id);
    return result.fold(
      (failure) => throw Exception(failure.message),
      (wilaya) => wilaya,
    );
  },
);
