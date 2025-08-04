import 'package:flutter/material.dart';
import 'package:arya/features/auth/model/user_model.dart';

class UserInfoSection extends StatelessWidget {
  final UserModel user;

  const UserInfoSection({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Ad', user.name ?? 'Belirtilmemiş'),
        _buildInfoRow('Soyad', user.surname ?? 'Belirtilmemiş'),
        _buildInfoRow('Kullanıcı Adı', user.username ?? 'Belirtilmemiş'),
        _buildInfoRow('E-posta', user.email ?? 'Belirtilmemiş'),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
