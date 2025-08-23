import 'package:arya/features/index.dart';
import 'package:arya/product/index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_route/auto_route.dart';

class ProfileActionsConsumer extends StatelessWidget {
  const ProfileActionsConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder: (context, viewModel, child) {
        if (!viewModel.hasUser) return const SizedBox.shrink();

        return PopupMenuButton<String>(
          color: Theme.of(context).colorScheme.surface,
          onSelected: (value) async {
            switch (value) {
              case 'off':
                context.router.push(const OffCredentialsRoute());
                break;
              case 'language':
                await showDialog<void>(
                  context: context,
                  builder: (context) => Dialog(
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 300),
                      padding: ProjectPadding.allMedium(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'dialogs.language.title'.tr(),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'dialogs.language.current_language'.tr(
                              args: [
                                context.locale.languageCode == 'tr'
                                    ? 'dialogs.language.turkish'.tr()
                                    : 'dialogs.language.english'.tr(),
                              ],
                            ),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(right: 8),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await ProductLocalization.updateLanguage(
                                        context: context,
                                        value: Locales.tr,
                                      );
                                      if (context.mounted) {
                                        Navigator.of(context).pop();
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'dialogs.language.changed_to_turkish'
                                                  .tr(),
                                            ),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          context.locale.languageCode == 'tr'
                                          ? Theme.of(
                                              context,
                                            ).colorScheme.primary
                                          : null,
                                      foregroundColor:
                                          context.locale.languageCode == 'tr'
                                          ? Theme.of(
                                              context,
                                            ).colorScheme.onPrimary
                                          : null,
                                    ),
                                    child: Text(
                                      'dialogs.language.turkish'.tr(),
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await ProductLocalization.updateLanguage(
                                        context: context,
                                        value: Locales.en,
                                      );
                                      if (context.mounted) {
                                        Navigator.of(context).pop();
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'dialogs.language.changed_to_english'
                                                  .tr(),
                                            ),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          context.locale.languageCode == 'en'
                                          ? Theme.of(
                                              context,
                                            ).colorScheme.primary
                                          : null,
                                      foregroundColor:
                                          context.locale.languageCode == 'en'
                                          ? Theme.of(
                                              context,
                                            ).colorScheme.onPrimary
                                          : null,
                                    ),
                                    child: Text(
                                      'dialogs.language.english'.tr(),
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('general.button.cancel'.tr()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
                break;
              case 'delete':
                await showDeleteAccountDialog(context, viewModel);
                break;
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'language',
              child: Row(
                children: [
                  Icon(Icons.language),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('settings.language'.tr()),
                        Text(
                          context.locale.languageCode == 'tr'
                              ? 'dialogs.language.turkish'.tr()
                              : 'dialogs.language.english'.tr(),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'off',
              child: Row(
                children: [
                  Icon(Icons.key),
                  SizedBox(width: 8),
                  Text('appbar.off_account'.tr()),
                ],
              ),
            ),

            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(
                    Icons.delete_forever,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'general.button.delete_account'.tr(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
