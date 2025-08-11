import 'package:arya/features/onboard/model/onboard_model.dart';
import 'package:flutter/material.dart';

class TabIndicator extends StatefulWidget {
  const TabIndicator({super.key, required this.selectedIndex});
  final int selectedIndex;

  @override
  State<TabIndicator> createState() => _TabIndicatorState();
}

class _TabIndicatorState extends State<TabIndicator>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void didUpdateWidget(covariant TabIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _tabController.animateTo(widget.selectedIndex);
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: OnBoardModels.onboardModels.length,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TabPageSelector(
      controller: _tabController,
      selectedColor: Theme.of(context).colorScheme.primary,

      indicatorSize: 10.0,
      borderStyle: BorderStyle.solid,
    );
  }
}
