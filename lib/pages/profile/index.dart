import 'package:flutter/material.dart';
import 'package:flutter_practice/components/profile/components.dart';
import 'package:flutter_practice/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_practice/providers/product_provider.dart';
import 'package:provider/provider.dart';

/// Profile page displaying user info and recommended products.
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  static const String title = 'Profile';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final ScrollController _scrollController;
  late final ProductProvider _productProvider;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _productProvider = ProductProvider();
    _productProvider.loadMore();
  }

  /// Handles pull-to-refresh action to fetch latest profile data.
  Future<void> _handleRefresh() async {
    try {
      await context.read<AuthProvider>().fetchProfile();
    } catch (e) {
      // Error is handled in AuthProvider
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _productProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<AuthProvider>(
          builder: (context, auth, _) {
            return RefreshIndicator(
              onRefresh: _handleRefresh,
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: auth.state.when(
                      unauthenticated: () => const AnonymousProfileHeader(),
                      authenticated: (user) =>
                          AuthenticatedProfileHeader(user: user),
                      loading: () => const LoadingProfileHeader(),
                      error: (_) => const AnonymousProfileHeader(),
                    ),
                  ),
                  SliverAppBar(
                    pinned: true,
                    elevation: 0,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    title: Text(
                      'Guess You Like',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  ProfileProducts(
                    scrollController: _scrollController,
                    provider: _productProvider,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
