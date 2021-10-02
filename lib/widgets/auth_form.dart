import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '';

class AuthForm extends StatefulWidget {
  Function(
      {String email,
      String password,
      String username,
      bool isLogin,
      File profile,
      BuildContext context})? submitAuthForm;
  bool? isloading;
  AuthForm({
    @required this.submitAuthForm,
    @required this.isloading,
  });

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String _userName = '';
  String _userEmail = '';
  String _userPassword = '';

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  Future<void> onSave() async {
    final bool okay = _formKey.currentState!.validate();
    File assetImageFile = await getImageFileFromAssets('profile.jpg');
    if (okay) {
      _formKey.currentState!.save();
      widget.submitAuthForm!(
          email: _userEmail.trim(),
          isLogin: _isLogin,
          password: _userPassword.trim(),
          username: _userName.trim(),
          profile: imageSelected ? FileImage(imageFile!).file : assetImageFile,
          context: context);
    }
  }

  bool imageSelected = false;
  File? imageFile;

  Future<void> _pickImage() async {
    final xImageFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);
    if (xImageFile == null) {
      return;
    }
    setState(() {
      imageFile = File(xImageFile.path);
    });
    imageSelected = true;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  if (!_isLogin)
                    Stack(
                      children: [
                        Container(
                          width: 70,
                        ),
                        CircleAvatar(
                          radius: 50.0,
                          backgroundImage: imageSelected
                              ? FileImage(imageFile!) as ImageProvider<Object>?
                              : const AssetImage('assets/profile.jpg'),
                          backgroundColor: Colors.transparent,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: 40,
                            width: 40,
                            color: Colors.black54,
                            child: IconButton(
                              color: Colors.white,
                              iconSize: 27,
                              icon: const Icon(
                                Icons.edit,
                              ),
                              onPressed: _pickImage,
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (!_isLogin)
                    TextFormField(
                      key: UniqueKey(),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a username';
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(labelText: 'UserName'),
                      onSaved: (value) {
                        _userName = value!;
                      },
                    ),
                  TextFormField(
                    key: UniqueKey(),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Enter a valid Email address';
                      } else {
                        return null;
                      }
                    },
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (value) {
                      _userEmail = value!;
                    },
                  ),
                  TextFormField(
                    key: UniqueKey(),
                    decoration: const InputDecoration(labelText: 'password'),
                    obscureText: true,
                    validator: (value) {
                      if (value!.length <= 7) {
                        return 'Enter a password atleast 8 characters';
                      }
                    },
                    onSaved: (value) {
                      _userPassword = value!;
                    },
                  ),
                  widget.isloading!
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: onSave,
                          child: Text(_isLogin ? 'login' : 'SignUp'),
                          style: ElevatedButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 16),
                              shape: Theme.of(context).buttonTheme.shape
                                  as OutlinedBorder),
                        ),
                  if (!widget.isloading!)
                    TextButton(
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: Text(
                            _isLogin ? 'Sign Up Instead' : 'Log In Insted')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
