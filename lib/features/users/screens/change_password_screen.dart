import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _oldPassCtrl = TextEditingController();
  final _newPassCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  bool _isSaving = false;

  Future<void> _handleChangePassword() async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null) return;

    setState(() => _isSaving = true);

    try {
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: _oldPassCtrl.text.trim(),
      );

      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(_newPassCtrl.text.trim());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Đổi mật khẩu thành công!"),
            backgroundColor: const Color(0xFF015E53),
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "Đổi mật khẩu thất bại"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  void dispose() {
    _oldPassCtrl.dispose();
    _newPassCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: const Color(0xFF015E53),
        elevation: 0.6,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Đổi mật khẩu",
          style: textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 10),

              _buildPasswordField(
                context: context,
                controller: _oldPassCtrl,
                label: "Mật khẩu cũ",
                icon: Icons.lock_outline,
                validator: (v) =>
                    v == null || v.isEmpty ? "Vui lòng nhập mật khẩu cũ" : null,
              ),

              const SizedBox(height: 20),

              _buildPasswordField(
                context: context,
                controller: _newPassCtrl,
                label: "Mật khẩu mới",
                icon: Icons.lock_reset,
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return "Vui lòng nhập mật khẩu mới";
                  }
                  if (v.length < 6) {
                    return "Mật khẩu tối thiểu 6 ký tự";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              _buildPasswordField(
                context: context,
                controller: _confirmPassCtrl,
                label: "Xác nhận mật khẩu mới",
                icon: Icons.lock_outline,
                validator: (v) =>
                    v != _newPassCtrl.text ? "Mật khẩu không khớp" : null,
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _handleChangePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF015E53),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "Đổi mật khẩu",
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
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

  Widget _buildPasswordField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return TextFormField(
      controller: controller,
      obscureText: true,
      validator: validator,
      style: textTheme.bodyLarge?.copyWith(color: colors.onSurface),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF015E53)),
        labelText: label,
        labelStyle:
            textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
        filled: true,
        fillColor: colors.surface,
        errorStyle: TextStyle(color: colors.error),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: Color(0xFF015E53), width: 1),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
