import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/wilaya_entity.dart';

abstract interface class WilayaRepository {
  Future<Either<Failure, List<WilayaEntity>>> getAllWilayas();
  Future<Either<Failure, WilayaEntity>> getWilayaById(String id);
}
