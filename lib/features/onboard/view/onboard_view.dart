import 'package:arya/features/index.dart';
import 'package:arya/product/index.dart';
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
      backgroundColor: Theme.of(context).colorScheme.primary,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      actions: [
        if (!_controller.isBackEnabled)
          TextButton(
            onPressed: _controller.skipToLastPage,
            child: Text(
              OnboardConstants.skipText,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
          ),
      ],
      leading: _controller.isFirstPage
          ? null
          : IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              onPressed: _controller.previousPage,
            ),
    );
  }

  Widget _buildNextButton() {
    return SizedBox(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // köşe yuvarlama
          ),
          elevation: 0,
        ),
        onPressed: _controller.isLastPage
            ? _onStartPressed
            : _controller.nextPage,
        child: Text(
          _controller.isLastPage
              ? OnboardConstants.startText
              : OnboardConstants.nextText,
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ),
    );
  }

  void _onStartPressed() {
    _completeOnboardingAndNavigate();
  }

  Future<void> _completeOnboardingAndNavigate() async {
    await AppPrefs.setHasOnboarded(true);
    if (!mounted) return;
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginView()));
  }
}
