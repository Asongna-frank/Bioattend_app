import 'package:flutter/material.dart';

class HomeController {
  final AnimationController profileImageController;

  HomeController({required this.profileImageController});

  Animation<double> get profileImageAnimation => Tween(begin: 1.0, end: 0.95).animate(profileImageController);

  Future<void> animateProfileImage() async {
    await profileImageController.forward();
    profileImageController.reverse();
  }
}
