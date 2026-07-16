import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'package:massar/theme/app_colors.dart';
import 'package:massar/custom%20widgets/bottom_nav_glass.dart';
import 'package:massar/custom%20widgets/glass_container.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _cardExpiryController = TextEditingController();
  final _passportController = TextEditingController();
  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Uint8List? _profileImageBytes;
  bool _isPickingImage = false;

  bool _isEditing = false;
  bool _isLoading = true;
  bool _isSaving = false;

  User? get _user => FirebaseAuth.instance.currentUser;

  DocumentReference<Map<String, dynamic>>? get _userDocRef {
    final uid = _user?.uid;
    if (uid == null) return null;
    return FirebaseFirestore.instance.collection('users').doc(uid);
  }

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _cardNumberController.dispose();
    _cardExpiryController.dispose();
    _passportController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final docRef = _userDocRef;
    if (docRef == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final snap = await docRef.get();
      final data = snap.data();

      if (data != null) {
        _firstNameController.text = data['firstName'] ?? '';
        _lastNameController.text = data['lastName'] ?? '';
        _cardNumberController.text = data['cardNumber'] ?? '';
        _cardExpiryController.text = data['cardExpiry'] ?? '';
        _passportController.text = data['passportNumber'] ?? '';
        _emailController.text = data['email'] ?? _user?.email ?? '';

        final photoBase64 = data['photoBase64'] as String?;
        if (photoBase64 != null && photoBase64.isNotEmpty) {
          try {
            _profileImageBytes = base64Decode(photoBase64);
          } catch (_) {
          }
        }
      } else {
        _emailController.text = _user?.email ?? '';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load profile: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProfile() async {
    final docRef = _userDocRef;
    if (docRef == null) return;

    setState(() => _isSaving = true);

    try {
      await docRef.set({
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'cardNumber': _cardNumberController.text.trim(),
        'cardExpiry': _cardExpiryController.text.trim(),
        'passportNumber': _passportController.text.trim(),
        'email': _emailController.text.trim(),
        'photoBase64': _profileImageBytes != null
            ? base64Encode(_profileImageBytes!)
            : null,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (_passwordController.text.isNotEmpty) {
        await _changePassword();
      }

      if (mounted) {
        setState(() => _isEditing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save profile: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _changePassword() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      throw Exception('Passwords do not match');
    }
    await _user?.updatePassword(_passwordController.text);
    _passwordController.clear();
    _confirmPasswordController.clear();
  }

  void _toggleEdit() {
    if (_isEditing) {
      _saveProfile();
    } else {
      setState(() => _isEditing = true);
    }
  }
  Future<void> _pickImage() async {
    setState(() => _isPickingImage = true);
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 70,
      );

      if (picked == null) return;

      final bytes = await picked.readAsBytes();

      if (bytes.length > 700 * 1024) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('That image is too large, pick a smaller one.'),
            ),
          );
        }
        return;
      }

      setState(() => _profileImageBytes = bytes);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isPickingImage = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final maxWidth = size.width > 700 ? 620.0 : size.width;

    final buttonHeight = (size.height * .065).clamp(42.0, 48.0);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  AppColors.screenBgGrad1,
                  AppColors.screenBgGrad2,
                  AppColors.screenBgGrad3,
                ],
                stops: [0.0, 0.45, 1.0],
              ),
            ),
          ),

          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(-0.9, 0.9),
                radius: 1.15,
                colors: [
                  AppColors.glowHigh,
                  AppColors.glowLow,
                  AppColors.transparent,
                ],
                stops: const [0.0, 0.55, 1.0],
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Column(
                  children: [
                    Expanded(
                      child: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : SingleChildScrollView(
                              padding:
                                  const EdgeInsets.fromLTRB(24, 18, 24, 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "MY",
                                    style: GoogleFonts.poppins(
                                      fontSize: 42,
                                      fontWeight: FontWeight.w200,
                                      fontStyle: FontStyle.italic,
                                      color: AppColors.white,
                                      height: 0.9,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    "PROFILE",
                                    style: GoogleFonts.poppins(
                                      fontSize: 44,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.white,
                                    ),
                                  ),
                                  SizedBox(height: size.height * .01),
                                  Center(
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: _isEditing && !_isPickingImage
                                              ? _pickImage
                                              : null,
                                          child: Stack(
                                            children: [
                                              Container(
                                                width: 157,
                                                height: 157,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: AppColors.avatarBg,
                                                  border: Border.all(
                                                    color:
                                                        AppColors.glassBorder,
                                                    width: 2,
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(.28),
                                                      blurRadius: 16,
                                                      offset:
                                                          const Offset(0, 8),
                                                    ),
                                                  ],
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4),
                                                  child: ClipOval(
                                                    child: _isPickingImage
                                                        ? const Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          )
                                                        : _profileImageBytes !=
                                                                null
                                                            ? Image.memory(
                                                                _profileImageBytes!,
                                                                fit: BoxFit
                                                                    .cover,
                                                              )
                                                            : Container(
                                                                color: AppColors
                                                                    .imageFailed,
                                                                child: const Icon(
                                                                    Icons
                                                                        .person,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 45),
                                                              ),
                                                  ),
                                                ),
                                              ),
                                              if (_isEditing)
                                                Positioned(
                                                  bottom: 6,
                                                  right: 6,
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            6),
                                                    decoration:
                                                        const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color:
                                                          AppColors.cardDark,
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
                                        ),
                                        const SizedBox(height: 10),
                                        Container(
                                          height: 30,
                                          width: 90,
                                          decoration: BoxDecoration(
                                            color: AppColors.cardDark,
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(.2),
                                                blurRadius: 8,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            onTap:
                                                _isSaving ? null : _toggleEdit,
                                            child: Center(
                                              child: _isSaving
                                                  ? const SizedBox(
                                                      height: 14,
                                                      width: 14,
                                                      child:
                                                          CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  : Text(
                                                      _isEditing
                                                          ? "Save"
                                                          : "Edit",
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color:
                                                            AppColors.white,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: size.height * .03),

                                        Row(
                                          children: [
                                            Expanded(
                                              child: _buildField(
                                                controller:
                                                    _firstNameController,
                                                hint: "First Name",
                                                icon: Icons.person_outline,
                                                textInputAction:
                                                    TextInputAction.next,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: _buildField(
                                                controller:
                                                    _lastNameController,
                                                hint: "Last Name",
                                                icon: Icons.person_outline,
                                                textInputAction:
                                                    TextInputAction.next,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),

                                        _buildField(
                                          controller: _cardNumberController,
                                          hint: "Card Number",
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            LengthLimitingTextInputFormatter(
                                                16),
                                          ],
                                          textInputAction:
                                              TextInputAction.next,
                                        ),
                                        const SizedBox(height: 10),

                                        _buildField(
                                          controller: _cardExpiryController,
                                          hint: "Card Expiry",
                                          keyboardType: TextInputType.datetime,
                                        ),

                                        const SizedBox(height: 10),
                                        _buildField(
                                          controller: _passportController,
                                          hint: "Passport No.",
                                          icon: Icons.badge_outlined,
                                          textInputAction:
                                              TextInputAction.next,
                                        ),
                                        const SizedBox(height: 10),
                                        _buildField(
                                          controller: _emailController,
                                          hint: "Email",
                                          icon: Icons.mail_outline,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          textInputAction:
                                              TextInputAction.next,
                                        ),
                                        if (_isEditing) ...[
                                          const SizedBox(height: 10),
                                          _buildField(
                                            controller: _passwordController,
                                            hint: "New Password (optional)",
                                            icon: Icons.lock_outline,
                                            obscureText: true,
                                            textInputAction:
                                                TextInputAction.next,
                                          ),
                                          const SizedBox(height: 10),
                                          _buildField(
                                            controller:
                                                _confirmPasswordController,
                                            hint: "Confirm New Password",
                                            icon: Icons.lock_outline,
                                            obscureText: true,
                                            textInputAction:
                                                TextInputAction.done,
                                          ),
                                        ],

                                        SizedBox(height: size.height * .03),
                                        if (_isEditing)
                                          Container(
                                            width: double.infinity,
                                            height: buttonHeight,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(.25),
                                                  blurRadius: 12,
                                                  offset: const Offset(0, 5),
                                                ),
                                              ],
                                            ),
                                            child: ElevatedButton(
                                              onPressed: _isSaving
                                                  ? null
                                                  : _saveProfile,
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        221, 255, 255, 255),
                                                foregroundColor: AppColors
                                                    .reserveBtnText,
                                                elevation: 0,
                                                shadowColor:
                                                    Colors.transparent,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30),
                                                ),
                                              ),
                                              child: Text(
                                                _isSaving
                                                    ? "Saving..."
                                                    : "Save",
                                                style: GoogleFonts.poppins(
                                                  color: AppColors
                                                      .reserveBtnText,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ),
                                        SizedBox(height: size.height * .02),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                    const BottomNavGlass(currentIndex: 4),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    IconData? icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return GlassContainer(
      height: 48,
      borderRadius: 24,
      backgroundColor: AppColors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: AppColors.white, size: 18),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              inputFormatters: inputFormatters,
              cursorColor: AppColors.white,
              // Read-only until the user taps Edit.
              readOnly: !_isEditing,
              style: GoogleFonts.poppins(
                color: AppColors.white,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isCollapsed: true,
                hintText: hint,
                hintStyle: GoogleFonts.poppins(
                  color: AppColors.whiteDim,
                  fontSize: 13,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}