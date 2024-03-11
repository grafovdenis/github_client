import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:github_client/modules/auth/domain/auth_use_case.dart';
import 'package:github_client/modules/auth/screens/sign_in_screen.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockAuthUseCase extends Mock implements AuthUseCase {}

void main() {
  testWidgets('SignInScreen should call onSignedIn callback on button press', (
    WidgetTester tester,
  ) async {
    final mock = MockAuthUseCase();

    when(() => mock.signIn()).thenAnswer((_) async {});

    bool isSignedIn = false;

    await tester.pumpWidget(
      Provider<AuthUseCase>(
        create: (context) => mock,
        child: MaterialApp(
          home: SignInScreen(onSignedIn: () => isSignedIn = true),
        ),
      ),
    );

    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();

    verify(() => mock.signIn()).called(1);

    expect(isSignedIn, true);
  });
}
