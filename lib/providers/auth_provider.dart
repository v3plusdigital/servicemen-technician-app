import 'dart:async';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:servicemen_technician_app/models/experience_response_model.dart';
import '../models/create_profile_model.dart';
import '../models/document_view_model.dart';
import '../models/get_profile_model.dart' as get_profile;
import '../models/service_area_model.dart';
import '../models/services_categories_model.dart';
import '../models/verify_otp_model.dart';
import '../services/api/api_client.dart';
import '../helper/location_service_helper.dart';
import '../helper/native_ios_location_channel.dart';
import '../services/local_data/shared_pref.dart';
import '../services/local_data/shared_pref_keys.dart';
import '../services/repositories/auth_repository.dart';
import '../services/repositories/auth_repository_impl.dart';
import '../utils/app_functions.dart';
import '../utils/navigation_service.dart';

class AuthProvider extends ChangeNotifier {
  final TextEditingController loginPhoneNumberController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController skillDescriptionController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  String gender = "";
  final AuthRepository authRepo = AuthRepositoryImpl();
  final SharedPrefService pref = SharedPrefService();
  final ApiClient api = ApiClient.instance;
  VerifyOtpModel? verifyOtpModel;
  File? profileImage;
  bool isLoading = false;
  String? errorMessage;

  bool isLoggedIn = false;
  bool isNewUser = false;
  bool isUpdateProfile = false;
  String? _selectedExperience;
  final formKey = GlobalKey<FormState>();
  static const int _totalSeconds = 120;
  int _secondsLeft = _totalSeconds;
  Timer? _timer;
  get_profile.GetProfileResponseModel? _getProfileResponseModel;
  ServiceAreaModel? _serviceAreaModel;
  ServicesCategoriesModel? _servicesCategoriesModel;
  ExperienceResponseModel? _experienceResponseModel;

  // List<PlatformFile> selectedDocuments = [];
  List<int>? _selectedServiceTypes;
  List<int>? _selectedServiceAreas;
  List<ServiceType>? _selectedServiceCategories;
  List<ServiceArea>? _selectedServiceArea;

  File? get image => profileImage;

  int get secondsLeft => _secondsLeft;

  bool get canResend => _secondsLeft == 0;

  String? get selectedExperience => _selectedExperience;

  ServiceAreaModel? get serviceAreaModel => _serviceAreaModel;

  List<ServiceType>? get selectedServiceCategories =>
      _selectedServiceCategories;

  List<ServiceArea>? get selectedServiceArea => _selectedServiceArea;

  List<int>? get selectedServiceTypes => _selectedServiceTypes;

  List<int>? get selectedServiceAreas => _selectedServiceAreas;

  ServicesCategoriesModel? get servicesCategoriesModel =>
      _servicesCategoriesModel;

  ExperienceResponseModel? get experienceResponseModel =>
      _experienceResponseModel;

  get_profile.GetProfileResponseModel? get getProfileResponseModel =>
      _getProfileResponseModel;

  AuthProvider() {
    AuthSession.onUnauthorized = logoutUser;
  }

  Future<void> logoutUser() async {
    // Stop location tracking service before clearing session
    await _stopLocationService();

    // clear token / prefs here
    final val = await logout();
    if (val == true) {
      NavigationService.logoutToLogin();
    }
  }

  Future<void> _stopLocationService() async {
    try {
      if (Platform.isAndroid) {
        final running = await FlutterForegroundTask.isRunningService;
        if (running) {
          await FlutterForegroundTask.stopService();
        }
      } else if (Platform.isIOS) {
        await NativeIOSChannel.stop();
      }
    } catch (e) {
      print('Error stopping location service: $e');
    }
  }

