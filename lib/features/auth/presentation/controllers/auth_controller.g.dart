// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authStateHash() => r'ff1bedb68d93dbb650a1594c5e88a9b3ad54f53a';

/// Auth state provider
///
/// Copied from [authState].
@ProviderFor(authState)
final authStateProvider = AutoDisposeStreamProvider<app_user.User?>.internal(
  authState,
  name: r'authStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthStateRef = AutoDisposeStreamProviderRef<app_user.User?>;
String _$authRepositoryHash() => r'903cfd3dc48a1450e2810bc05ba92eb523e83394';

/// Auth repository provider
///
/// Copied from [authRepository].
@ProviderFor(authRepository)
final authRepositoryProvider = AutoDisposeProvider<AuthRepository>.internal(
  authRepository,
  name: r'authRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthRepositoryRef = AutoDisposeProviderRef<AuthRepository>;
String _$firebaseAuthDataSourceHash() =>
    r'bddddc8e561edeb1e6bdf4c2818b30c8e9142f52';

/// Firebase auth data source provider
///
/// Copied from [firebaseAuthDataSource].
@ProviderFor(firebaseAuthDataSource)
final firebaseAuthDataSourceProvider =
    AutoDisposeProvider<FirebaseAuthDataSource>.internal(
      firebaseAuthDataSource,
      name: r'firebaseAuthDataSourceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$firebaseAuthDataSourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FirebaseAuthDataSourceRef =
    AutoDisposeProviderRef<FirebaseAuthDataSource>;
String _$signInWithGoogleHash() => r'fef476db376d6aefa298ac0f1089b048d06f914f';

/// Sign in with Google provider
///
/// Copied from [signInWithGoogle].
@ProviderFor(signInWithGoogle)
final signInWithGoogleProvider = AutoDisposeFutureProvider<void>.internal(
  signInWithGoogle,
  name: r'signInWithGoogleProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$signInWithGoogleHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SignInWithGoogleRef = AutoDisposeFutureProviderRef<void>;
String _$signInWithEmailPasswordHash() =>
    r'905c20f918f7a5d5a940a885e11df2a2bf05e127';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Sign in with email and password provider
///
/// Copied from [signInWithEmailPassword].
@ProviderFor(signInWithEmailPassword)
const signInWithEmailPasswordProvider = SignInWithEmailPasswordFamily();

/// Sign in with email and password provider
///
/// Copied from [signInWithEmailPassword].
class SignInWithEmailPasswordFamily extends Family<AsyncValue<void>> {
  /// Sign in with email and password provider
  ///
  /// Copied from [signInWithEmailPassword].
  const SignInWithEmailPasswordFamily();

  /// Sign in with email and password provider
  ///
  /// Copied from [signInWithEmailPassword].
  SignInWithEmailPasswordProvider call(String email, String password) {
    return SignInWithEmailPasswordProvider(email, password);
  }

  @override
  SignInWithEmailPasswordProvider getProviderOverride(
    covariant SignInWithEmailPasswordProvider provider,
  ) {
    return call(provider.email, provider.password);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'signInWithEmailPasswordProvider';
}

/// Sign in with email and password provider
///
/// Copied from [signInWithEmailPassword].
class SignInWithEmailPasswordProvider extends AutoDisposeFutureProvider<void> {
  /// Sign in with email and password provider
  ///
  /// Copied from [signInWithEmailPassword].
  SignInWithEmailPasswordProvider(String email, String password)
    : this._internal(
        (ref) => signInWithEmailPassword(
          ref as SignInWithEmailPasswordRef,
          email,
          password,
        ),
        from: signInWithEmailPasswordProvider,
        name: r'signInWithEmailPasswordProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$signInWithEmailPasswordHash,
        dependencies: SignInWithEmailPasswordFamily._dependencies,
        allTransitiveDependencies:
            SignInWithEmailPasswordFamily._allTransitiveDependencies,
        email: email,
        password: password,
      );

  SignInWithEmailPasswordProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.email,
    required this.password,
  }) : super.internal();

  final String email;
  final String password;

  @override
  Override overrideWith(
    FutureOr<void> Function(SignInWithEmailPasswordRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SignInWithEmailPasswordProvider._internal(
        (ref) => create(ref as SignInWithEmailPasswordRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        email: email,
        password: password,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _SignInWithEmailPasswordProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SignInWithEmailPasswordProvider &&
        other.email == email &&
        other.password == password;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, email.hashCode);
    hash = _SystemHash.combine(hash, password.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SignInWithEmailPasswordRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `email` of this provider.
  String get email;

  /// The parameter `password` of this provider.
  String get password;
}

class _SignInWithEmailPasswordProviderElement
    extends AutoDisposeFutureProviderElement<void>
    with SignInWithEmailPasswordRef {
  _SignInWithEmailPasswordProviderElement(super.provider);

  @override
  String get email => (origin as SignInWithEmailPasswordProvider).email;
  @override
  String get password => (origin as SignInWithEmailPasswordProvider).password;
}

String _$signUpWithEmailPasswordHash() =>
    r'5ca4c8881bb45b5ca0cca953b182ba9c043ea283';

/// Sign up with email and password provider
///
/// Copied from [signUpWithEmailPassword].
@ProviderFor(signUpWithEmailPassword)
const signUpWithEmailPasswordProvider = SignUpWithEmailPasswordFamily();

/// Sign up with email and password provider
///
/// Copied from [signUpWithEmailPassword].
class SignUpWithEmailPasswordFamily extends Family<AsyncValue<void>> {
  /// Sign up with email and password provider
  ///
  /// Copied from [signUpWithEmailPassword].
  const SignUpWithEmailPasswordFamily();

  /// Sign up with email and password provider
  ///
  /// Copied from [signUpWithEmailPassword].
  SignUpWithEmailPasswordProvider call(
    String email,
    String password,
    String userName,
  ) {
    return SignUpWithEmailPasswordProvider(email, password, userName);
  }

  @override
  SignUpWithEmailPasswordProvider getProviderOverride(
    covariant SignUpWithEmailPasswordProvider provider,
  ) {
    return call(provider.email, provider.password, provider.userName);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'signUpWithEmailPasswordProvider';
}

/// Sign up with email and password provider
///
/// Copied from [signUpWithEmailPassword].
class SignUpWithEmailPasswordProvider extends AutoDisposeFutureProvider<void> {
  /// Sign up with email and password provider
  ///
  /// Copied from [signUpWithEmailPassword].
  SignUpWithEmailPasswordProvider(
    String email,
    String password,
    String userName,
  ) : this._internal(
        (ref) => signUpWithEmailPassword(
          ref as SignUpWithEmailPasswordRef,
          email,
          password,
          userName,
        ),
        from: signUpWithEmailPasswordProvider,
        name: r'signUpWithEmailPasswordProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$signUpWithEmailPasswordHash,
        dependencies: SignUpWithEmailPasswordFamily._dependencies,
        allTransitiveDependencies:
            SignUpWithEmailPasswordFamily._allTransitiveDependencies,
        email: email,
        password: password,
        userName: userName,
      );

  SignUpWithEmailPasswordProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.email,
    required this.password,
    required this.userName,
  }) : super.internal();

  final String email;
  final String password;
  final String userName;

  @override
  Override overrideWith(
    FutureOr<void> Function(SignUpWithEmailPasswordRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SignUpWithEmailPasswordProvider._internal(
        (ref) => create(ref as SignUpWithEmailPasswordRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        email: email,
        password: password,
        userName: userName,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _SignUpWithEmailPasswordProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SignUpWithEmailPasswordProvider &&
        other.email == email &&
        other.password == password &&
        other.userName == userName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, email.hashCode);
    hash = _SystemHash.combine(hash, password.hashCode);
    hash = _SystemHash.combine(hash, userName.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SignUpWithEmailPasswordRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `email` of this provider.
  String get email;

  /// The parameter `password` of this provider.
  String get password;

  /// The parameter `userName` of this provider.
  String get userName;
}

class _SignUpWithEmailPasswordProviderElement
    extends AutoDisposeFutureProviderElement<void>
    with SignUpWithEmailPasswordRef {
  _SignUpWithEmailPasswordProviderElement(super.provider);

  @override
  String get email => (origin as SignUpWithEmailPasswordProvider).email;
  @override
  String get password => (origin as SignUpWithEmailPasswordProvider).password;
  @override
  String get userName => (origin as SignUpWithEmailPasswordProvider).userName;
}

String _$signOutHash() => r'899ac9146a4508b9b0034ba0c2cfd01bd8cb9778';

/// Sign out provider
///
/// Copied from [signOut].
@ProviderFor(signOut)
final signOutProvider = AutoDisposeFutureProvider<void>.internal(
  signOut,
  name: r'signOutProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$signOutHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SignOutRef = AutoDisposeFutureProviderRef<void>;
String _$currentUserHash() => r'1cd280e6459ae40bfa83d6c08ba6a5106e1e5704';

/// Current user provider (convenience)
///
/// Copied from [currentUser].
@ProviderFor(currentUser)
final currentUserProvider = AutoDisposeProvider<app_user.User?>.internal(
  currentUser,
  name: r'currentUserProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentUserRef = AutoDisposeProviderRef<app_user.User?>;
String _$isAuthenticatedHash() => r'fe6f954f2d7938a820a402d3f97973c87930d8b5';

/// Is authenticated provider
///
/// Copied from [isAuthenticated].
@ProviderFor(isAuthenticated)
final isAuthenticatedProvider = AutoDisposeProvider<bool>.internal(
  isAuthenticated,
  name: r'isAuthenticatedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isAuthenticatedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsAuthenticatedRef = AutoDisposeProviderRef<bool>;
String _$isAdminHash() => r'837a90a9c0cc751b3e87824b16ceb93918faaca8';

/// Is admin provider
///
/// Copied from [isAdmin].
@ProviderFor(isAdmin)
final isAdminProvider = AutoDisposeProvider<bool>.internal(
  isAdmin,
  name: r'isAdminProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isAdminHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsAdminRef = AutoDisposeProviderRef<bool>;
String _$isProHash() => r'fd64817a08a9b75a65ec0f39c5aa9ab60015783f';

/// Is pro provider
///
/// Copied from [isPro].
@ProviderFor(isPro)
final isProProvider = AutoDisposeProvider<bool>.internal(
  isPro,
  name: r'isProProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isProHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsProRef = AutoDisposeProviderRef<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
