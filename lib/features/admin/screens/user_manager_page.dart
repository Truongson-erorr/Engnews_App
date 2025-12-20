import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/user_manager_viewmodel.dart';
import '../../models/user_model.dart';
import '../../admin/screens/edit_user_screen.dart';

class UserManagerPage extends StatefulWidget {
  const UserManagerPage({super.key});

  @override
  State<UserManagerPage> createState() => _UserManagerPageState();
}

class _UserManagerPageState extends State<UserManagerPage> {
  List<UserModel> _users = [];
  bool _isLoading = true;

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
      _isLoading = false;
    });
  }

  Future<void> _updateStatus(String uid, bool isActive) async {
    final vm = Provider.of<UserManagerViewModel>(context, listen: false);
    await vm.updateUserStatus(uid, isActive);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isActive ? "Đã mở khóa tài khoản" : "Đã chặn tài khoản"),
      ),
    );

    _loadUsers();
  }

  void _deleteUser(String uid) async {
    final vm = Provider.of<UserManagerViewModel>(context, listen: false);
    await vm.deleteUser(uid);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Đã xoá người dùng!")),
    );

    _loadUsers();
  }

  void _showStatusBottomSheet(UserModel user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),

              ListTile(
                leading: Icon(
                  user.isActive ? Icons.block : Icons.check_circle,
                  color: user.isActive
                      ? Colors.red.shade700
                      : Colors.green.shade700,
                ),
                title: Text(
                  user.isActive ? "Chặn tài khoản" : "Mở khóa tài khoản",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: user.isActive
                        ? Colors.red.shade700
                        : Colors.green.shade700,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _updateStatus(user.uid, !user.isActive);
                },
              ),

              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _users.isEmpty
              ? const Center(child: Text("Không có người dùng nào"))
              : RefreshIndicator(
                  onRefresh: _loadUsers,
                  child: ListView.builder(
                    itemCount: _users.length,
                    itemBuilder: (context, index) {
                      final user = _users[index];

                      return Card(
                        color: Colors.white,
                        surfaceTintColor: Colors.white,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  CircleAvatar(
                                    radius: 26,
                                    backgroundColor: Colors.grey.shade300,
                                    backgroundImage: user.image.isNotEmpty
                                        ? NetworkImage(user.image)
                                        : null,
                                    child: user.image.isEmpty
                                        ? const Icon(Icons.person,
                                            color: Colors.white)
                                        : null,
                                  ),
                                  const SizedBox(height: 6),

                                  InkWell(
                                    borderRadius: BorderRadius.circular(20),
                                    onTap: () => _showStatusBottomSheet(user),
                                    child: Container(
                                      height: 32,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      decoration: BoxDecoration(
                                        color: user.isActive
                                            ? Colors.green.shade50
                                            : Colors.orange.shade50,
                                        borderRadius:
                                            BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            user.isActive
                                                ? "Hoạt động"
                                                : "Chặn",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: user.isActive
                                                  ? Colors.green.shade700
                                                  : Colors.orange.shade700,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Icon(
                                            Icons.arrow_drop_down,
                                            size: 18,
                                            color: user.isActive
                                                ? Colors.green.shade700
                                                : Colors.orange.shade700,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.fullName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text("Email: ${user.email}"),
                                    Text("Role: ${user.role}"),
                                  ],
                                ),
                              ),

                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextButton(
                                    onPressed: user.isActive
                                        ? () async {
                                            final result =
                                                await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    EditUserPage(user: user),
                                              ),
                                            );
                                            if (result == true) {
                                              _loadUsers();
                                            }
                                          }
                                        : null,
                                    style: TextButton.styleFrom(
                                      backgroundColor: user.isActive
                                          ? Colors.blue.shade50
                                          : Colors.grey.shade200,
                                      foregroundColor: user.isActive
                                          ? Colors.blue.shade800
                                          : Colors.grey,
                                      minimumSize: const Size(60, 32),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                    ),
                                    child: const Text(
                                      "Chi tiết",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  TextButton(
                                    onPressed: () => _deleteUser(user.uid),
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.red.shade50,
                                      foregroundColor: Colors.red.shade800,
                                      minimumSize: const Size(60, 32),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                    ),
                                    child: const Text(
                                      "Xoá",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
