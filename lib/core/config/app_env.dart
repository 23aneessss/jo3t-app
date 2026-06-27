/// Environment configuration via --dart-define flags.
/// Usage:
///   flutter run --dart-define=USE_FIREBASE=true --dart-define=MAPS_API_KEY=AIza...
///   flutter build apk --dart-define=USE_FIREBASE=true --dart-define=MAPS_API_KEY=AIza...
class AppEnv {
  const AppEnv._();

  /// Set to true once Firebase is configured (google-services.json in place)
  static const bool useFirebase =
      bool.fromEnvironment('USE_FIREBASE', defaultValue: false);

  /// Google Maps API key (required for real map)
  static const String mapsApiKey =
      String.fromEnvironment('MAPS_API_KEY', defaultValue: '');

  /// Algolia App ID
  static const String algoliaAppId =
      String.fromEnvironment('ALGOLIA_APP_ID', defaultValue: '');

  /// Algolia Search-Only API key (safe to embed in client)
  static const String algoliaSearchKey =
      String.fromEnvironment('ALGOLIA_SEARCH_KEY', defaultValue: '');

  /// Firebase project environment: dev | staging | prod
  static const String firebaseEnv =
      String.fromEnvironment('FIREBASE_ENV', defaultValue: 'dev');
}
