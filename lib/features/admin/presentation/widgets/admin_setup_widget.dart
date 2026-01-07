import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:doanlaptrinh/providers/firebase_providers.dart';
import 'package:doanlaptrinh/core/utils/logger.dart';

/// Widget to setup admin on app startup
class AdminSetupWidget extends ConsumerStatefulWidget {
  const AdminSetupWidget({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<AdminSetupWidget> createState() => _AdminSetupWidgetState();
}

class _AdminSetupWidgetState extends ConsumerState<AdminSetupWidget> {
  bool _isSetup = false;

  @override
  void initState() {
    super.initState();
    _setupAdmin();
  }

  Future<void> _setupAdmin() async {
    if (_isSetup) return;
    
    // Delay setup to avoid interfering with user login
    await Future.delayed(const Duration(seconds: 2));
    
    try {
      final adminSetupService = ref.read(adminSetupServiceProvider);
      final exists = await adminSetupService.adminExists();
      
      if (!exists) {
        AppLogger.info('Setting up default admin user...');
        final success = await adminSetupService.createDefaultAdmin();
        if (success) {
          AppLogger.info('Admin setup completed');
        } else {
          AppLogger.info('Admin setup skipped (network issue or other error)');
        }
      } else {
        AppLogger.info('Admin user already exists');
      }
      
      setState(() => _isSetup = true);
    } catch (e, stackTrace) {
      // Only log non-network errors as errors
      if (!e.toString().contains('network') && 
          !e.toString().contains('timeout') &&
          !e.toString().contains('unreachable')) {
        AppLogger.error('Admin setup error', e, stackTrace);
      } else {
        AppLogger.info('Admin setup skipped due to network issue');
      }
      setState(() => _isSetup = true); // Continue even if setup fails
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

