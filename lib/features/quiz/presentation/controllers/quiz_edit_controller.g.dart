// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_edit_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$updateQuizHash() => r'0ec5fe235241bdfe07c9fcb124285897b0d88185';

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

/// Update quiz provider
///
/// Copied from [updateQuiz].
@ProviderFor(updateQuiz)
const updateQuizProvider = UpdateQuizFamily();

/// Update quiz provider
///
/// Copied from [updateQuiz].
class UpdateQuizFamily extends Family<AsyncValue<Result<Quiz>>> {
  /// Update quiz provider
  ///
  /// Copied from [updateQuiz].
  const UpdateQuizFamily();

  /// Update quiz provider
  ///
  /// Copied from [updateQuiz].
  UpdateQuizProvider call(Quiz quiz) {
    return UpdateQuizProvider(quiz);
  }

  @override
  UpdateQuizProvider getProviderOverride(
    covariant UpdateQuizProvider provider,
  ) {
    return call(provider.quiz);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'updateQuizProvider';
}

/// Update quiz provider
///
/// Copied from [updateQuiz].
class UpdateQuizProvider extends AutoDisposeFutureProvider<Result<Quiz>> {
  /// Update quiz provider
  ///
  /// Copied from [updateQuiz].
  UpdateQuizProvider(Quiz quiz)
    : this._internal(
        (ref) => updateQuiz(ref as UpdateQuizRef, quiz),
        from: updateQuizProvider,
        name: r'updateQuizProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$updateQuizHash,
        dependencies: UpdateQuizFamily._dependencies,
        allTransitiveDependencies: UpdateQuizFamily._allTransitiveDependencies,
        quiz: quiz,
      );

  UpdateQuizProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.quiz,
  }) : super.internal();

  final Quiz quiz;

  @override
  Override overrideWith(
    FutureOr<Result<Quiz>> Function(UpdateQuizRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UpdateQuizProvider._internal(
        (ref) => create(ref as UpdateQuizRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        quiz: quiz,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Result<Quiz>> createElement() {
    return _UpdateQuizProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UpdateQuizProvider && other.quiz == quiz;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, quiz.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UpdateQuizRef on AutoDisposeFutureProviderRef<Result<Quiz>> {
  /// The parameter `quiz` of this provider.
  Quiz get quiz;
}

class _UpdateQuizProviderElement
    extends AutoDisposeFutureProviderElement<Result<Quiz>>
    with UpdateQuizRef {
  _UpdateQuizProviderElement(super.provider);

  @override
  Quiz get quiz => (origin as UpdateQuizProvider).quiz;
}

String _$deleteQuizHash() => r'18c5490d6bd1a5e71313234921af6e34f2ebedc4';

/// Delete quiz provider
///
/// Copied from [deleteQuiz].
@ProviderFor(deleteQuiz)
const deleteQuizProvider = DeleteQuizFamily();

/// Delete quiz provider
///
/// Copied from [deleteQuiz].
class DeleteQuizFamily extends Family<AsyncValue<Result<void>>> {
  /// Delete quiz provider
  ///
  /// Copied from [deleteQuiz].
  const DeleteQuizFamily();

  /// Delete quiz provider
  ///
  /// Copied from [deleteQuiz].
  DeleteQuizProvider call(String quizId) {
    return DeleteQuizProvider(quizId);
  }

  @override
  DeleteQuizProvider getProviderOverride(
    covariant DeleteQuizProvider provider,
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
  String? get name => r'deleteQuizProvider';
}

/// Delete quiz provider
///
/// Copied from [deleteQuiz].
class DeleteQuizProvider extends AutoDisposeFutureProvider<Result<void>> {
  /// Delete quiz provider
  ///
  /// Copied from [deleteQuiz].
  DeleteQuizProvider(String quizId)
    : this._internal(
        (ref) => deleteQuiz(ref as DeleteQuizRef, quizId),
        from: deleteQuizProvider,
        name: r'deleteQuizProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$deleteQuizHash,
        dependencies: DeleteQuizFamily._dependencies,
        allTransitiveDependencies: DeleteQuizFamily._allTransitiveDependencies,
        quizId: quizId,
      );

  DeleteQuizProvider._internal(
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
  Override overrideWith(
    FutureOr<Result<void>> Function(DeleteQuizRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DeleteQuizProvider._internal(
        (ref) => create(ref as DeleteQuizRef),
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
  AutoDisposeFutureProviderElement<Result<void>> createElement() {
    return _DeleteQuizProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DeleteQuizProvider && other.quizId == quizId;
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
mixin DeleteQuizRef on AutoDisposeFutureProviderRef<Result<void>> {
  /// The parameter `quizId` of this provider.
  String get quizId;
}

class _DeleteQuizProviderElement
    extends AutoDisposeFutureProviderElement<Result<void>>
    with DeleteQuizRef {
  _DeleteQuizProviderElement(super.provider);

  @override
  String get quizId => (origin as DeleteQuizProvider).quizId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