  void startTimer() {
    _timer?.cancel();
    _secondsLeft = _totalSeconds;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft == 0) {
        timer.cancel();
        notifyListeners();
      } else {
        _secondsLeft--;
        notifyListeners();
      }
    });
  }

  void resetTimer() {
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> checkStatus() async {
    String? token = await pref.getStringValue(SharedPrefKey.token);
    bool? isNewUserVal = await pref.getBoolValue(SharedPrefKey.isNewUser);
    loginPhoneNumberController.text =
        await pref.getStringValue(SharedPrefKey.phone) ?? "";
    bool hasToken = token != null && token.isNotEmpty ? true : false;
    if (hasToken == true) {
      api.updateHeader(token: token);
    }
    isLoggedIn = hasToken;
    isNewUser = isNewUserVal ?? false;
  }

  Future<bool> logout() async {
    final success = await logoutApi();
    if (success == true) {
      loginPhoneNumberController.clear();
      await pref.clear();
      api.updateHeader(token: null);
    }
    return success;
  }

  void clearProfileValue() {
    nameController.clear();
    emailController.clear();
    skillDescriptionController.clear();
    _selectedExperience = null;
    profileImage = null;
    documents = [];
    _selectedServiceArea = [];

    _selectedServiceCategories = [];
    _selectedServiceAreas = [];
    _selectedServiceTypes = [];
    notifyListeners();
  }

  void updateProfile(bool val) {
    isUpdateProfile = val;
    notifyListeners();
  }

  void selectExperience(String val) {
    _selectedExperience = val;
    notifyListeners();
  }

  Future<void> changeImage(File file) async {
    profileImage = file;
    notifyListeners();
    await uploadProfile();
  }

  // void removeFile(int index) {
  //   final updatedList = List<PlatformFile>.from(selectedDocuments);
  //   updatedList.removeAt(index);
  //   selectedDocuments = updatedList;
  //   notifyListeners();
  // }

  Future<List<PlatformFile>> pickMultipleDocuments() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpeg', 'jpg'],
      withData: true,
    );

    return result?.files ?? [];
  }

  List<DocumentItem> documents = [];

  /// Call when profile loads (API response)
  void setExistingDocuments(List<get_profile.IdProof> proofs) {
    documents.clear();
    documents.addAll(
      proofs.map((p) => DocumentItem(networkUrl: p.idProofDocument, id: p.id)),
    );
    notifyListeners();
  }

  /// Add newly selected files
  void addLocalDocuments(List<PlatformFile> files) {
    List<DocumentItem> items = [];
    for (final file in files) {
      items.add(
        DocumentItem(localFile: file),
      );
    }
    documents = documents + items;

    notifyListeners();
  }

  void removeDocument(int index) {
    documents.removeAt(index);
    notifyListeners();
  }

  void onUploadTap() async {
    final files = await pickMultipleDocuments();
    if (files.isEmpty) return;

    addLocalDocuments(files);
    /*final files = await pickMultipleDocuments();
    if (files.isEmpty) return;
    final updatedList = List<PlatformFile>.from(selectedDocuments);
    for (final file in files) {
      if (!updatedList.any(
        (e) => e.name == file.name && e.size == file.size,
      )) {
        updatedList.add(file);
      }
    }*/
    // selectedDocuments = updatedList;
    notifyListeners();
  }

  addServiceTypes(List<int> typeList) {
    _selectedServiceTypes = typeList;
    notifyListeners();
  }

  addServiceAreas(List<int> areaList) {
    _selectedServiceAreas = areaList;
    notifyListeners();
    print("_selectedServiceAreas-->" + _selectedServiceAreas.toString());
  }

  /// Validate and call API
  Future<bool> requestOtp() async {
    final phone = loginPhoneNumberController.text.trim().replaceAll("-", "");

    if (phone.isEmpty) {
      errorMessage = "Phone number is required";
      notifyListeners();
      return false;
    }

    final validation = validatePhone(phone);
    if (validation != null) {
      errorMessage = validation;
      notifyListeners();
      return false;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await authRepo.requestOtp(phoneNumber: phone);

      if (response.success) {
        startTimer();
        return true;
      } else {
        errorMessage = response.error?.message;
        return false;
      }
    } catch (e) {
      errorMessage = "Something went wrong";
      print("E----$e");
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> verifyOtp() async {
    isLoading = true;
    errorMessage = null;
    verifyOtpModel = null;
    notifyListeners();

    try {
      final response = await authRepo.verifyOtp(
        phoneNumber: loginPhoneNumberController.text.trim().replaceAll("-", ""),
        otp: "123456",
      );

      if (response.success) {
        verifyOtpModel = VerifyOtpModel.fromJson(
          response.data as Map<String, dynamic>,
        );
        final token = verifyOtpModel?.data?.accessToken;
        final refreshToken = verifyOtpModel?.data?.refreshToken;
        final isNewUser = verifyOtpModel?.data?.isNewUser;
        final phone = verifyOtpModel?.data?.technician?.phone;
        final userId = verifyOtpModel?.data?.technician?.id;

        await pref.setStringValue(SharedPrefKey.token, token.toString());
        await pref.setBoolValue(SharedPrefKey.isNewUser, isNewUser!);
        await pref.setStringValue(SharedPrefKey.phone, phone!);
        await pref.setStringValue(
          SharedPrefKey.refreshToken,
          refreshToken.toString(),
        );
        await pref.setStringValue(SharedPrefKey.userId, userId.toString());

        api.updateHeader(token: token);

        return true;
      } else {
        errorMessage = response.error?.message;
        return false;
      }
    } catch (_) {
      errorMessage = "Something went wrong";
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createProfile(BuildContext context) async {
    errorMessage = null;
    verifyOtpModel = null;
    notifyListeners();

    try {
      ProfileCreateRequest model = ProfileCreateRequest(
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          serviceTypeIds: _selectedServiceTypes,
          skillsDescription: skillDescriptionController.text.trim(),
          serviceAreaIds: _selectedServiceAreas,
          experience: _selectedExperience);
      final response = await authRepo.createProfile(profileRequest: model);

      if (response.success) {
        await pref.setBoolValue(SharedPrefKey.isNewUser, false);
        return true;
      } else {
        errorMessage = response.error!.message;
        return false;
      }
    } catch (_) {
      errorMessage = "Something went wrong";
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> updateProfileApi(BuildContext context) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      ProfileCreateRequest model = ProfileCreateRequest(
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          serviceTypeIds: _selectedServiceTypes,
          skillsDescription: skillDescriptionController.text.trim(),
          serviceAreaIds: _selectedServiceAreas,
          experience: _selectedExperience);
      final response = await authRepo.updateProfile(profileRequest: model);

      if (response.success) {
        return true;
      } else {
        errorMessage = response.error?.message;
        return false;
      }
    } catch (_) {
      errorMessage = "Something went wrong";
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> uploadProfile() async {
    if (image == null) return;
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final response = await authRepo.uploadProfilePhoto(profileFile: image!);
      if (response.success) {
        BotToast.showText(text: "Profile image uploaded successfully");
      } else {
        errorMessage = response.message;
        BotToast.showText(text: errorMessage.toString());
      }
    } catch (_) {
      errorMessage = "Something went wrong";
      BotToast.showText(text: errorMessage.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> uploadDocuments() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final List<File> files = [];
      for (var e in documents) {
        if (e.localFile != null) {
          files.add(File(e.localFile!.path!));
        }
      }
      final response = await authRepo.uploadDocuments(documents: files);
      if (response.success) {
        print("Documents uploaded successfully");
        return true;
      } else {
        errorMessage = response.message;
        print("Documents upload failed ${errorMessage.toString()}");
        return false;
      }
    } catch (_) {
      errorMessage = "Something went wrong";
      BotToast.showText(text: errorMessage.toString());
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool?> deleteDocument(int id) async {
    errorMessage = null;
    notifyListeners();

    try {
      final response = await authRepo.deleteDocument(id);
      if (response.success) {
        return true;
      } else {
        errorMessage = response.message;
        BotToast.showText(text: errorMessage.toString());
        return false;
      }
    } catch (_) {
      errorMessage = "Something went wrong";
      BotToast.showText(text: errorMessage.toString());
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<bool?> deleteProfilePhoto() async {
    if (getProfileResponseModel?.data?.technician?.profilePhoto == null) {
      return null;
    }
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await authRepo.deleteProfilePhoto();
      if (response.success) {
        BotToast.showText(text: "Profile image deleted successfully");
        return true;
      } else {
        errorMessage = response.message;
        BotToast.showText(text: errorMessage.toString());
        return false;
      }
    } catch (_) {
      errorMessage = "Something went wrong";
      BotToast.showText(text: errorMessage.toString());
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setProfileValues() {
    nameController.text =
        _getProfileResponseModel?.data?.technician?.name ?? "";
    loginPhoneNumberController.text =
        _getProfileResponseModel?.data?.technician?.phone ?? "";
    emailController.text =
        _getProfileResponseModel?.data?.technician?.email ?? "";
    skillDescriptionController.text =
        _getProfileResponseModel?.data?.technician?.skillsDescription ?? "";
    _selectedExperience =
        _getProfileResponseModel?.data?.technician?.experience;
    if (_servicesCategoriesModel != null) {
      List<ServiceType>? serviceTypeList = _servicesCategoriesModel
          ?.data?.serviceTypes
          ?.where((b) => (_getProfileResponseModel?.data?.serviceTypes ?? [])
              .any((s) => s.id == b.id))
          .toList();
      _selectedServiceCategories = serviceTypeList;
      List<int> listCategory = _getProfileResponseModel!.data!.serviceTypes!
          .map((e) => e.id)
          .whereType<int>()
          .toList();
      addServiceTypes(listCategory);
    }
    if (_serviceAreaModel != null) {
      List<ServiceArea>? serviceAreaList = _serviceAreaModel?.data?.serviceAreas
          ?.where((b) => (_getProfileResponseModel?.data?.serviceAreas ?? [])
              .any((s) => s.id == b.id))
          .toList();
      _selectedServiceArea = serviceAreaList;
      List<int> listArea = _getProfileResponseModel!.data!.serviceAreas!
          .map((e) => e.id)
          .whereType<int>()
          .toList();
      addServiceAreas(listArea);
    }
    if (_getProfileResponseModel!.data!.idProofs!.isNotEmpty) {
      setExistingDocuments(_getProfileResponseModel!.data!.idProofs ?? []);
    }
  }

  Future<void> getProfile(BuildContext context) async {
    updateProfile(false);
    isLoading = true;
    errorMessage = null;
    _getProfileResponseModel = null;
    notifyListeners();
    try {
      final response = await authRepo.getProfile();
      if (response.success) {
        _getProfileResponseModel = get_profile.GetProfileResponseModel.fromJson(
          response.data,
        );
        setProfileValues();
      } else {
        errorMessage = response.message;
      }
    } catch (_) {
      errorMessage = "Something went wrong";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> logoutApi() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final refreshToken = await SharedPrefService().getStringValue(
        SharedPrefKey.refreshToken,
      );
      final response = await authRepo.logout(refreshToken!);
      if (response.success) {
        return true;
      } else {
        errorMessage = response.error?.message;
        return false;
      }
    } catch (_) {
      errorMessage = "Something went wrong";
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getServiceArea({bool? showLoader}) async {
    if (showLoader != false) {
      isLoading = true;
    }
    errorMessage = null;
    notifyListeners();

    try {
      final response = await authRepo.serviceArea();
      if (response.success) {
        _serviceAreaModel = ServiceAreaModel.fromJson(response.data);
      }
    } catch (e) {
      print("error--$e");
    } finally {
      if (showLoader != false) {
        isLoading = false;
      }
      notifyListeners();
    }
  }

  Future<void> getServicesCategories() async {
    errorMessage = null;
    _servicesCategoriesModel = null;
    notifyListeners();
    try {
      final response = await authRepo.serviceCategories();

      if (response.success) {
        _servicesCategoriesModel = ServicesCategoriesModel.fromJson(
          response.data,
        );
      } else {
        errorMessage = response.message;
      }
    } catch (_) {
      errorMessage = "Something went wrong";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getExperience() async {
    errorMessage = null;
    _experienceResponseModel = null;
    notifyListeners();
    try {
      final response = await authRepo.experience();

      if (response.success) {
        _experienceResponseModel = ExperienceResponseModel.fromJson(
          response.data,
        );
      } else {
        errorMessage = response.message;
      }
    } catch (_) {
      errorMessage = "Something went wrong";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

typedef LogoutCallback = Future<void> Function();

class AuthSession {
  static LogoutCallback? onUnauthorized;
}

