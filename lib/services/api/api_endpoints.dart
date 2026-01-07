class ApiEndPoints {
  static final baseUrl = "https://staging.servicemen.in/api/v1/";

  static const requestOtp = 'technician/auth/request-otp';
  static const verifyOtp = 'technician/auth/verify-otp';
  static const logout = 'auth/logout';
  static const createProfile = 'technician/profile/create';
  static const dashboard = 'customer/dashboard';
  static const serviceArea = 'service-areas';
  static const serviceTypes = 'service-types';
  static const technicianExperience = 'config/technician-experience';
  static const uploadPhoto = 'technician/profile/upload-photo';
  static const getProfile = 'technician/profile';
  static const updateProfile = 'technician/profile/update';
  static const deleteProfilePhoto = 'technician/profile/delete-photo';
  static const getIdProofs = 'technician/id-proofs';
  static const uploadIdProofs = 'technician/id-proofs/upload';
  static const deleteIdProofs = 'technician/id-proofs/delete';


  static const updateOnlineStatus = 'technician/status/update';
  static const locationUpdate = 'technician/status/update';


}
