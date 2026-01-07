import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:doanlaptrinh/features/quiz/data/repositories/quiz_repository.dart';
import 'package:doanlaptrinh/features/quiz/data/repositories/category_repository.dart';
import 'package:doanlaptrinh/providers/firebase_providers.dart';

part 'shared_providers.g.dart';
// ignore_for_file: non_type_as_type_argument

/// Quiz repository provider
@riverpod
QuizRepository quizRepository(QuizRepositoryRef ref) {
  final firestore = ref.watch(firestoreProvider);
  // ignore: undefined_function
  return QuizRepository(firestore: firestore);
}

/// Category repository provider
@riverpod
CategoryRepository categoryRepository(CategoryRepositoryRef ref) {
  final firestore = ref.watch(firestoreProvider);
  return CategoryRepository(firestore: firestore);
}








