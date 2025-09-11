import 'package:arya/features/index.dart';
import 'package:arya/product/index.dart';
import 'package:arya/product/utility/theme/theme_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_route/auto_route.dart';

class ProfileActionsConsumer extends StatelessWidget {
  const ProfileActionsConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ProfileViewModel, ThemeViewModel>(
      builder: (context, profileViewModel, themeViewModel, child) {
        if (!profileViewModel.hasUser) return const SizedBox.shrink();

        return PopupMenuButton<String>(
          color: AppColors.of(context).addbackground,
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
                          ProjectSizedBox.heightMedium,
                          Text(
                            'dialogs.language.current_language'.tr(
                              args: [
                                (context.locale.languageCode) == 'tr'
                                    ? 'dialogs.language.turkish'.tr()
                                    : 'dialogs.language.english'.tr(),
                              ],
                            ),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          ProjectSizedBox.heightXLarge,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: ProjectPadding.rightSmall,
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
                                          (context.locale?.languageCode ??
                                                  'en') ==
                                              'tr'
                                          ? Theme.of(
                                              context,
                                            ).colorScheme.primary
                                          : null,
                                      foregroundColor:
                                          (context.locale?.languageCode ??
                                                  'en') ==
                                              'tr'
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
                                  padding: ProjectPadding.leftSmall,
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
                                          (context.locale?.languageCode ??
                                                  'en') ==
                                              'en'
                                          ? Theme.of(
                                              context,
                                            ).colorScheme.primary
                                          : null,
                                      foregroundColor:
                                          (context.locale?.languageCode ??
                                                  'en') ==
                                              'en'
                                          ? Theme.of(
                                              context,
                                            ).colorScheme.onPrimary
                                          : null,
                                    ),
                                    child: Text(
                                      'dialogs.language.english'.tr(),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.labelLarge,
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
              case 'theme':
                await themeViewModel.toggleTheme();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        themeViewModel.isDarkMode
                            ? 'settings.theme_changed_to_dark'.tr()
                            : 'settings.theme_changed_to_light'.tr(),
                      ),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
                break;
              case 'delete':
                await showDeleteAccountDialog(context, profileViewModel);
                break;
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'language',
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.language),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'settings.language'.tr(),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          (context.locale.languageCode) == 'tr'
                              ? 'dialogs.language.turkish'.tr()
                              : 'dialogs.language.english'.tr(),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'theme',
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    themeViewModel.isDarkMode
                        ? Icons.light_mode
                        : Icons.dark_mode,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'settings.theme'.tr(),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          themeViewModel.isDarkMode
                              ? 'settings.dark_theme'.tr()
                              : 'settings.light_theme'.tr(),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                          overflow: TextOverflow.ellipsis,
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.key),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'appbar.off_account'.tr(),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            PopupMenuItem(
              value: 'delete',
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.delete_forever,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'general.button.delete_account'.tr(),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                      overflow: TextOverflow.ellipsis,
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
