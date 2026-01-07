import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:doanlaptrinh/core/extensions/context_extensions.dart';
import 'package:doanlaptrinh/features/auth/presentation/controllers/auth_controller.dart';

/// Google Sign In button widget
class GoogleSignInButton extends ConsumerWidget {
  const GoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signInAsync = ref.watch(signInWithGoogleProvider);

    return ElevatedButton.icon(
      onPressed: signInAsync.isLoading
          ? null
          : () async {
              try {
                await ref.read(signInWithGoogleProvider.future);
                if (context.mounted) {
                  context.showSuccessSnackBar('Signed in successfully');
                }
              } catch (e) {
                if (context.mounted) {
                  context.showErrorSnackBar('Failed to sign in: ${e.toString()}');
                }
              }
            },
      icon: signInAsync.isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Image.asset(
              'assets/images/google_logo.png',
              width: 20,
              height: 20,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.g_mobiledata, size: 20);
              },
            ),
      label: Text(signInAsync.isLoading ? 'Signing in...' : 'Sign in with Google'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        minimumSize: const Size(double.infinity, 48),
      ),
    );
  }
}














