import 'package:flutter/material.dart';
import 'package:spotify_clone/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:spotify_clone/features/auth/view/widgets/custom_field.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sign Up.',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            CustomField(hintText: 'Name'),
            SizedBox(height: 15),
            CustomField(hintText: 'Email'),
            SizedBox(height: 15),
            CustomField(hintText: 'Password'),
            SizedBox(height: 15),
            AuthGradientButton(),
            SizedBox(height: 15),
            Text.rich(
              TextSpan(
                style: Theme.of(context).textTheme.titleMedium,
                children: [
                  TextSpan(text: 'Already have an accout? '),
                  TextSpan(text: 'Sign In', style: TextStyle()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
