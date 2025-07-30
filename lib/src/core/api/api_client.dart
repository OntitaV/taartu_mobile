import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';

class ApiClient {
  static const String baseUrl = 'https://api.taartu.com';
  static const String apiVersion = '/api';
  
  late final Dio _dio;
  late final CookieJar _cookieJar;
  
  static final ApiClient _instance = ApiClient._internal();
  
  factory ApiClient() {
    return _instance;
  }
  
  ApiClient._internal() {
    _initDio();
  }
  
  Future<void> _initDio() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final cookiePath = '${appDocDir.path}/.cookies/';
    _cookieJar = PersistCookieJar(storage: FileStorage(cookiePath));
    
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl + apiVersion,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
      },
    ));
    
    _dio.interceptors.add(CookieManager(_cookieJar));
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => debugPrint(obj.toString()),
    ));
    
    // Add auth interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Add CSRF token if available
        final csrfToken = await _getCsrfToken();
        if (csrfToken != null) {
          options.headers['X-CSRF-TOKEN'] = csrfToken;
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          // Handle unauthorized - clear cookies and redirect to login
          await _clearCookies();
          // You can add navigation logic here
        }
        handler.next(error);
      },
    ));
  }
  
  Future<String?> _getCsrfToken() async {
    try {
      final response = await _dio.get('/sanctum/csrf-cookie');
      final cookies = response.headers.map['set-cookie'];
      if (cookies != null) {
        for (final cookie in cookies) {
          if (cookie.contains('XSRF-TOKEN')) {
            final token = cookie.split(';')[0].split('=')[1];
            return Uri.decodeComponent(token);
          }
        }
      }
    } catch (e) {
      debugPrint('Error getting CSRF token: $e');
    }
    return null;
  }
  
  Future<void> _clearCookies() async {
    await _cookieJar.deleteAll();
  }
  
  // Auth endpoints
  Future<Response> login(String email, String password) async {
    return await _dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
  }
  
  Future<Response> register(String name, String email, String password, String passwordConfirmation) async {
    return await _dio.post('/auth/register', data: {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
    });
  }
  
  Future<Response> sendOtp(String email) async {
    return await _dio.post('/auth/send-otp', data: {
      'email': email,
    });
  }
  
  Future<Response> verifyOtp(String email, String otp) async {
    return await _dio.post('/auth/verify-otp', data: {
      'email': email,
      'otp': otp,
    });
  }
  
  Future<Response> logout() async {
    final response = await _dio.post('/auth/logout');
    await _clearCookies();
    return response;
  }
  
  // Marketplace endpoints
  Future<Response> getSalons({Map<String, dynamic>? filters}) async {
    return await _dio.get('/marketplace/salons', queryParameters: filters);
  }
  
  Future<Response> getSalonDetails(int salonId) async {
    return await _dio.get('/marketplace/salons/$salonId');
  }
  
  Future<Response> getSalonServices(int salonId) async {
    return await _dio.get('/marketplace/salons/$salonId/services');
  }
  
  Future<Response> getSalonStaff(int salonId) async {
    return await _dio.get('/marketplace/salons/$salonId/staff');
  }
  
  // Booking endpoints
  Future<Response> createBooking(Map<String, dynamic> bookingData) async {
    return await _dio.post('/customer/bookings', data: bookingData);
  }
  
  Future<Response> getCustomerBookings() async {
    return await _dio.get('/customer/bookings');
  }
  
  Future<Response> getBusinessBookings() async {
    return await _dio.get('/business/bookings');
  }
  
  Future<Response> updateBooking(int bookingId, Map<String, dynamic> data) async {
    return await _dio.put('/customer/bookings/$bookingId', data: data);
  }
  
  Future<Response> cancelBooking(int bookingId) async {
    return await _dio.delete('/customer/bookings/$bookingId');
  }
  
  // Payment endpoints
  Future<Response> initiatePaystackPayment(Map<String, dynamic> paymentData) async {
    return await _dio.post('/payments/paystack', data: paymentData);
  }
  
  Future<Response> initiateMpesaPayment(Map<String, dynamic> paymentData) async {
    return await _dio.post('/payments/mpesa-initiate', data: paymentData);
  }
  
  Future<Response> verifyPayment(String reference) async {
    return await _dio.get('/payments/verify/$reference');
  }
  
  // Profile endpoints
  Future<Response> getUserProfile() async {
    return await _dio.get('/user/profile');
  }
  
  Future<Response> updateUserProfile(Map<String, dynamic> profileData) async {
    return await _dio.put('/user/profile', data: profileData);
  }
  
  Future<Response> uploadProfileImage(String filePath) async {
    final formData = FormData.fromMap({
      'profile_image': await MultipartFile.fromFile(filePath),
    });
    return await _dio.post('/user/profile/image', data: formData);
  }
  
  // Notification endpoints
  Future<Response> getNotifications() async {
    return await _dio.get('/notifications');
  }
  
  Future<Response> markNotificationAsRead(int notificationId) async {
    return await _dio.put('/notifications/$notificationId/read');
  }
  
  Future<Response> updatePushToken(String token) async {
    return await _dio.post('/notifications/push-token', data: {
      'token': token,
    });
  }
  
  // Utility methods
  Dio get dio => _dio;
  
  Future<bool> isAuthenticated() async {
    try {
      await _dio.get('/user');
      return true;
    } catch (e) {
      return false;
    }
  }
} 