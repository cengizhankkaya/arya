import 'package:arya/features/profile/view_model/profile_view_model.dart';
import 'package:arya/features/profile/view/profile_actions_consumer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'profile_body.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ProfileViewModel();
    _viewModel.fetchUser();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profil'),
          actions: const [ProfileActionsConsumer()],
        ),
        body: const ProfileBody(),
      ),
    );
  }
}
