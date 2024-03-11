import 'package:flutter/material.dart';
import 'package:github_client/modules/auth/domain/auth_use_case.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  final VoidCallback onSignedIn;

  const SignInScreen({
    super.key,
    required this.onSignedIn,
  });

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late final AuthUseCase _useCase;

  @override
  void initState() {
    super.initState();
    _useCase = context.read<AuthUseCase>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Please SignIn into the app'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _signIn,
          child: const Text('Sign in'),
        ),
      ),
    );
  }

  void _signIn() {
    _useCase.signIn().then((_) => widget.onSignedIn.call());
  }
}
