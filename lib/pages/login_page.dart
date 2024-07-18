import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/components/log_button.dart';
import 'package:chat_app/components/log_text_field.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final void Function()? onTap;

  LoginPage({super.key, required this.onTap});

  login(BuildContext context) async {
    final authService = AuthService();

    //try login
    try {
      await authService.signInWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );
    }
    //catch errors
    catch (e) {
      showDialog(
          context: context,
          builder: ((context) => AlertDialog(title: Text(e.toString()))));
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
            Text("Welcome back!",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 25,
                    fontWeight: FontWeight.bold)),

            //Login Form
            LogField(
              hintText: "Email",
              isHidden: false,
              controller: _emailController,
            ),

            const SizedBox(
              height: 10,
            ),

            LogField(
              hintText: "Password",
              isHidden: true,
              controller: _passwordController,
            ),

            const SizedBox(
              height: 10,
            ),

            //Button
            LogButton(
              text: "Login",
              onTap: () => login(context),
            ),

            const SizedBox(height: 10),

            //Register
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Not registered yet? Register ",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary)),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    "here",
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
