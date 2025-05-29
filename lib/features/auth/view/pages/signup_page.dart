import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:spotify_clone/core/theme/app_pallette.dart';
import 'package:spotify_clone/core/utils.dart';
import 'package:spotify_clone/core/widgets/loader.dart';
import 'package:spotify_clone/features/auth/view/pages/login_page.dart';
import 'package:spotify_clone/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:spotify_clone/features/auth/view/widgets/custom_field.dart';
import 'package:spotify_clone/features/auth/viewmodel/auth_viewmodel.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final nameCtl = TextEditingController();
  final passwordCtl = TextEditingController();
  final emailCtl = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameCtl.dispose();
    emailCtl.dispose();
    passwordCtl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authViewModelProvider)?.isLoading == true;

    ref.listen(authViewModelProvider, (_, next) {
      next?.when(
        data: (data) {
          showSnackBar(
            context,
            'Account created successfully, please sign in now!',
          );

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        },
        error: (error, st) {
          showSnackBar(context, error.toString());
        },
        loading: () {},
      );
    });
    return Scaffold(
      body:
          isLoading
              ? Loader()
              : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sign Up.',
                        style: Theme.of(
                          context,
                        ).textTheme.headlineMedium?.copyWith(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30),
                      CustomField(hintText: 'Name', controller: nameCtl),
                      SizedBox(height: 15),
                      CustomField(hintText: 'Email', controller: emailCtl),
                      SizedBox(height: 15),
                      CustomField(
                        hintText: 'Password',
                        controller: passwordCtl,
                        isObscure: true,
                      ),
                      SizedBox(height: 15),
                      AuthGradientButton(
                        buttonText: 'Sign Up',
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            await ref
                                .read(authViewModelProvider.notifier)
                                .signUpUser(
                                  name: nameCtl.text,
                                  email: emailCtl.text,
                                  password: passwordCtl.text,
                                );
                          } else {}
                        },
                      ),
                      SizedBox(height: 15),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                            (route) => false,
                          );
                        },
                        child: Text.rich(
                          TextSpan(
                            style: Theme.of(context).textTheme.titleMedium,
                            children: [
                              TextSpan(text: 'Already have an account? '),
                              TextSpan(
                                text: 'Sign In',
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
