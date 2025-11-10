import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/authen_viewmodel.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final userVM = Provider.of<AuthenViewModel>(context);

    return Scaffold(
      body: userVM.isLoading
          ? const Center(child: CircularProgressIndicator())
          : userVM.currentUser == null
              ? const Center(child: Text("Không có thông tin người dùng"))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.blue.shade200,
                          backgroundImage: userVM.currentUser!.image.isNotEmpty
                              ? NetworkImage(userVM.currentUser!.image)
                              : null,
                          child: userVM.currentUser!.image.isEmpty
                              ? Text(
                                  userVM.currentUser!.fullName.isNotEmpty
                                      ? userVM.currentUser!.fullName[0].toUpperCase()
                                      : '?',
                                  style: const TextStyle(
                                    fontSize: 40,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(height: 12),

                        Text(
                          userVM.currentUser!.fullName,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 24),

                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildInfoRow('Email', userVM.currentUser!.email),
                                const SizedBox(height: 12),
                                _buildInfoRow('Số điện thoại', userVM.currentUser!.phone),
                                const SizedBox(height: 12),
                                _buildInfoRow(
                                  'Ngày tạo',
                                  userVM.currentUser!.createdAt != null
                                      ? userVM.currentUser!.createdAt!
                                          .toLocal()
                                          .toString()
                                          .split(' ')[0]
                                      : 'Chưa có',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title: ',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(color: Colors.black54),
          ),
        ),
      ],
    );
  }
}
