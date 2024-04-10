import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:machen_app/api/models/user/update_response.dart';
import 'package:machen_app/api/repositories/user_repository.dart';
import 'package:machen_app/components/input_tile.dart';
import 'package:machen_app/state/blocs/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  void initState() {
    var authBloc = context.read<AuthBloc>();
    authBloc.add(FetchMeAuthEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var authBloc = context.watch<AuthBloc>();
    var me = authBloc.state.me;

    Future<UserUpdateResponse> updateFunc(
        String? username, String? name, String? email) async {
      var response = await UserRepository()
          .update(authBloc.state.token, username, name, email);

      if (response.success == true) {
        authBloc.add(FetchMeAuthEvent());
      }
      return response;
    }

    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 75,
                  backgroundImage: NetworkImage(
                    authBloc.state.me?.profilePictureUrl ??
                        'https://storage.googleapis.com/machen-profile-pictures/empty.png',
                  ),
                ),
                Positioned(
                  right: 0.0,
                  bottom: 0.0,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey,
                    child: IconButton(
                      onPressed: () async {
                        var res = await pickProfilePicture(
                            authBloc.state.token, context);
                        if (res) {
                          authBloc.add(FetchMeAuthEvent());
                        }
                      },
                      icon: Icon(
                        authBloc.state.me?.profilePictureUrl == null
                            ? Icons.add
                            : Icons.edit,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            InputTile(
              title: "Username",
              value: me?.username ?? "",
              updateFunc: (String username) {
                return updateFunc(username, null, null);
              },
            ),
            InputTile(
                title: "Email",
                value: me?.email ?? "",
                updateFunc: (String email) {
                  return updateFunc(null, null, email);
                }),
            InputTile(
                title: "Display Name",
                value: me?.name ?? "",
                updateFunc: (String name) {
                  return updateFunc(null, name, null);
                }),
            const Spacer(),
            SafeArea(
              child: TextButton(
                onPressed: () {
                  authBloc.add(LogoutAuthEvent());
                  Navigator.pop(context);
                },
                child: const Text('Logout',
                    style: TextStyle(fontSize: 25, color: Colors.red)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Future<bool> pickProfilePicture(String token, BuildContext context) async {
  final ImagePicker picker = ImagePicker();
  XFile? image;

  await showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
              child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(20),
            ),
            padding:
                const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select Image Source',
                  style: TextStyle(fontSize: 20),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () async {
                        image =
                            await picker.pickImage(source: ImageSource.camera);
                        Navigator.pop(context);
                      },
                      child: const Text('Camera'),
                    ),
                    const SizedBox(width: 20),
                    TextButton(
                      onPressed: () async {
                        image =
                            await picker.pickImage(source: ImageSource.gallery);
                        Navigator.pop(context);
                      },
                      child: const Text('Gallery'),
                    ),
                  ],
                ),
              ],
            ),
          )));

  try {
    if (image == null) {
      return false;
    } else {
      var croppedFile = await ImageCropper().cropImage(
        sourcePath: image!.path,
        aspectRatio: const CropAspectRatio(
          ratioX: 1,
          ratioY: 1,
        ),
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
            aspectRatioLockEnabled: true,
            resetAspectRatioEnabled: false,
          )
        ],
        compressQuality: 50,
      );

      if (croppedFile == null) {
        return false;
      }
      var file = File(croppedFile.path);

      var res = await UserRepository().uploadProfilePicture(token, file);
      return res;
    }
  } on PlatformException catch (_) {
    // todo handle exception
  }
  return false;
}
