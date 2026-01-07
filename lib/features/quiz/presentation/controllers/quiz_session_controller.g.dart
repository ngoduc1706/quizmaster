// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_session_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$quizSessionHash() => r'3e4e3136150614e8621c9222eab0062ef23d5701';

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

abstract class _$QuizSession
    extends BuildlessAutoDisposeNotifier<QuizSessionState> {
  late final String quizId;

  QuizSessionState build(String quizId);
}

/// Quiz session controller
///
/// Copied from [QuizSession].
@ProviderFor(QuizSession)
const quizSessionProvider = QuizSessionFamily();

/// Quiz session controller
///
/// Copied from [QuizSession].
class QuizSessionFamily extends Family<QuizSessionState> {
  /// Quiz session controller
  ///
  /// Copied from [QuizSession].
  const QuizSessionFamily();

  /// Quiz session controller
  ///
  /// Copied from [QuizSession].
  QuizSessionProvider call(String quizId) {
    return QuizSessionProvider(quizId);
  }

  @override
  QuizSessionProvider getProviderOverride(
    covariant QuizSessionProvider provider,
  ) {
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
  String? get name => r'quizSessionProvider';
}

/// Quiz session controller
///
/// Copied from [QuizSession].
class QuizSessionProvider
    extends AutoDisposeNotifierProviderImpl<QuizSession, QuizSessionState> {
  /// Quiz session controller
  ///
  /// Copied from [QuizSession].
  QuizSessionProvider(String quizId)
    : this._internal(
        () => QuizSession()..quizId = quizId,
        from: quizSessionProvider,
        name: r'quizSessionProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$quizSessionHash,
        dependencies: QuizSessionFamily._dependencies,
        allTransitiveDependencies: QuizSessionFamily._allTransitiveDependencies,
        quizId: quizId,
      );

  QuizSessionProvider._internal(
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
  QuizSessionState runNotifierBuild(covariant QuizSession notifier) {
    return notifier.build(quizId);
  }

  @override
  Override overrideWith(QuizSession Function() create) {
    return ProviderOverride(
      origin: this,
      override: QuizSessionProvider._internal(
        () => create()..quizId = quizId,
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
  AutoDisposeNotifierProviderElement<QuizSession, QuizSessionState>
  createElement() {
    return _QuizSessionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is QuizSessionProvider && other.quizId == quizId;
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
mixin QuizSessionRef on AutoDisposeNotifierProviderRef<QuizSessionState> {
  /// The parameter `quizId` of this provider.
  String get quizId;
}

class _QuizSessionProviderElement
    extends AutoDisposeNotifierProviderElement<QuizSession, QuizSessionState>
    with QuizSessionRef {
  _QuizSessionProviderElement(super.provider);

  @override
  String get quizId => (origin as QuizSessionProvider).quizId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
