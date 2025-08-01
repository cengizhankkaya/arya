import 'package:arya/features/onboard/model/onboard_model.dart';
import 'package:flutter/material.dart';

class OnBoardCard extends StatelessWidget {
  const OnBoardCard({super.key, required this.onboardModel});

  final OnboardModel onboardModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Image.asset(onboardModel.imageWithPath),
          Text(onboardModel.title),
          Text(onboardModel.description),
        ],
      ),
    );
  }
}
