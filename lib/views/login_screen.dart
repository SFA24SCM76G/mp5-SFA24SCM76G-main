import 'package:battleships/view_models/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Battleship",
          textAlign: TextAlign.center,
        ),
      ),
      body: Container(
        decoration:
            const BoxDecoration(image: DecorationImage(image: AssetImage("images/background.png"), fit: BoxFit.cover)),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints.tightFor(width: MediaQuery.of(context).size.width * 0.3),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Consumer<LoginViewModel>(builder: (context, viewModel, _) {
                  return Column(mainAxisSize: MainAxisSize.min, children: [
                    const SizedBox(height: 20 * 2),
                    TextFormField(
                      controller: viewModel.username,
                      autovalidateMode: viewModel.textValidations() ? null : AutovalidateMode.always,
                      decoration: const InputDecoration(hintText: "Enter username"),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter username";
                        }
                        if (value.length < 1) {
                          return "Please enter little bigger username";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: viewModel.password,
                      obscureText: true,
                      autovalidateMode: viewModel.textValidations() ? null : AutovalidateMode.always,
                      decoration: const InputDecoration(hintText: "Enter password"),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter password";
                        }
                        if (value.length < 1) {
                          return "Please enter little bigger password";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(child: TextButton(onPressed: viewModel.login, child: const Text("Login"))),
                        Expanded(child: TextButton(onPressed: viewModel.register, child: const Text("Registration")))
                      ],
                    ),
                    const SizedBox(height: 20),
                  ]);
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}