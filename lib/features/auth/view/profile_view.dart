import 'package:arya/features/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          actions: [ProfileActionsConsumer()],
        ),
        body: Consumer<ProfileViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.errorMessage != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                    const SizedBox(height: 16),
                    Text(
                      viewModel.errorMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red[700]),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => viewModel.fetchUser(),
                      child: const Text('Tekrar Dene'),
                    ),
                  ],
                ),
              );
            }

            if (!viewModel.hasUser) {
              return const Center(child: Text("Kullanıcı verisi bulunamadı."));
            }

            final user = viewModel.user!;
            return _buildProfileContent(context, viewModel, user);
          },
        ),
      ),
    );
  }

  Widget _buildProfileContent(
    BuildContext context,
    ProfileViewModel viewModel,
    user,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profil başlığı
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text(
                    user.displayName.isNotEmpty
                        ? user.displayName[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user.displayName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (user.email != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    user.email!,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Kullanıcı bilgileri
          if (viewModel.isEditing) ...[
            const EditProfileForm(),
          ] else ...[
            UserInfoSection(user: user),
          ],
          // Tamamlanma durumu
          const SizedBox(height: 24),
          const ProfileCompletionStatus(),
        ],
      ),
    );
  }
}
