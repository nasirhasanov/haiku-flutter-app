

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:haiku/cubits/user/profile_cubit.dart';
import 'package:haiku/data/models/user_info_model.dart';
import 'package:haiku/utilities/constants/app_keys.dart';
import 'package:haiku/utilities/helpers/bottom_options_provider.dart';
import 'package:haiku/utilities/helpers/bottom_sheet_dialogs.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../utilities/constants/app_assets.dart';
import '../../../../utilities/constants/app_colors.dart';
import '../../../../utilities/constants/app_paddings.dart';
import '../../../../utilities/constants/app_sized_boxes.dart';
import '../../../../utilities/constants/app_text_styles.dart';
import '../../../widgets/app/post/widgets/post_icon_widget.dart';
import '../../../widgets/global/profile_photo_widget.dart';

class ProfileInfoWidget extends StatelessWidget {
  const ProfileInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileCubit>();

    return StreamBuilder<UserInfoModel?>(
        initialData: null,
        stream: cubit.userInfoStream,
        builder: (context, snapshot) {
          final profilePicUrl = snapshot.data?.profilePicPath;
          final username = snapshot.data?.userName;
          final bio = snapshot.data?.bio;
          final score = snapshot.data?.score;

          return Container(
            color: Colors.transparent,
            child: Padding(
              padding: AppPaddings.h24 + AppPaddings.t8,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final options = BottomOptionsProvider.instance
                          .getOptionsForProfilePhoto();
                      if (profilePicUrl == null) {
                        var uploadPic = await _selectAndCropImage(context);
                        if (uploadPic != null) {
                           cubit.
                        }
                        return;
                      }
                      BottomDialog.showOptionsDialog(
                        context: context,
                        options: options,
                        onOptionSelected: (selectedOption) async {
                          if (selectedOption.key == AppKeys.seeProfilePhoto) {}
                        },
                      );
                    },
                    child: ProfilePhotoWidget(
                      imageRadius: 56,
                      imageUrl: profilePicUrl,
                    ),
                  ),
                  AppSizedBoxes.w24,
                  Padding(
                    padding: AppPaddings.t24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('@$username', style: AppTextStyles.normalBlack24),
                        AppSizedBoxes.h4,
                        Text('$bio', style: AppTextStyles.normalGrey20),
                        AppSizedBoxes.h4,
                        Row(
                          children: [
                            Text('$score', style: AppTextStyles.normalGrey20),
                            AppSizedBoxes.w8,
                            const PostIconWidget(
                                icon: AppAssets.clapFilled,
                                color: AppColors.gold),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<Uint8List?> _selectAndCropImage(BuildContext context) async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        cropStyle: CropStyle.circle,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              hideBottomControls: true,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: false),
          IOSUiSettings(
            aspectRatioLockEnabled: true,
            rotateButtonsHidden: true,
            aspectRatioPickerButtonHidden: true,
            aspectRatioLockDimensionSwapEnabled: true,
            resetAspectRatioEnabled: false,
          ),
        ],
      );

      if (croppedFile != null) {
        var compressedFile = await FlutterImageCompress.compressWithFile(
          croppedFile.path,
          quality: 50,
        );
        return compressedFile;
      }
    }
  }
}
