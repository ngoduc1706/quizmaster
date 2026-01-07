// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_list_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$quizListCategoryIdHash() =>
    r'9de479595edd4036dcbc33a443f829c03e90f861';

/// Filters providers
///
/// Copied from [quizListCategoryId].
@ProviderFor(quizListCategoryId)
final quizListCategoryIdProvider = AutoDisposeProvider<String?>.internal(
  quizListCategoryId,
  name: r'quizListCategoryIdProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$quizListCategoryIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef QuizListCategoryIdRef = AutoDisposeProviderRef<String?>;
String _$quizListDifficultyHash() =>
    r'0cb1ac6c181afc99fceec759685de50ec3ea6fab';

/// See also [quizListDifficulty].
@ProviderFor(quizListDifficulty)
final quizListDifficultyProvider = AutoDisposeProvider<String?>.internal(
  quizListDifficulty,
  name: r'quizListDifficultyProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$quizListDifficultyHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef QuizListDifficultyRef = AutoDisposeProviderRef<String?>;
String _$quizListSearchQueryHash() =>
    r'04447e922f4e9c8de897a5ae1204331c4041a949';

/// See also [quizListSearchQuery].
@ProviderFor(quizListSearchQuery)
final quizListSearchQueryProvider = AutoDisposeProvider<String?>.internal(
  quizListSearchQuery,
  name: r'quizListSearchQueryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$quizListSearchQueryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef QuizListSearchQueryRef = AutoDisposeProviderRef<String?>;
String _$quizListIsPublicHash() => r'a653069591a74a2db69cbe3ec71432454bbcba92';

/// See also [quizListIsPublic].
@ProviderFor(quizListIsPublic)
final quizListIsPublicProvider = AutoDisposeProvider<bool?>.internal(
  quizListIsPublic,
  name: r'quizListIsPublicProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$quizListIsPublicHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef QuizListIsPublicRef = AutoDisposeProviderRef<bool?>;
String _$userQuizzesHash() => r'262475c96bae0aa3c39ecf43a50640f7f277e0d1';

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

/// User quizzes provider
///
/// Copied from [userQuizzes].
@ProviderFor(userQuizzes)
const userQuizzesProvider = UserQuizzesFamily();

/// User quizzes provider
///
/// Copied from [userQuizzes].
class UserQuizzesFamily extends Family<AsyncValue<List<Quiz>>> {
  /// User quizzes provider
  ///
  /// Copied from [userQuizzes].
  const UserQuizzesFamily();

  /// User quizzes provider
  ///
  /// Copied from [userQuizzes].
  UserQuizzesProvider call(String userId) {
    return UserQuizzesProvider(userId);
  }

  @override
  UserQuizzesProvider getProviderOverride(
    covariant UserQuizzesProvider provider,
  ) {
    return call(provider.userId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'userQuizzesProvider';
}

/// User quizzes provider
///
/// Copied from [userQuizzes].
class UserQuizzesProvider extends AutoDisposeFutureProvider<List<Quiz>> {
  /// User quizzes provider
  ///
  /// Copied from [userQuizzes].
  UserQuizzesProvider(String userId)
    : this._internal(
        (ref) => userQuizzes(ref as UserQuizzesRef, userId),
        from: userQuizzesProvider,
        name: r'userQuizzesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$userQuizzesHash,
        dependencies: UserQuizzesFamily._dependencies,
        allTransitiveDependencies: UserQuizzesFamily._allTransitiveDependencies,
        userId: userId,
      );

  UserQuizzesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    FutureOr<List<Quiz>> Function(UserQuizzesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserQuizzesProvider._internal(
        (ref) => create(ref as UserQuizzesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Quiz>> createElement() {
    return _UserQuizzesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserQuizzesProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserQuizzesRef on AutoDisposeFutureProviderRef<List<Quiz>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserQuizzesProviderElement
    extends AutoDisposeFutureProviderElement<List<Quiz>>
    with UserQuizzesRef {
  _UserQuizzesProviderElement(super.provider);

  @override
  String get userId => (origin as UserQuizzesProvider).userId;
}

String _$quizByIdHash() => r'5d377bbfa4e91540ee06b8d292e5c016dcdc65a1';

/// Quiz by ID provider
///
/// Copied from [quizById].
@ProviderFor(quizById)
const quizByIdProvider = QuizByIdFamily();

/// Quiz by ID provider
///
/// Copied from [quizById].
class QuizByIdFamily extends Family<AsyncValue<Quiz>> {
  /// Quiz by ID provider
  ///
  /// Copied from [quizById].
  const QuizByIdFamily();

  /// Quiz by ID provider
  ///
  /// Copied from [quizById].
  QuizByIdProvider call(String quizId) {
    return QuizByIdProvider(quizId);
  }

  @override
  QuizByIdProvider getProviderOverride(covariant QuizByIdProvider provider) {
    return call(provider.quizId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'quizByIdProvider';
}

/// Quiz by ID provider
///
/// Copied from [quizById].
class QuizByIdProvider extends AutoDisposeFutureProvider<Quiz> {
  /// Quiz by ID provider
  ///
  /// Copied from [quizById].
  QuizByIdProvider(String quizId)
    : this._internal(
        (ref) => quizById(ref as QuizByIdRef, quizId),
        from: quizByIdProvider,
        name: r'quizByIdProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$quizByIdHash,
        dependencies: QuizByIdFamily._dependencies,
        allTransitiveDependencies: QuizByIdFamily._allTransitiveDependencies,
        quizId: quizId,
      );

  QuizByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.quizId,
  }) : super.internal();

  final String quizId;

  @override
  Override overrideWith(FutureOr<Quiz> Function(QuizByIdRef provider) create) {
    return ProviderOverride(
      origin: this,
      override: QuizByIdProvider._internal(
        (ref) => create(ref as QuizByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        quizId: quizId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Quiz> createElement() {
    return _QuizByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is QuizByIdProvider && other.quizId == quizId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, quizId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin QuizByIdRef on AutoDisposeFutureProviderRef<Quiz> {
  /// The parameter `quizId` of this provider.
  String get quizId;
}

class _QuizByIdProviderElement extends AutoDisposeFutureProviderElement<Quiz>
    with QuizByIdRef {
  _QuizByIdProviderElement(super.provider);

  @override
  String get quizId => (origin as QuizByIdProvider).quizId;
}

String _$userResultsHash() => r'b423dc58b73244ccd818d348ca732c22f184f91b';

/// User quiz results provider
///
/// Copied from [userResults].
@ProviderFor(userResults)
const userResultsProvider = UserResultsFamily();

/// User quiz results provider
///
/// Copied from [userResults].
class UserResultsFamily extends Family<AsyncValue<List<QuizResult>>> {
  /// User quiz results provider
  ///
  /// Copied from [userResults].
  const UserResultsFamily();

  /// User quiz results provider
  ///
  /// Copied from [userResults].
  UserResultsProvider call(String userId) {
    return UserResultsProvider(userId);
  }

  @override
  UserResultsProvider getProviderOverride(
    covariant UserResultsProvider provider,
  ) {
    return call(provider.userId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'userResultsProvider';
}

/// User quiz results provider
///
/// Copied from [userResults].
class UserResultsProvider extends AutoDisposeFutureProvider<List<QuizResult>> {
  /// User quiz results provider
  ///
  /// Copied from [userResults].
  UserResultsProvider(String userId)
    : this._internal(
        (ref) => userResults(ref as UserResultsRef, userId),
        from: userResultsProvider,
        name: r'userResultsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$userResultsHash,
        dependencies: UserResultsFamily._dependencies,
        allTransitiveDependencies: UserResultsFamily._allTransitiveDependencies,
        userId: userId,
      );

  UserResultsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    FutureOr<List<QuizResult>> Function(UserResultsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserResultsProvider._internal(
        (ref) => create(ref as UserResultsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<QuizResult>> createElement() {
    return _UserResultsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserResultsProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserResultsRef on AutoDisposeFutureProviderRef<List<QuizResult>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserResultsProviderElement
    extends AutoDisposeFutureProviderElement<List<QuizResult>>
    with UserResultsRef {
  _UserResultsProviderElement(super.provider);

  @override
  String get userId => (origin as UserResultsProvider).userId;
}

String _$quizListHash() => r'1a8cab4474ebbaa7dab7c1edc303c59263a9bdab';

abstract class _$QuizList
    extends BuildlessAutoDisposeAsyncNotifier<List<Quiz>> {
  late final String? categoryId;
  late final String? difficulty;
  late final String? searchQuery;
  late final bool? isPublic;

  FutureOr<List<Quiz>> build({
    String? categoryId,
    String? difficulty,
    String? searchQuery,
    bool? isPublic,
  });
}

/// Quiz list state
///
/// Copied from [QuizList].
@ProviderFor(QuizList)
const quizListProvider = QuizListFamily();

/// Quiz list state
///
/// Copied from [QuizList].
class QuizListFamily extends Family<AsyncValue<List<Quiz>>> {
  /// Quiz list state
  ///
  /// Copied from [QuizList].
  const QuizListFamily();

  /// Quiz list state
  ///
  /// Copied from [QuizList].
  QuizListProvider call({
    String? categoryId,
    String? difficulty,
    String? searchQuery,
    bool? isPublic,
  }) {
    return QuizListProvider(
      categoryId: categoryId,
      difficulty: difficulty,
      searchQuery: searchQuery,
      isPublic: isPublic,
    );
  }

  @override
  QuizListProvider getProviderOverride(covariant QuizListProvider provider) {
    return call(
      categoryId: provider.categoryId,
      difficulty: provider.difficulty,
      searchQuery: provider.searchQuery,
      isPublic: provider.isPublic,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'quizListProvider';
}

/// Quiz list state
///
/// Copied from [QuizList].
class QuizListProvider
    extends AutoDisposeAsyncNotifierProviderImpl<QuizList, List<Quiz>> {
  /// Quiz list state
  ///
  /// Copied from [QuizList].
  QuizListProvider({
    String? categoryId,
    String? difficulty,
    String? searchQuery,
    bool? isPublic,
  }) : this._internal(
         () => QuizList()
           ..categoryId = categoryId
           ..difficulty = difficulty
           ..searchQuery = searchQuery
           ..isPublic = isPublic,
         from: quizListProvider,
         name: r'quizListProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$quizListHash,
         dependencies: QuizListFamily._dependencies,
         allTransitiveDependencies: QuizListFamily._allTransitiveDependencies,
         categoryId: categoryId,
         difficulty: difficulty,
         searchQuery: searchQuery,
         isPublic: isPublic,
       );

  QuizListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.categoryId,
    required this.difficulty,
    required this.searchQuery,
    required this.isPublic,
  }) : super.internal();

  final String? categoryId;
  final String? difficulty;
  final String? searchQuery;
  final bool? isPublic;

  @override
  FutureOr<List<Quiz>> runNotifierBuild(covariant QuizList notifier) {
    return notifier.build(
      categoryId: categoryId,
      difficulty: difficulty,
      searchQuery: searchQuery,
      isPublic: isPublic,
    );
  }

  @override
  Override overrideWith(QuizList Function() create) {
    return ProviderOverride(
      origin: this,
      override: QuizListProvider._internal(
        () => create()
          ..categoryId = categoryId
          ..difficulty = difficulty
          ..searchQuery = searchQuery
          ..isPublic = isPublic,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        categoryId: categoryId,
        difficulty: difficulty,
        searchQuery: searchQuery,
        isPublic: isPublic,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<QuizList, List<Quiz>>
  createElement() {
    return _QuizListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is QuizListProvider &&
        other.categoryId == categoryId &&
        other.difficulty == difficulty &&
        other.searchQuery == searchQuery &&
        other.isPublic == isPublic;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);
    hash = _SystemHash.combine(hash, difficulty.hashCode);
    hash = _SystemHash.combine(hash, searchQuery.hashCode);
    hash = _SystemHash.combine(hash, isPublic.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin QuizListRef on AutoDisposeAsyncNotifierProviderRef<List<Quiz>> {
  /// The parameter `categoryId` of this provider.
  String? get categoryId;

  /// The parameter `difficulty` of this provider.
  String? get difficulty;

  /// The parameter `searchQuery` of this provider.
  String? get searchQuery;

  /// The parameter `isPublic` of this provider.
  bool? get isPublic;
}

class _QuizListProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<QuizList, List<Quiz>>
    with QuizListRef {
  _QuizListProviderElement(super.provider);

  @override
  String? get categoryId => (origin as QuizListProvider).categoryId;
  @override
  String? get difficulty => (origin as QuizListProvider).difficulty;
  @override
  String? get searchQuery => (origin as QuizListProvider).searchQuery;
  @override
  bool? get isPublic => (origin as QuizListProvider).isPublic;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
