// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_management_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$quizQuestionsHash() => r'9714745a83da5ffc1eea605a20fa7a4deb43a865';

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

/// Questions for a quiz provider
///
/// Copied from [quizQuestions].
@ProviderFor(quizQuestions)
const quizQuestionsProvider = QuizQuestionsFamily();

/// Questions for a quiz provider
///
/// Copied from [quizQuestions].
class QuizQuestionsFamily extends Family<AsyncValue<List<Question>>> {
  /// Questions for a quiz provider
  ///
  /// Copied from [quizQuestions].
  const QuizQuestionsFamily();

  /// Questions for a quiz provider
  ///
  /// Copied from [quizQuestions].
  QuizQuestionsProvider call(String quizId) {
    return QuizQuestionsProvider(quizId);
  }

  @override
  QuizQuestionsProvider getProviderOverride(
    covariant QuizQuestionsProvider provider,
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
  String? get name => r'quizQuestionsProvider';
}

/// Questions for a quiz provider
///
/// Copied from [quizQuestions].
class QuizQuestionsProvider extends AutoDisposeFutureProvider<List<Question>> {
  /// Questions for a quiz provider
  ///
  /// Copied from [quizQuestions].
  QuizQuestionsProvider(String quizId)
    : this._internal(
        (ref) => quizQuestions(ref as QuizQuestionsRef, quizId),
        from: quizQuestionsProvider,
        name: r'quizQuestionsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$quizQuestionsHash,
        dependencies: QuizQuestionsFamily._dependencies,
        allTransitiveDependencies:
            QuizQuestionsFamily._allTransitiveDependencies,
        quizId: quizId,
      );

