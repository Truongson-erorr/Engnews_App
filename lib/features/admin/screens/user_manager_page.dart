import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/user_manager_viewmodel.dart';
import '../../models/user_model.dart';

class UserManagerPage extends StatefulWidget {
  const UserManagerPage({super.key});

  @override
  State<UserManagerPage> createState() => _UserManagerPageState();
}

class _UserManagerPageState extends State<UserManagerPage> {
  List<UserModel> _users = [];
  List<UserModel> _filteredUsers = [];
  bool _isLoading = true;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final vm = Provider.of<UserManagerViewModel>(context, listen: false);

    setState(() => _isLoading = true);

    final fetched = await vm.fetchAllUsers();
    setState(() {
      _users = fetched;
      _filteredUsers = fetched;
      _isLoading = false;
    });
  }

  void _deleteUser(String uid) async {
    final vm = Provider.of<UserManagerViewModel>(context, listen: false);
    await vm.deleteUser(uid);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Đã xoá người dùng!")),
    );

    _loadUsers();
  }

  void _editUser(UserModel user) {

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5),
      child: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredUsers.isEmpty
                    ? const Center(child: Text("Không có người dùng nào"))
                    : RefreshIndicator(
                        onRefresh: _loadUsers,
                        child: ListView.builder(
                          itemCount: _filteredUsers.length,
                          itemBuilder: (context, index) {
                            final user = _filteredUsers[index];

                            return Card(
                              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              color: Colors.white,
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(12),

                                leading: CircleAvatar(
                                  radius: 26,
                                  backgroundColor: Colors.grey.shade300,
                                  backgroundImage: user.image != null && user.image!.isNotEmpty
                                      ? NetworkImage(user.image!)
                                      : null,
                                  child: (user.image == null || user.image!.isEmpty)
                                      ? const Icon(Icons.person, size: 28, color: Colors.white)
                                      : null,
                                ),

                                title: Text(
                                  user.fullName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black87),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text("Email: ${user.email}", style: const TextStyle(color: Colors.black54)),
                                    Text("Role: ${user.role}", style: const TextStyle(color: Colors.black54)),
                                  ],
                                ),

                                trailing: Wrap(
                                  direction: Axis.vertical,
                                  spacing: 8,
                                  children: [
                                    TextButton(
                                      onPressed: () => _editUser(user),
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: const Size(50, 32),
                                        backgroundColor: Colors.blue.shade50,
                                      ),
                                      child: const Text(
                                        "Sửa",
                                        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () => _deleteUser(user.uid),
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: const Size(50, 32),
                                        backgroundColor: Colors.red.shade50,
                                      ),
                                      child: const Text(
                                        "Xóa",
                                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),

                              ),
                            );

                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
