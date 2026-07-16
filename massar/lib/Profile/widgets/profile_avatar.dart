import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:massar/theme/app_colors.dart';

class ProfileAvatar extends StatelessWidget {
  final Uint8List? imageBytes;
  final bool editable;
  final bool loading;
  final VoidCallback? onTap;

  const ProfileAvatar({
    super.key,
    required this.imageBytes,
    required this.editable,
    required this.loading,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: editable ? onTap : null,
      child: Stack(
        children: [
          Container(
            width: 157,
            height: 157,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.avatarBg,
              border: Border.all(
                color: AppColors.glassBorder,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.28),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: ClipOval(
                child: _buildImage(),
              ),
            ),
          ),

          if (editable)
            Positioned(
              bottom: 6,
              right: 6,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.cardDark,
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (loading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    }

    if (imageBytes != null) {
      return Image.memory(
        imageBytes!,
        fit: BoxFit.cover,
      );
    }

    return Container(
      color: AppColors.imageFailed,
      child: const Icon(
        Icons.person,
        color: Colors.white,
        size: 45,
      ),
    );
  }
}