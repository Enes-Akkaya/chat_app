import 'package:chat_app/components/log_button.dart';
import 'package:chat_app/components/log_text_field.dart';
import 'package:flutter/material.dart';

import '../services/auth/auth_service.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final void Function()? onTap;

  RegisterPage({super.key, required this.onTap});

  register(BuildContext context) {
    //firstly get the auth service
    final _auth = AuthService();

    if (_passwordController.text == _confirmPasswordController.text) {
      try {
        _auth.createUserWithEmailAndPassword(_emailController.text,
            _passwordController.text, _nameController.text);
      } catch (e) {
        showDialog(
            context: context,
            builder: ((context) => AlertDialog(title: Text(e.toString()))));
      }
    } else {
      showDialog(
          context: context,
          builder: ((context) =>
              const AlertDialog(title: Text("Passwords do not match"))));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Logo
            Icon(
              Icons.message,
              size: 70,
              color: Theme.of(context).colorScheme.primary,
            ),

            const SizedBox(height: 20),

            //Welcome message
            Text("Welcome!",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 25,
                    fontWeight: FontWeight.bold)),

            LogField(
              hintText: "Name",
              isHidden: false,
              controller: _nameController,
            ),
            const SizedBox(
              height: 8,
            ),

            //Login Form
            LogField(
              hintText: "Email",
              isHidden: false,
              controller: _emailController,
            ),

            const SizedBox(
              height: 8,
            ),

            LogField(
              hintText: "Password",
              isHidden: true,
              controller: _passwordController,
            ),

            const SizedBox(
              height: 8,
            ),

            LogField(
              hintText: "Confirm password",
              isHidden: true,
              controller: _confirmPasswordController,
            ),

            const SizedBox(
              height: 8,
            ),

            //Button
            LogButton(
              text: "Register",
              onTap: () => register(context),
            ),

            const SizedBox(height: 10),

            //Register
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account? ",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary)),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    "Login now!",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ],
            )

            //
          ],
        ),
      ),
    );
  }
}
