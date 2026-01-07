import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servicemen_technician_app/models/service_area_model.dart';
import 'package:servicemen_technician_app/models/services_categories_model.dart';
import '../../custom_widgets/app_dropdown_field_widget.dart';
import '../../custom_widgets/app_image_widget.dart';
import '../../custom_widgets/choose_image_widget.dart';
import '../../custom_widgets/custom_appbar.dart';
import '../../custom_widgets/custom_button.dart';
import '../../custom_widgets/custom_text_field.dart';
import '../../custom_widgets/multi_selected_drop_down_widget.dart';
import '../../models/document_view_model.dart';
import '../../models/experience_response_model.dart';
import '../../models/get_profile_model.dart' hide ServiceType, ServiceArea;
import '../../providers/auth_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_functions.dart';
import '../../utils/app_images.dart';
import '../../utils/app_routes.dart';
import '../../utils/app_textstyles.dart';
import '../../utils/build_extention.dart';

class ProfileInformationScreen extends StatelessWidget {
  ProfileInformationScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        title: context.read<AuthProvider>().isUpdateProfile == true
            ? context.l10n.personalInformation
            : context.l10n.profileSetup,
      ),
      body: Padding(
        padding:
            const EdgeInsetsGeometry.symmetric(horizontal: 15, vertical: 10),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildProfileImage(context),
              buildName(context),
              buildPhoneNumber(context),
              buildEmail(context),
              buildServiceCategoriesWidget(context),
              buildSkillDescription(context),
              buildServiceAreaWidget(context),
              buildExperienceWidget(context),
              uploadDocumentWidget(context),
              const SizedBox(height: 60),
              GradientButton(
                child: Text(
                  context.read<AuthProvider>().isUpdateProfile == true
                      ? context.l10n.save
                      : context.l10n.submit,
                  style: AppTextStyles.sf16kWhiteMediumTextStyle,
                ),
                onPressed: () async {
                  final provider = context.read<AuthProvider>();
                  print(
                      "provider.selectedServiceAreas?.isEmpty--${provider.selectedServiceAreas?.isEmpty.toString()}");
                  if (!_formKey.currentState!.validate()) return;
                  if (provider.selectedServiceTypes?.isEmpty ?? true) {
                    BotToast.showText(text: "Please select service types");
                    return;
                  } else if (provider.selectedServiceAreas?.isEmpty ?? true) {
                    BotToast.showText(text: "Please select service areas");
                    return;
                  } else if (provider.selectedExperience == null) {
                    BotToast.showText(text: "Please select experience");
                    return;
                  } else if (provider.documents.isEmpty) {
                    BotToast.showText(
                        text: "Please upload at least one id proof");
                    return;
                  }
                  final cancel = BotToast.showLoading();
                  try {
                    if (provider.isUpdateProfile == true) {
                      final List<File> filesToUpload = provider.documents
                          .where((item) => item.localFile != null)
                          .map((item) => File(item.localFile!.path!))
                          .toList();
                      print("filesToUpload===>${filesToUpload}");
                      if (filesToUpload.isNotEmpty) {
                        await provider.uploadDocuments();
                      }
                      final success = await provider.updateProfileApi(context);
                      // ALWAYS close loading
                      if (success) {
                        Navigator.pop(context);
                        BotToast.showText(text: "Profile updated successfully");
                        provider.getProfile(context);
                        provider.updateProfile(true);
                      } else {
                        BotToast.showText(
                            text: provider.errorMessage ?? "Error");
                      }
                    } else {
                      await provider.uploadDocuments().then((val) async {
                        if (val == true) {
                          final success = await provider.createProfile(context);
                          cancel();
                          if (success) {
                            Navigator.pushNamed(context, AppRoutes.home);
                          } else {
                            BotToast.showText(
                                text: provider.errorMessage ?? "Error");
                          }
                        }
                      });
                    }
                  } catch (e) {
                    print("Error--$e");
                  } finally {
                    cancel();
                  }
                },
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProfileImage(BuildContext context) {
    // final File? selectedImage = context.select<AuthProvider, File?>(
    //   (p) => p.image,
    // );

    return SizedBox(
      width: context.width,
      child: Center(
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.kGrey1),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: buildProfileImageWidget(
                    context) /*context.read<AuthProvider>().isUpdateProfile == true
                  ? buildUpdateProfileImage(context)
                  : (selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Image.file(
                            selectedImage,
                            height: 70,
                            width: 70,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Center(
                          child: AppImageWidget().svgImage(
                            imageName: AppImages.personIcon,
                            height: 70,
                            width: 70,
                          ),
                        )),*/
                ),
            GestureDetector(
              onTap: () {
                final provider = context.read<AuthProvider>();
                if (provider.isUpdateProfile == true) {
                  showUploadOrDeleteProfilePictureBottomSheet(context, (
                    v,
                  ) async {
                    if (v == true) {
                      final cancel = BotToast.showLoading();
                      try {
                        bool? val = await provider.deleteProfilePhoto();
                        if (val == true) {
                          provider.getProfile(context);
                          provider.updateProfile(true);
                        }
                        Navigator.pop(context);
                      } catch (e) {
                        print("Error--$e");
                      } finally {
                        cancel();
                      }
                    } else {
                      showImagePickerBottomSheet(context, (file) async {
                        final cancel = BotToast.showLoading();
                        try {
                          await provider.changeImage(file).then((c) async {
                            await provider.getProfile(context);
                            provider.updateProfile(true);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          });
                        } catch (e) {
                          print("Error--$e");
                        } finally {
                          cancel();
                        }
                      });
                    }
                  });
                } else {
                  showImagePickerBottomSheet(context, (file) async {
                    final cancel = BotToast.showLoading();
                    try {
                      await provider.changeImage(file).then((c) async {
                        await provider.getProfile(context);
                        Navigator.pop(context);
                      });
                    } catch (e) {
                      print("Error--$e");
                    } finally {
                      cancel();
                    }
                  });

                  // final provider = context.read<AuthProvider>();
                  // showImagePickerBottomSheet(context, (file) {
                  //   provider.changeImage(file);
                  // });
                }
              },
              child: Container(
                width: 37,
                height: 37,
                decoration: BoxDecoration(
                  color: AppColors.kGrey2,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: AppImageWidget().svgImage(
                    imageName: AppImages.cameraIcon,
                    height: 20,
                    width: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProfileImageWidget(BuildContext context) {
    final GetProfileResponseModel? model =
        context.select<AuthProvider, GetProfileResponseModel?>(
      (p) => p.getProfileResponseModel,
    );
    print(
      "model?.data!.customer!.profilePhoto--->${model?.data?.technician?.profilePhoto?.thumb}",
    );
    return model?.data?.technician?.profilePhoto == null
        ? Center(
            child: AppImageWidget().svgImage(
              imageName: AppImages.personIcon,
              height: 70,
              width: 70,
            ),
          )
        : AppImageWidget().customNetworkImage(
            radius: 70,
            image: model?.data?.technician!.profilePhoto!.thumb! ?? "",
          );
  }

  Widget buildName(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25, bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.name, style: AppTextStyles.sf14kBlackW400TextStyle),
          const SizedBox(height: 6),
          CustomTextField(
            controller: context.read<AuthProvider>().nameController,
            fillColor: AppColors.kWhite,
            hintText: context.l10n.enterYourNameHere,
            keyboardType: TextInputType.name,
            validator: (v) {
              if (isEmpty(v?.trim())) return "Please enter name";
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget buildEmail(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.email,
            style: AppTextStyles.sf14kBlackW400TextStyle,
          ),
          const SizedBox(height: 6),
          CustomTextField(
            controller: context.read<AuthProvider>().emailController,
            fillColor: AppColors.kWhite,
            hintText: context.l10n.enterYourEmailHere,
            keyboardType: TextInputType.emailAddress,
            validator: (v) => validateEmail(v),
          ),
        ],
      ),
    );
  }

  Widget buildPhoneNumber(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.phoneNumber,
            style: AppTextStyles.sf14kBlackW400TextStyle,
          ),
          const SizedBox(height: 6),
          CustomTextField(
            readOnly: true,
            fillColor: AppColors.kWhite,
            prefixIcon: AppImageWidget().svgImage(
              imageName: AppImages.indianFlagIcon,
            ),
            controller: context.read<AuthProvider>().loginPhoneNumberController,
          ),
        ],
      ),
    );
  }

  Widget buildSkillDescription(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                context.l10n.skillsDescription,
                style: AppTextStyles.sf14kBlackW400TextStyle,
              ),
              Text(
                ' (${context.l10n.max200Words})',
                style: AppTextStyles.sf12kGreyW400TextStyle,
              ),
            ],
          ),
          const SizedBox(height: 6),
          CustomTextField(
            hintText: context.l10n.writeHere,
            controller: context.read<AuthProvider>().skillDescriptionController,
            maxLines: 4,
            maxLength: 200,
            validator: (v) {
              if (isEmpty(v?.trim())) return "Please enter skill description";
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget buildExperienceWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Selector<AuthProvider, ExperienceResponseModel?>(
          selector: (_, p) => p.experienceResponseModel,
          builder: (_, experience, __) {
            return experience != null
                ? Selector<AuthProvider, String?>(
                    selector: (_, p) => p.selectedExperience,
                    builder: (_, ex, __) {
                      return AppDropdownField<String?>(
                        label: context.l10n.experience,
                        hint: context.l10n.select,
                        value: ex,
                        items: experience.data!
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ),
                            )
                            .toList(),
                        onChanged: (v) {
                          context.read<AuthProvider>().selectExperience(v!);
                        },
                      );
                    })
                : Container();
          }),
    );
  }

  Widget buildServiceCategoriesWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.categories,
            style: AppTextStyles.sf14kBlackW400TextStyle,
          ),
          const SizedBox(height: 6),
          Selector<AuthProvider, ServicesCategoriesModel?>(
              selector: (_, p) => p.servicesCategoriesModel,
              builder: (_, categories, __) {
                return categories?.data?.serviceTypes != null
                    ? MultiSelectDropdownButton2<ServiceType>(
                        items: categories!.data!.serviceTypes!,
                        initialSelectedItems:
                            context.read<AuthProvider>().isUpdateProfile == true
                                ? (context
                                        .read<AuthProvider>()
                                        .selectedServiceCategories ??
                                    [])
                                : const <ServiceType>[],
                        itemLabel: (s) => s.name.toString(),
                        compareFn: (a, b) => a.id == b.id,
                        onChanged: (values) {
                          List<int>? listOfIds = [];
                          for (var e in values) {
                            listOfIds.add(e.id!);
                          }
                          context
                              .read<AuthProvider>()
                              .addServiceTypes(listOfIds);
                        },
                      )
                    : Container();
              }),
        ],
      ),
    );
  }

  Widget buildServiceAreaWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.serviceAreas,
            style: AppTextStyles.sf14kBlackW400TextStyle,
          ),
          const SizedBox(height: 6),
          Selector<AuthProvider, ServiceAreaModel?>(
              selector: (_, p) => p.serviceAreaModel,
              builder: (_, categories, __) {
                return categories?.data?.serviceAreas != null
                    ? MultiSelectDropdownButton2<ServiceArea>(
                        items: categories!.data!.serviceAreas!,
                        initialSelectedItems:
                            context.read<AuthProvider>().isUpdateProfile == true
                                ? (context
                                        .read<AuthProvider>()
                                        .selectedServiceArea ??
                                    [])
                                : const <ServiceArea>[],
                        itemLabel: (s) => s.area.toString(),
                        compareFn: (a, b) => a.id == b.id,
                        onChanged: (values) {
                          List<int>? listOfIds = [];
                          for (var e in values) {
                            listOfIds.add(e.id!);
                          }

                          context
                              .read<AuthProvider>()
                              .addServiceAreas(listOfIds);
                          print(values.map((e) => e.id));
                        },
                      )
                    : Container();
              }),
        ],
      ),
    );
  }

  Widget uploadDocumentWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
            text: TextSpan(
                text: context.l10n.uploadIDProof,
                style: AppTextStyles.sf14kBlackW400TextStyle,
                children: [
              TextSpan(
                text: ' (${context.l10n.aadhaarPANDrivingLicenseVoterID})',
                style: AppTextStyles.sf12kGreyW400TextStyle,
              ),
            ])),
        const SizedBox(height: 6),

        /// UPLOAD BOX
        GestureDetector(
          onTap: () {
            context.read<AuthProvider>().onUploadTap();
          },
          child: Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.kGrey1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppImageWidget().svgImage(
                    imageName: AppImages.uploadIcon, height: 24, width: 24),
                const SizedBox(height: 8),
                Text(context.l10n.uploadDocuments,
                    style: AppTextStyles.sf14kPrimaryW400TextStyle),
              ],
            ),
          ),
        ),

        const SizedBox(height: 10),

        /// SUBTEXT
        Text(context.l10n.uploadPDFJEPGPNG,
            style: AppTextStyles.sf12kGreyW400TextStyle),

        const SizedBox(height: 12),

        /// PREVIEW

        Selector<AuthProvider, List<DocumentItem>>(
          selector: (_, p) => List<DocumentItem>.from(p.documents),
          builder: (_, documents, __) {
            if (documents.isEmpty) return const SizedBox();
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: List.generate(documents.length, (index) {
                final item = documents[index];
                return Container(
                  height: 90,
                  width: 90,
                  decoration: BoxDecoration(
                    color: AppColors.kGrey3,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 0,
                        child: Container(
                          width: 80,
                          height: 80,
                          padding: const EdgeInsets.all(5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Center(
                              child: _buildPreview(item),
                            ),
                          ),
                        ),
                      ),

                      /// REMOVE
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () async {
                            if (item.networkUrl != null) {
                              final cancel = BotToast.showLoading();
                              bool? success = await context
                                  .read<AuthProvider>()
                                  .deleteDocument(item.id!);

                              if (success == true) {
                                context
                                    .read<AuthProvider>()
                                    .removeDocument(index);
                              }
                              cancel();
                            } else {
                              context
                                  .read<AuthProvider>()
                                  .removeDocument(index);
                            }
                          },
                          child: AppImageWidget().svgImage(
                            imageName: AppImages.closeRoundBorderIcon,
                            height: 20,
                            width: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            );
          },
        )
      ],
    );
  }

  Widget _buildPreview(DocumentItem item) {
    if (item.localFile != null) {
      return buildFilePreview(item.localFile!);
    }

    if (item.networkUrl != null) {
      return item.networkUrl!.contains(".pdf")
          ? Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Image.asset(
                  AppImages.pdfImage,
                  height: 45,
                  width: 45,

                ),
            ),
          )
          : Image.network(
              item.networkUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
            );
    }

    return const SizedBox();
  }

  Widget buildFilePreview(PlatformFile file) {
    final ext = file.extension?.toLowerCase();
    print("ext--->$ext");
    if (ext == 'png' || ext == 'jpeg' || ext == "jpg") {
      if (file.bytes != null) {
        return Image.memory(
          file.bytes!,
          // fit: BoxFit.cover,
        );
      }
    }

    return const Icon(Icons.picture_as_pdf, size: 40, color: Colors.red);
  }
}
