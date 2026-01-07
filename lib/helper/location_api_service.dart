import '../services/api/api_client.dart';
import '../services/local_data/shared_pref.dart';
import '../services/local_data/shared_pref_keys.dart';
import '../services/repositories/auth_repository.dart';
import '../services/repositories/auth_repository_impl.dart';

class ApiService {
  static Future<void> sendLocation({
    required double lat,
    required double lng,
  }) async {
    try {
      // IMPORTANT: In background isolate, we need to manually load the token
      // because ApiClient singleton doesn't share state across isolates
      final token = await SharedPrefService().getStringValue(SharedPrefKey.token);
      print("🔑 Token loaded in background: ${token != null ? 'YES' : 'NO'}");

      // Update the ApiClient header with the token
      ApiClient.instance.updateHeader(token: token);

      print("Api calling------Location");
      final AuthRepository authRepo = AuthRepositoryImpl();
      final response = await authRepo.updateLocation(lat, lng);

      if (response.success) {
        print("✅ Location updated successfully");
      } else {
        print("❌ Location update failed: ${response.error?.message}");
      }
    } catch (e) {
      print("❌ Error sending location: $e");
      // Don't show toast in background as it may not work
    }
  }
}
