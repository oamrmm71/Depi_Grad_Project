import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:massar/Profile/services/profile_service.dart';
import 'package:massar/Profile/widgets/profile_avatar.dart';
import 'package:massar/Profile/widgets/profile_edit_chip.dart';
import 'package:massar/Profile/widgets/profile_fields.dart';
import 'package:massar/Profile/widgets/profile_save_button.dart';
import 'package:massar/custom%20widgets/app_background.dart';
import 'package:massar/custom%20widgets/page_title.dart';
import 'package:massar/custom%20widgets/bottom_nav_glass.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileService _service = ProfileService();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _cardExpiryController = TextEditingController();
  final _passportController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Uint8List? _imageBytes;

  bool _pickingImage = false;
  bool _editing = false;
  bool _loading = true;
  bool _saving = false;

  User? get _user => FirebaseAuth.instance.currentUser;

  DocumentReference<Map<String, dynamic>>? get _userDocRef {
    final uid = _user?.uid;

    if (uid == null) {
      return null;
    }

    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid);
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
    try {
      final data = await _service.loadProfile();

      _firstNameController.text =
          data['firstName'] ?? '';

      _lastNameController.text =
          data['lastName'] ?? '';

      _cardNumberController.text =
          data['cardNumber'] ?? '';

      _cardExpiryController.text =
          data['cardExpiry'] ?? '';

      _passportController.text =
          data['passportNumber'] ?? '';

      _emailController.text =
          data['email'] ??
          _service.currentUser?.email ??
          '';

      _imageBytes =
          await _service.getProfileImage(data);

    } catch (e) {
      _showMessage(
        "Failed to load profile: $e",
      );
    }

    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _saveProfile() async {

    setState(() {
      _saving = true;
    });

    try {

      await _service.saveProfile(
        firstName:
            _firstNameController.text.trim(),

        lastName:
            _lastNameController.text.trim(),

        cardNumber:
            _cardNumberController.text.trim(),

        cardExpiry:
            _cardExpiryController.text.trim(),

        passportNumber:
            _passportController.text.trim(),

        email:
            _emailController.text.trim(),

        imageBytes:
            _imageBytes,
      );


      if (_passwordController.text.isNotEmpty) {

        await _service.changePassword(
          password:
              _passwordController.text,

          confirmPassword:
              _confirmPasswordController.text,
        );

      }


      if (mounted) {

        setState(() {
          _editing = false;
        });

        _showMessage(
          "Profile updated",
        );
      }


    } catch(e){

      _showMessage(
        e.toString(),
      );

    }


    if(mounted){

      setState(() {
        _saving = false;
      });

    }
  }


  Future<void> _pickImage() async {

    setState(() {
      _pickingImage = true;
    });


    try {

      final picker = ImagePicker();

      final image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth:512,
        maxHeight:512,
        imageQuality:70,
      );


      if(image == null){
        return;
      }


      final bytes =
          await image.readAsBytes();


      if(bytes.length > 700 * 1024){

        _showMessage(
          "Image size is too large",
        );

        return;
      }


      setState(() {
        _imageBytes = bytes;
      });


    }catch(e){

      _showMessage(
        "Failed to pick image: $e",
      );

    }


    if(mounted){

      setState(() {
        _pickingImage = false;
      });

    }
  }


  void _toggleEdit(){

    if(_editing){

      _saveProfile();

      return;
    }


    setState(() {
      _editing = true;
    });

  }


  void _showMessage(String text){

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );

  }


  @override
  Widget build(BuildContext context){

    final size =
        MediaQuery.of(context).size;


    return Scaffold(

      body: Stack(

        fit: StackFit.expand,

        children:[

          const AppBackground(),


          SafeArea(

            child: Column(

              children:[

                Expanded(

                  child:

                  _loading

                  ?

                  const Center(

                    child:
                    CircularProgressIndicator(
                      color: Colors.white,
                    ),

                  )


                  :

                  SingleChildScrollView(

                    padding:
                    const EdgeInsets.symmetric(
                      horizontal:24,
                      vertical:18,
                    ),


                    child: Column(

                      children:[


                        const PageTitle(
                          firstLine:"MY",
                          secondLine:"PROFILE",
                        ),


                        SizedBox(
                          height:size.height*.02,
                        ),


                        ProfileAvatar(

                          imageBytes:
                          _imageBytes,

                          editable:
                          _editing,

                          loading:
                          _pickingImage,

                          onTap:
                          _pickImage,
                        ),



                        const SizedBox(
                          height:12,
                        ),



                        ProfileEditChip(

                          editing:
                          _editing,

                          loading:
                          _saving,

                          onPressed:
                          _toggleEdit,
                        ),



                        SizedBox(
                          height:size.height*.03,
                        ),



                        ProfileFields(

                          editing:_editing,

                          firstNameController:
                          _firstNameController,

                          lastNameController:
                          _lastNameController,

                          cardNumberController:
                          _cardNumberController,

                          cardExpiryController:
                          _cardExpiryController,

                          passportController:
                          _passportController,

                          emailController:
                          _emailController,

                          passwordController:
                          _passwordController,

                          confirmPasswordController:
                          _confirmPasswordController,

                        ),



                        SizedBox(
                          height:size.height*.03,
                        ),



                        if(_editing)

                        ProfileSaveButton(

                          loading:
                          _saving,

                          onPressed:
                          _saveProfile,

                        ),


                      ],

                    ),

                  ),

                ),



                const BottomNavGlass(
                  currentIndex:4,
                ),


              ],

            ),

          ),

        ],

      ),

    );

  }
}