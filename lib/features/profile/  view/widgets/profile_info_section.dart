import 'package:flutter/material.dart';
import 'package:home_staff/infra/staff/entity/staff_detail_entity.dart';

class ProfileInfoSection extends StatelessWidget {
  final StaffDetail staff;
  const ProfileInfoSection({super.key, required this.staff});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Thông tin cá nhân", style: theme.textTheme.titleMedium),
        const Divider(height: 24),
        _buildInputField(context, "Họ tên", staff.fullName),
        _buildInputField(context, "SĐT", staff.phoneNumber),
        _buildInputField(context, "Email", staff.email ?? "Không có"),
        _buildInputField(context, "Vai trò", staff.jobPosition ?? "Không rõ"),
      ],
    );
  }

  Widget _buildInputField(BuildContext context, String label, String value) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        initialValue: value,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          filled: true,
          fillColor: scheme.surfaceVariant.withOpacity(0.2),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: scheme.outlineVariant),
            borderRadius: BorderRadius.circular(12),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: scheme.outlineVariant),
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
