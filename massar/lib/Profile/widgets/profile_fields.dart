import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:massar/Profile/widgets/profile_text_field.dart';

class ProfileFields extends StatelessWidget {
  final bool editing;

  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController cardNumberController;
  final TextEditingController cardExpiryController;
  final TextEditingController passportController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const ProfileFields({
    super.key,
    required this.editing,
    required this.firstNameController,
    required this.lastNameController,
    required this.cardNumberController,
    required this.cardExpiryController,
    required this.passportController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ProfileTextField(
                controller: firstNameController,
                hint: "First Name",
                icon: Icons.person_outline,
                editing: editing,
                textInputAction: TextInputAction.next,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ProfileTextField(
                controller: lastNameController,
                hint: "Last Name",
                icon: Icons.person_outline,
                editing: editing,
                textInputAction: TextInputAction.next,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        ProfileTextField(
          controller: cardNumberController,
          hint: "Card Number",
          editing: editing,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(16),
          ],
          textInputAction: TextInputAction.next,
        ),

        const SizedBox(height: 10),

        ProfileTextField(
          controller: cardExpiryController,
          hint: "Card Expiry",
          editing: editing,
          keyboardType: TextInputType.datetime,
        ),

        const SizedBox(height: 10),

        ProfileTextField(
          controller: passportController,
          hint: "Passport No.",
          icon: Icons.badge_outlined,
          editing: editing,
          textInputAction: TextInputAction.next,
        ),

        const SizedBox(height: 10),

        ProfileTextField(
          controller: emailController,
          hint: "Email",
          icon: Icons.mail_outline,
          editing: editing,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),

        if (editing) ...[
          const SizedBox(height: 10),

          ProfileTextField(
            controller: passwordController,
            hint: "New Password (optional)",
            icon: Icons.lock_outline,
            editing: editing,
            obscureText: true,
            textInputAction: TextInputAction.next,
          ),

          const SizedBox(height: 10),

          ProfileTextField(
            controller: confirmPasswordController,
            hint: "Confirm New Password",
            icon: Icons.lock_outline,
            editing: editing,
            obscureText: true,
            textInputAction: TextInputAction.done,
          ),
        ],
      ],
    );
  }
}