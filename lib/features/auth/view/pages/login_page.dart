import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:spotify_clone/core/theme/app_pallette.dart';
import 'package:spotify_clone/core/utils.dart';
import 'package:spotify_clone/core/widgets/loader.dart';
import 'package:spotify_clone/features/auth/services/auth_remote_service.dart';
import 'package:spotify_clone/features/auth/view/pages/signup_page.dart';
import 'package:spotify_clone/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:spotify_clone/features/auth/view/widgets/custom_field.dart';
import 'package:spotify_clone/features/auth/viewmodel/auth_viewmodel.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final passCtl = TextEditingController();
  final emailCtl = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailCtl.dispose();
    passCtl.dispose();

    // formKey.currentState!.validate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authViewModelProvider)?.isLoading == true;

    ref.listen(authViewModelProvider, (_, next) {
      next?.when(
        data: (data) {
          //TODO: Navigate to home page
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => const LoginPage()),
          // );
        },
        error: (error, st) {
          showSnackBar(context, error.toString());
        },
        loading: () {},
      );
    });

    return isLoading
        ? Loader()
        : Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Sign In.',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30),
                  CustomField(hintText: 'Email', controller: emailCtl),
                  SizedBox(height: 15),
                  CustomField(
                    hintText: 'Password',
                    controller: passCtl,
                    isObscure: true,
                  ),
                  SizedBox(height: 15),
                  AuthGradientButton(
                    buttonText: 'Sign In',
                    onTap: () async {
                      final res = await AuthRemoteService().signIn(
                        email: emailCtl.text,
                        password: passCtl.text,
                      );

                      final val = switch (res) {
                        Left(value: final l) => l,
                        Right(value: final r) => r,
                      };
                      print(val);
                    },
                  ),
                  SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => SignupPage()),
                        (route) => false,
                      );
                    },
                    child: Text.rich(
                      TextSpan(
                        style: Theme.of(context).textTheme.titleMedium,
                        children: [
                          TextSpan(text: 'Don\'t have an account? '),
                          TextSpan(
                            text: 'Sign Up',
                            style: TextStyle(color: Pallete.gradient2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
  }
}
