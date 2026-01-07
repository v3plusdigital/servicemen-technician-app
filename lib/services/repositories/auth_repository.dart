import 'dart:io';

import '../../models/create_profile_model.dart';
import '../api/api_client.dart';
import '../api/api_response.dart';

abstract class AuthRepository {
  Future<ApiResponse> requestOtp({required String phoneNumber});

  Future<ApiResponse> verifyOtp({
    required String phoneNumber,
    required String otp,
  });

  Future<ApiResponse> createProfile({
    required ProfileCreateRequest profileRequest,
  });

  Future<ApiResponse> updateProfile({
    required ProfileCreateRequest profileRequest,
  });

  Future<ApiResponse> uploadProfilePhoto({required File profileFile});

  Future<ApiResponse> uploadDocuments({required List<File> documents});

  Future<ApiResponse> deleteDocument(int id);

  Future<ApiResponse> deleteProfilePhoto();

  Future<ApiResponse> getProfile();

  Future<ApiResponse> serviceArea();

  Future<ApiResponse> serviceCategories();

  Future<ApiResponse> experience();

  Future<ApiResponse> logout(String token);

  Future<ApiResponse> updateOnlineStatus(String isOnline);

  Future<ApiResponse> updateLocation(double latitude, double longitude);
}