  QuizQuestionsProvider._internal(
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
    FutureOr<List<Question>> Function(QuizQuestionsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: QuizQuestionsProvider._internal(
        (ref) => create(ref as QuizQuestionsRef),
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
  AutoDisposeFutureProviderElement<List<Question>> createElement() {
    return _QuizQuestionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is QuizQuestionsProvider && other.quizId == quizId;
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
mixin QuizQuestionsRef on AutoDisposeFutureProviderRef<List<Question>> {
  /// The parameter `quizId` of this provider.
  String get quizId;
}

class _QuizQuestionsProviderElement
    extends AutoDisposeFutureProviderElement<List<Question>>
    with QuizQuestionsRef {
  _QuizQuestionsProviderElement(super.provider);

  @override
  String get quizId => (origin as QuizQuestionsProvider).quizId;
}

String _$createQuestionHash() => r'cf2b22dceb6c1bcef0c37531fe3e5a83e8fb901d';

/// Create question provider
///
/// Copied from [createQuestion].
@ProviderFor(createQuestion)
const createQuestionProvider = CreateQuestionFamily();

/// Create question provider
///
/// Copied from [createQuestion].
class CreateQuestionFamily extends Family<AsyncValue<Question>> {
  /// Create question provider
  ///
  /// Copied from [createQuestion].
  const CreateQuestionFamily();

  /// Create question provider
  ///
  /// Copied from [createQuestion].
  CreateQuestionProvider call(Question question) {
    return CreateQuestionProvider(question);
  }

  @override
  CreateQuestionProvider getProviderOverride(
    covariant CreateQuestionProvider provider,
  ) {
    return call(provider.question);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'createQuestionProvider';
}

/// Create question provider
///
/// Copied from [createQuestion].
class CreateQuestionProvider extends AutoDisposeFutureProvider<Question> {
  /// Create question provider
  ///
  /// Copied from [createQuestion].
  CreateQuestionProvider(Question question)
    : this._internal(
        (ref) => createQuestion(ref as CreateQuestionRef, question),
        from: createQuestionProvider,
        name: r'createQuestionProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$createQuestionHash,
        dependencies: CreateQuestionFamily._dependencies,
        allTransitiveDependencies:
            CreateQuestionFamily._allTransitiveDependencies,
        question: question,
      );

  CreateQuestionProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.question,
  }) : super.internal();

  final Question question;

  @override
  Override overrideWith(
    FutureOr<Question> Function(CreateQuestionRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CreateQuestionProvider._internal(
        (ref) => create(ref as CreateQuestionRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        question: question,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Question> createElement() {
    return _CreateQuestionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CreateQuestionProvider && other.question == question;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, question.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CreateQuestionRef on AutoDisposeFutureProviderRef<Question> {
  /// The parameter `question` of this provider.
  Question get question;
}

class _CreateQuestionProviderElement
    extends AutoDisposeFutureProviderElement<Question>
    with CreateQuestionRef {
  _CreateQuestionProviderElement(super.provider);

  @override
  Question get question => (origin as CreateQuestionProvider).question;
}

String _$updateQuestionHash() => r'a7e62e10f88b28bdb2cfc93fef4a5921f2e0abb3';

/// Update question provider
///
/// Copied from [updateQuestion].
@ProviderFor(updateQuestion)
const updateQuestionProvider = UpdateQuestionFamily();

/// Update question provider
///
/// Copied from [updateQuestion].
class UpdateQuestionFamily extends Family<AsyncValue<Question>> {
  /// Update question provider
  ///
  /// Copied from [updateQuestion].
  const UpdateQuestionFamily();

  /// Update question provider
  ///
  /// Copied from [updateQuestion].
  UpdateQuestionProvider call(Question question) {
    return UpdateQuestionProvider(question);
  }

  @override
  UpdateQuestionProvider getProviderOverride(
    covariant UpdateQuestionProvider provider,
  ) {
    return call(provider.question);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'updateQuestionProvider';
}

/// Update question provider
///
/// Copied from [updateQuestion].
class UpdateQuestionProvider extends AutoDisposeFutureProvider<Question> {
  /// Update question provider
  ///
  /// Copied from [updateQuestion].
  UpdateQuestionProvider(Question question)
    : this._internal(
        (ref) => updateQuestion(ref as UpdateQuestionRef, question),
        from: updateQuestionProvider,
        name: r'updateQuestionProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$updateQuestionHash,
        dependencies: UpdateQuestionFamily._dependencies,
        allTransitiveDependencies:
            UpdateQuestionFamily._allTransitiveDependencies,
        question: question,
      );

  UpdateQuestionProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.question,
  }) : super.internal();

  final Question question;

  @override
  Override overrideWith(
    FutureOr<Question> Function(UpdateQuestionRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UpdateQuestionProvider._internal(
        (ref) => create(ref as UpdateQuestionRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        question: question,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Question> createElement() {
    return _UpdateQuestionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UpdateQuestionProvider && other.question == question;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, question.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UpdateQuestionRef on AutoDisposeFutureProviderRef<Question> {
  /// The parameter `question` of this provider.
  Question get question;
}

class _UpdateQuestionProviderElement
    extends AutoDisposeFutureProviderElement<Question>
    with UpdateQuestionRef {
  _UpdateQuestionProviderElement(super.provider);

  @override
  Question get question => (origin as UpdateQuestionProvider).question;
}

String _$deleteQuestionHash() => r'35231ae182d6ec323840f4ea913deafc4a3e52ac';

/// Delete question provider
///
/// Copied from [deleteQuestion].
@ProviderFor(deleteQuestion)
const deleteQuestionProvider = DeleteQuestionFamily();

/// Delete question provider
///
/// Copied from [deleteQuestion].
class DeleteQuestionFamily extends Family<AsyncValue<void>> {
  /// Delete question provider
  ///
  /// Copied from [deleteQuestion].
  const DeleteQuestionFamily();

  /// Delete question provider
  ///
  /// Copied from [deleteQuestion].
  DeleteQuestionProvider call(String questionId) {
    return DeleteQuestionProvider(questionId);
  }

  @override
  DeleteQuestionProvider getProviderOverride(
    covariant DeleteQuestionProvider provider,
  ) {
    return call(provider.questionId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'deleteQuestionProvider';
}

/// Delete question provider
///
/// Copied from [deleteQuestion].
class DeleteQuestionProvider extends AutoDisposeFutureProvider<void> {
  /// Delete question provider
  ///
  /// Copied from [deleteQuestion].
  DeleteQuestionProvider(String questionId)
    : this._internal(
        (ref) => deleteQuestion(ref as DeleteQuestionRef, questionId),
        from: deleteQuestionProvider,
        name: r'deleteQuestionProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$deleteQuestionHash,
        dependencies: DeleteQuestionFamily._dependencies,
        allTransitiveDependencies:
            DeleteQuestionFamily._allTransitiveDependencies,
        questionId: questionId,
      );

  DeleteQuestionProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.questionId,
  }) : super.internal();

  final String questionId;

  @override
  Override overrideWith(
    FutureOr<void> Function(DeleteQuestionRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DeleteQuestionProvider._internal(
        (ref) => create(ref as DeleteQuestionRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        questionId: questionId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _DeleteQuestionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DeleteQuestionProvider && other.questionId == questionId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, questionId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DeleteQuestionRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `questionId` of this provider.
  String get questionId;
}

class _DeleteQuestionProviderElement
    extends AutoDisposeFutureProviderElement<void>
    with DeleteQuestionRef {
  _DeleteQuestionProviderElement(super.provider);

  @override
  String get questionId => (origin as DeleteQuestionProvider).questionId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
