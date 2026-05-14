import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/mock_add_place_repository.dart';
import '../../domain/entities/new_place_entity.dart';
import '../../domain/repositories/add_place_repository.dart';
import '../../domain/usecases/submit_place_usecase.dart';
import '../../../place/domain/entities/place_entity.dart';

final addPlaceRepositoryProvider = Provider<AddPlaceRepository>(
  (_) => MockAddPlaceRepository(),
);

final submitPlaceUseCaseProvider = Provider(
  (ref) => SubmitPlaceUseCase(ref.watch(addPlaceRepositoryProvider)),
);

// Form state
class AddPlaceFormState {
  const AddPlaceFormState({
    this.name = '',
    this.category = PlaceCategoryEntity.restaurant,
    this.wilayaId = '',
    this.neighborhood = '',
    this.address = '',
    this.priceRange = PriceRangeEntity.mid,
    this.photoPaths = const [],
    this.currentStep = 0,
  });

  final String name;
  final PlaceCategoryEntity category;
  final String wilayaId;
  final String neighborhood;
  final String address;
  final PriceRangeEntity priceRange;
  final List<String> photoPaths;
  final int currentStep;

  AddPlaceFormState copyWith({
    String? name,
    PlaceCategoryEntity? category,
    String? wilayaId,
    String? neighborhood,
    String? address,
    PriceRangeEntity? priceRange,
    List<String>? photoPaths,
    int? currentStep,
  }) {
    return AddPlaceFormState(
      name: name ?? this.name,
      category: category ?? this.category,
      wilayaId: wilayaId ?? this.wilayaId,
      neighborhood: neighborhood ?? this.neighborhood,
      address: address ?? this.address,
      priceRange: priceRange ?? this.priceRange,
      photoPaths: photoPaths ?? this.photoPaths,
      currentStep: currentStep ?? this.currentStep,
    );
  }

  NewPlaceEntity toEntity() => NewPlaceEntity(
        name: name,
        category: category,
        wilayaId: wilayaId,
        neighborhood: neighborhood,
        address: address,
        priceRange: priceRange,
        photoPaths: photoPaths,
      );

  bool get isStepValid => switch (currentStep) {
        0 => category != PlaceCategoryEntity.restaurant || name.isNotEmpty,
        1 => wilayaId.isNotEmpty && neighborhood.isNotEmpty,
        2 => address.isNotEmpty,
        3 => true, // photos optional
        _ => false,
      };
}

class AddPlaceFormNotifier extends Notifier<AddPlaceFormState> {
  @override
  AddPlaceFormState build() => const AddPlaceFormState();

  void setCategory(PlaceCategoryEntity cat) =>
      state = state.copyWith(category: cat);
  void setName(String v) => state = state.copyWith(name: v);
  void setWilaya(String v) => state = state.copyWith(wilayaId: v);
  void setNeighborhood(String v) => state = state.copyWith(neighborhood: v);
  void setAddress(String v) => state = state.copyWith(address: v);
  void setPriceRange(PriceRangeEntity v) => state = state.copyWith(priceRange: v);
  void addPhoto(String path) =>
      state = state.copyWith(photoPaths: [...state.photoPaths, path]);
  void removePhoto(String path) => state = state.copyWith(
      photoPaths: state.photoPaths.where((p) => p != path).toList());
  void nextStep() =>
      state = state.copyWith(currentStep: state.currentStep + 1);
  void prevStep() =>
      state = state.copyWith(currentStep: state.currentStep - 1);
  void reset() => state = const AddPlaceFormState();
}

final addPlaceFormProvider =
    NotifierProvider<AddPlaceFormNotifier, AddPlaceFormState>(
  AddPlaceFormNotifier.new,
);

// Submit notifier
class SubmitPlaceNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> submit(NewPlaceEntity place) async {
    state = const AsyncLoading();
    final useCase = ref.read(submitPlaceUseCaseProvider);
    final result = await useCase(place);
    return result.fold(
      (failure) {
        state = AsyncError(failure.message, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncData(null);
        ref.read(addPlaceFormProvider.notifier).reset();
        return true;
      },
    );
  }
}

final submitPlaceNotifierProvider =
    AsyncNotifierProvider<SubmitPlaceNotifier, void>(SubmitPlaceNotifier.new);
