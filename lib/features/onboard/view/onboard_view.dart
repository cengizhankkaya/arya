import 'package:arya/features/onboard/model/onboard_model.dart';
import 'package:arya/features/onboard/view/constants/onboard_constants.dart';
import 'package:arya/features/onboard/view/controller/onboard_controller.dart';
import 'package:arya/features/onboard/view/widget/onboard_card.dart';
import 'package:arya/features/onboard/view/widget/tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kartal/kartal.dart';

class OnBoardView extends StatefulWidget {
  const OnBoardView({super.key});

  @override
  State<OnBoardView> createState() => _OnBoardViewState();
}

class _OnBoardViewState extends State<OnBoardView> {
  late final OnboardController _controller;

  @override
  void initState() {
    super.initState();
    _controller = OnboardController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        return Scaffold(
          appBar: _buildAppBar(),
          body: Padding(
            padding: context.padding.medium,
            child: Column(
              children: [
                Expanded(child: _buildPageView()),
                _buildBottomRow(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPageView() {
    return PageView.builder(
      controller: _controller.pageController,
      itemCount: _controller.totalPages,
      onPageChanged: _controller.updateSelectedIndex,
      itemBuilder: (context, index) {
        return OnBoardCard(onboardModel: OnBoardModels.onboardModels[index]);
      },
    );
  }

  Widget _buildBottomRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TabIndicator(selectedIndex: _controller.selectedIndex),
        _buildNextButton(),
      ],
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 28, 226, 1),
      elevation: OnboardConstants.appBarElevation,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      actions: [
        if (!_controller.isBackEnabled)
          TextButton(
            onPressed: _controller.skipToLastPage,
            child: Text(
              OnboardConstants.skipText,
              style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
            ),
          ),
      ],
      leading: _controller.isFirstPage
          ? null
          : IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
              onPressed: _controller.previousPage,
            ),
    );
  }

  Widget _buildNextButton() {
    return FloatingActionButton(
      elevation: 0,
      backgroundColor: const Color.fromARGB(255, 28, 226, 1),
      onPressed: _controller.isLastPage
          ? _onStartPressed
          : _controller.nextPage,
      child: Text(
        _controller.isLastPage
            ? OnboardConstants.startText
            : OnboardConstants.nextText,
      ),
    );
  }

  void _onStartPressed() {
    // TODO: Navigate to main app or login screen
    print('Start button pressed - Navigate to main app');
  }
}
