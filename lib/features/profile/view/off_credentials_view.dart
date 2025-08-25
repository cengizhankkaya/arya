import 'package:arya/features/index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:provider/provider.dart';
import 'package:arya/product/index.dart';

@RoutePage()
class OffCredentialsView extends StatefulWidget {
  const OffCredentialsView({super.key});

  @override
  State<OffCredentialsView> createState() => _OffCredentialsViewState();
}

class _OffCredentialsViewState extends State<OffCredentialsView>
    with UrlLauncherMixin {
  late final OffCredentialsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = OffCredentialsViewModel();
    _viewModel.load();
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
      child: Consumer<OffCredentialsViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text('appbar.off_account'.tr()),
              elevation: 0,
              backgroundColor: AppColors.of(context).openfoodfacts,
              foregroundColor: AppColors.of(context).textStrong,
            ),
            body: SingleChildScrollView(
              padding: ProjectPadding.allLarge(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OffInfoCard(
                    onLaunchOpenFoodFacts: () => launchOpenFoodFacts(context),
                  ),
                  ProjectSizedBox.heightXXLarge,
                  const OffFormHeader(),
                  ProjectSizedBox.heightXLarge,
                  _buildForm(context, viewModel),
                  ProjectSizedBox.heightXLarge,
                  const OffHelpText(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildForm(BuildContext context, OffCredentialsViewModel viewModel) {
    return Form(
      key: viewModel.formKey,
      child: Column(
        children: [
          OffUsernameField(
            controller: viewModel.usernameController,
            validator: viewModel.validateUsername,
          ),
          ProjectSizedBox.heightLarge,
          OffPasswordField(
            controller: viewModel.passwordController,
            validator: viewModel.validatePassword,
          ),
          ProjectSizedBox.heightXXLarge,
          OffActionButtons(viewModel: viewModel),
        ],
      ),
    );
  }
}
