import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/colors.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imagePath;
  final Function(String) onImageSelected;
  final bool isEditing;

  const ProfileAvatar({
    super.key,
    this.imagePath,
    required this.onImageSelected,
    this.isEditing = false,
  });

  Future<void> _pickImage(BuildContext context) async {
    if (!isEditing) return;

    final ImagePicker picker = ImagePicker();
    
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () async {
                Navigator.pop(ctx);
                final XFile? photo = await picker.pickImage(source: ImageSource.camera);
                if (photo != null) {
                  onImageSelected(photo.path);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () async {
                Navigator.pop(ctx);
                final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  onImageSelected(image.path);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider? imageProvider;
    
    if (imagePath != null && imagePath!.isNotEmpty) {
      if (imagePath!.startsWith('http')) {
        imageProvider = NetworkImage(imagePath!);
      } else {
        imageProvider = FileImage(File(imagePath!));
      }
    }

    return Center(
      child: Stack(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primaryYellow, width: 3),
              color: Colors.grey[200],
              image: imageProvider != null 
                  ? DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: imageProvider == null
                ? const Icon(Icons.person, size: 60, color: Colors.grey)
                : null,
          ),
          if (isEditing)
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => _pickImage(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryYellow,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 20,
                    color: AppColors.secondaryBlack,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
