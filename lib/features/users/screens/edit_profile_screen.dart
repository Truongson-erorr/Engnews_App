import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/authen_viewmodel.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthenViewModel>(context, listen: false).currentUser;
    _nameController = TextEditingController(text: user?.fullName ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final authVM = Provider.of<AuthenViewModel>(context, listen: false);
    await authVM.updateUserProfile(
      fullName: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
    );

    setState(() => _isSaving = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cập nhật thông tin thành công!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthenViewModel>(context).currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("Không có thông tin người dùng")),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: const Text(
          "Chỉnh sửa thông tin cá nhân",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 10),
              _buildTextField(
                controller: _nameController,
                label: "Họ và tên",
                icon: Icons.person_outline,
                validator: (v) => v!.isEmpty ? "Vui lòng nhập họ tên" : null,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _phoneController,
                label: "Số điện thoại",
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (v) => v!.isEmpty ? "Vui lòng nhập số điện thoại" : null,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _emailController,
                label: "Email",
                icon: Icons.email_outlined,
                readOnly: true,
                fillColor: const Color(0xFFE5E7EB),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFD0021B),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Lưu thay đổi",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    bool readOnly = false,
    TextInputType? keyboardType,
    Color fillColor = Colors.white,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color.fromARGB(255, 97, 97, 97)),
        labelText: label,
        labelStyle: const TextStyle(fontSize: 14, color: Colors.black87),
        filled: true,
        fillColor: fillColor,
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
