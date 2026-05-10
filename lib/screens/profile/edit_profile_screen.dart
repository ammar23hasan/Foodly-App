import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../theme/app_theme.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _phoneCtrl;
  final _formKey = GlobalKey<FormState>();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<UserProvider>();
    _nameCtrl = TextEditingController(text: user.name);
    _emailCtrl = TextEditingController(text: user.email);
    _phoneCtrl = TextEditingController(text: user.phone);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    context.read<UserProvider>().updateProfile(
      name: _nameCtrl.text,
      email: _emailCtrl.text,
      phone: _phoneCtrl.text,
    );
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully!'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>();
    final cardColor = Theme.of(context).cardColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    'Save',
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Avatar Picker ─────────────────────
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [user.avatarColor, user.avatarColor.withValues(alpha: 0.6)],
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 52,
                        backgroundColor: user.avatarColor,
                        child: Text(
                          user.name.isNotEmpty ? user.name[0].toUpperCase() : 'A',
                          style: const TextStyle(
                              fontSize: 40,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Choose Avatar Color',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: UserProvider.avatarColors.asMap().entries.map((e) {
                        final selected = e.key == user.avatarColorIndex;
                        return GestureDetector(
                          onTap: () => context.read<UserProvider>().setAvatarColor(e.key),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            width: selected ? 36 : 28,
                            height: selected ? 36 : 28,
                            decoration: BoxDecoration(
                              color: e.value,
                              shape: BoxShape.circle,
                              border: selected
                                  ? Border.all(color: Colors.white, width: 3)
                                  : null,
                              boxShadow: selected
                                  ? [BoxShadow(color: e.value.withValues(alpha: 0.5), blurRadius: 8)]
                                  : null,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // ── Fields ────────────────────────────
              _buildLabel('Full Name'),
              const SizedBox(height: 8),
              _buildField(
                controller: _nameCtrl,
                hint: 'Enter your full name',
                icon: Icons.person_outline,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Name is required' : null,
              ),
              const SizedBox(height: 20),

              _buildLabel('Email Address'),
              const SizedBox(height: 8),
              _buildField(
                controller: _emailCtrl,
                hint: 'Enter your email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Email is required';
                  if (!v.contains('@')) return 'Enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              _buildLabel('Phone Number'),
              const SizedBox(height: 8),
              _buildField(
                controller: _phoneCtrl,
                hint: 'Enter your phone number',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Phone is required' : null,
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15));
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
      ),
    );
  }
}
