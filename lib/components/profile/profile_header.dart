import 'package:flutter/material.dart';
import 'package:flutter_practice/core/constants/app_constants.dart';
import 'package:flutter_practice/features/auth/data/models/user_profile.dart';
import 'package:flutter_practice/features/auth/presentation/providers/auth_provider.dart';
import 'package:provider/provider.dart';

/// Anonymous user profile header (tappable to navigate to login).
class AnonymousProfileHeader extends StatelessWidget {
  const AnonymousProfileHeader({super.key});

  static const double _borderRadius = 12.0;
  static const double _avatarRadius = 32.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/login'),
      child: Container(
        margin: const EdgeInsets.all(AppConstants.spacingMedium),
        padding: const EdgeInsets.all(AppConstants.spacingLarge),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(_borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: _avatarRadius,
              backgroundColor: Colors.grey[300],
              child: const Icon(Icons.person, size: 32, color: Colors.grey),
            ),
            const SizedBox(width: AppConstants.spacingMedium),
            Text(
              'Anonymous User',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Authenticated user profile header.
class AuthenticatedProfileHeader extends StatelessWidget {
  const AuthenticatedProfileHeader({super.key, required this.user});

  final UserProfile user;

  static const double _borderRadius = 12.0;
  static const double _avatarRadius = 32.0;

  Future<void> _handleSignOut(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await context.read<AuthProvider>().logout();
      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppConstants.spacingMedium),
      padding: const EdgeInsets.all(AppConstants.spacingLarge),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: _avatarRadius,
            backgroundImage: NetworkImage(user.avatar),
            onBackgroundImageError: (_, __) {},
            child:
                user.avatar.isEmpty ? const Icon(Icons.person, size: 32) : null,
          ),
          const SizedBox(width: AppConstants.spacingMedium),
          Expanded(
            child: Text(
              user.username,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          GestureDetector(
            onTap: () => _handleSignOut(context),
            child: Text(
              'Sign Out',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Loading state profile header.
class LoadingProfileHeader extends StatelessWidget {
  const LoadingProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppConstants.spacingMedium),
      padding: const EdgeInsets.all(AppConstants.spacingLarge),
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
