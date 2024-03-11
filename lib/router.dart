import 'package:github_client/modules/auth/screens/sign_in_screen.dart';
import 'package:github_client/modules/search/screens/search_screen.dart';
import 'package:go_router/go_router.dart';

GoRouter router(String initialLocation) => GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => const SearchScreen(),
        ),
        GoRoute(
          path: '/signIn',
          builder: (context, __) => SignInScreen(
            onSignedIn: () {
              context.go('/');
            },
          ),
        ),
      ],
    );
