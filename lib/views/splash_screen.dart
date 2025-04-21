import 'package:battleships/view_models/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    var viewmodel = Provider.of<LoginViewModel>(context, listen: false);
    viewmodel.startupInitialization();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration:
            const BoxDecoration(image: DecorationImage(image: AssetImage("images/background.png"), fit: BoxFit.cover)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Image.asset("images/title.png"),
          ),
        ),
      ),
    );
  }
}