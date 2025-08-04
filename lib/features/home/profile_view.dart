// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:arya/features/auth/view_model/profile_view_model.dart';
// import 'package:arya/features/auth/auth_constants.dart';

// class ProfileView extends StatefulWidget {
//   const ProfileView({super.key});

//   @override
//   State<ProfileView> createState() => _ProfileViewState();
// }

// class _ProfileViewState extends State<ProfileView> {
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => ProfileViewModel(),
//       child: const _ProfileViewContent(),
//     );
//   }
// }

// class _ProfileViewContent extends StatefulWidget {
//   const _ProfileViewContent();

//   @override
//   State<_ProfileViewContent> createState() => _ProfileViewContentState();
// }

// class _ProfileViewContentState extends State<_ProfileViewContent> {
//   @override
//   void initState() {
//     super.initState();
//     // ViewModel'i başlat
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<ProfileViewModel>().initState();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profil'),
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//         actions: [
//           Consumer<ProfileViewModel>(
//             builder: (context, viewModel, child) {
//               return IconButton(
//                 icon: const Icon(Icons.logout),
//                 onPressed: viewModel.isLoading ? null : _handleSignOut,
//                 tooltip: 'Çıkış Yap',
//               );
//             },
//           ),
//         ],
//       ),
//       body: Consumer<ProfileViewModel>(
//         builder: (context, viewModel, child) {
//           return _buildBody(viewModel);
//         },
//       ),
//     );
//   }

//   Widget _buildBody(ProfileViewModel viewModel) {
//     if (viewModel.isLoading) {
//       return const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircularProgressIndicator(),
//             SizedBox(height: 16),
//             Text('Kullanıcı bilgileri yükleniyor...'),
//           ],
//         ),
//       );
//     }

//     if (viewModel.errorMessage != null) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.error_outline, size: 64, color: Colors.red),
//             const SizedBox(height: 16),
//             Text(
//               viewModel.errorMessage!,
//               textAlign: TextAlign.center,
//               style: const TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () => viewModel.refreshData(),
//               child: const Text('Tekrar Dene'),
//             ),
//           ],
//         ),
//       );
//     }

//     if (!viewModel.hasUserData) {
//       return const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.person_off, size: 64, color: Colors.grey),
//             SizedBox(height: 16),
//             Text(
//               'Kullanıcı bilgileri bulunamadı',
//               style: TextStyle(fontSize: 16),
//             ),
//           ],
//         ),
//       );
//     }

//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildProfileHeader(viewModel),
//           const SizedBox(height: 24),
//           _buildUserInfo(viewModel),
//           const SizedBox(height: 24),
//           _buildActions(viewModel),
//         ],
//       ),
//     );
//   }

//   Widget _buildProfileHeader(ProfileViewModel viewModel) {
//     return Center(
//       child: Column(
//         children: [
//           CircleAvatar(
//             radius: 50,
//             backgroundColor: Colors.blue.shade100,
//             child: Icon(Icons.person, size: 50, color: Colors.blue.shade700),
//           ),
//           const SizedBox(height: 16),
//           Text(
//             viewModel.fullName.isNotEmpty
//                 ? viewModel.fullName
//                 : 'İsimsiz Kullanıcı',
//             style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//           ),
//           if (viewModel.username.isNotEmpty) ...[
//             const SizedBox(height: 8),
//             Text(
//               '@${viewModel.username}',
//               style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _buildUserInfo(ProfileViewModel viewModel) {
//     return Card(
//       elevation: 2,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Kullanıcı Bilgileri',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             _buildInfoRow('Ad', viewModel.userData?.name ?? 'Belirtilmemiş'),
//             _buildInfoRow(
//               'Soyad',
//               viewModel.userData?.surname ?? 'Belirtilmemiş',
//             ),
//             _buildInfoRow(
//               'Kullanıcı Adı',
//               viewModel.userData?.username ?? 'Belirtilmemiş',
//             ),
//             _buildInfoRow(
//               'E-posta',
//               viewModel.userData?.email ?? 'Belirtilmemiş',
//             ),
//             _buildInfoRow(
//               'Kullanıcı ID',
//               viewModel.userData?.uid ?? 'Belirtilmemiş',
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 100,
//             child: Text(
//               '$label:',
//               style: const TextStyle(
//                 fontWeight: FontWeight.w500,
//                 color: Colors.grey,
//               ),
//             ),
//           ),
//           Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
//         ],
//       ),
//     );
//   }

//   Widget _buildActions(ProfileViewModel viewModel) {
//     return Card(
//       elevation: 2,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'İşlemler',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             ListTile(
//               leading: const Icon(Icons.edit, color: Colors.blue),
//               title: const Text('Profili Düzenle'),
//               subtitle: const Text('Kullanıcı bilgilerini güncelle'),
//               onTap: () => _showEditProfileDialog(viewModel),
//             ),
//             ListTile(
//               leading: const Icon(Icons.security, color: Colors.orange),
//               title: const Text('Şifre Değiştir'),
//               subtitle: const Text('Hesap güvenliğini artır'),
//               onTap: () => _showChangePasswordDialog(),
//             ),
//             ListTile(
//               leading: const Icon(Icons.delete_forever, color: Colors.red),
//               title: const Text('Hesabı Sil'),
//               subtitle: const Text('Hesabı kalıcı olarak sil'),
//               onTap: () => _showDeleteAccountDialog(viewModel),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _handleSignOut() async {
//     final viewModel = context.read<ProfileViewModel>();
//     final success = await viewModel.signOut();

//     if (success && mounted) {
//       Navigator.of(context).pushReplacementNamed(AuthConstants.loginRoute);
//     } else if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             viewModel.errorMessage ?? 'Çıkış yapılırken hata oluştu',
//           ),
//         ),
//       );
//     }
//   }

//   void _showEditProfileDialog(ProfileViewModel viewModel) {
//     // TODO: Profil düzenleme dialog'u
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Profil düzenleme özelliği yakında eklenecek'),
//       ),
//     );
//   }

//   void _showChangePasswordDialog() {
//     // TODO: Şifre değiştirme dialog'u
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Şifre değiştirme özelliği yakında eklenecek'),
//       ),
//     );
//   }

//   void _showDeleteAccountDialog(ProfileViewModel viewModel) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Hesabı Sil'),
//         content: const Text(
//           'Bu işlem hesabınızı kalıcı olarak silecektir. Bu işlem geri alınamaz. Devam etmek istediğinizden emin misiniz?',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('İptal'),
//           ),
//           TextButton(
//             onPressed: () async {
//               Navigator.of(context).pop();
//               final success = await viewModel.deleteAccount();
//               if (success && mounted) {
//                 Navigator.of(
//                   context,
//                 ).pushReplacementNamed(AuthConstants.loginRoute);
//               } else if (mounted) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text(
//                       viewModel.errorMessage ?? 'Hesap silinirken hata oluştu',
//                     ),
//                   ),
//                 );
//               }
//             },
//             style: TextButton.styleFrom(foregroundColor: Colors.red),
//             child: const Text('Sil'),
//           ),
//         ],
//       ),
//     );
//   }
// }
