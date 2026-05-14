import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/wilaya_entity.dart';
import '../../domain/repositories/wilaya_repository.dart';

class MockWilayaRepository implements WilayaRepository {
  static const _wilayas = [
    WilayaEntity(id: 'alger', nameFr: 'Alger', nameAr: 'الجزائر', code: '16', placeCount: 312),
    WilayaEntity(id: 'oran', nameFr: 'Oran', nameAr: 'وهران', code: '31', placeCount: 187),
    WilayaEntity(id: 'constantine', nameFr: 'Constantine', nameAr: 'قسنطينة', code: '25', placeCount: 143),
    WilayaEntity(id: 'annaba', nameFr: 'Annaba', nameAr: 'عنابة', code: '23', placeCount: 98),
    WilayaEntity(id: 'blida', nameFr: 'Blida', nameAr: 'البليدة', code: '09', placeCount: 76),
    WilayaEntity(id: 'setif', nameFr: 'Sétif', nameAr: 'سطيف', code: '19', placeCount: 112),
    WilayaEntity(id: 'tlemcen', nameFr: 'Tlemcen', nameAr: 'تلمسان', code: '13', placeCount: 84),
    WilayaEntity(id: 'bejaia', nameFr: 'Béjaïa', nameAr: 'بجاية', code: '06', placeCount: 67),
    WilayaEntity(id: 'tizi_ouzou', nameFr: 'Tizi Ouzou', nameAr: 'تيزي وزو', code: '15', placeCount: 79),
    WilayaEntity(id: 'batna', nameFr: 'Batna', nameAr: 'باتنة', code: '05', placeCount: 54),
    WilayaEntity(id: 'sidi_bel_abbes', nameFr: 'Sidi Bel Abbès', nameAr: 'سيدي بلعباس', code: '22', placeCount: 45),
    WilayaEntity(id: 'biskra', nameFr: 'Biskra', nameAr: 'بسكرة', code: '07', placeCount: 38),
  ];

  @override
  Future<Either<Failure, List<WilayaEntity>>> getAllWilayas() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const Right(_wilayas);
  }

  @override
  Future<Either<Failure, WilayaEntity>> getWilayaById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final wilaya = _wilayas.where((w) => w.id == id).firstOrNull;
    if (wilaya == null) return const Left(NotFoundFailure('Wilaya not found'));
    return Right(wilaya);
  }
}
