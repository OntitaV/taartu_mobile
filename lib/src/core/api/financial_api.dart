import 'package:dio/dio.dart';
import 'api_client.dart';

class FinancialApi {
  final ApiClient _apiClient;

  FinancialApi(this._apiClient);

  // Offers Management
  Future<Response> getOffers() async {
    return await _apiClient.dio.get('/business/offers');
  }

  Future<Response> createOffer(Map<String, dynamic> offerData) async {
    return await _apiClient.dio.post('/business/offers', data: offerData);
  }

  Future<Response> updateOffer(int id, Map<String, dynamic> offerData) async {
    return await _apiClient.dio.put('/business/offers/$id', data: offerData);
  }

  Future<Response> deleteOffer(int id) async {
    return await _apiClient.dio.delete('/business/offers/$id');
  }

  // Tax Rates Management
  Future<Response> getTaxRates() async {
    return await _apiClient.dio.get('/business/tax-rates');
  }

  Future<Response> createTaxRate(Map<String, dynamic> taxData) async {
    return await _apiClient.dio.post('/business/tax-rates', data: taxData);
  }

  Future<Response> updateTaxRate(int id, Map<String, dynamic> taxData) async {
    return await _apiClient.dio.put('/business/tax-rates/$id', data: taxData);
  }

  Future<Response> deleteTaxRate(int id) async {
    return await _apiClient.dio.delete('/business/tax-rates/$id');
  }

  // Commission Management
  Future<Response> getCommissionRate() async {
    return await _apiClient.dio.get('/business/platform-fee');
  }

  Future<Response> updateCommissionRate(double percentage) async {
    return await _apiClient.dio.put('/business/platform-fee', data: {
      'platform_fee_percentage': percentage,
    });
  }

  // Employee Rate Management
  Future<Response> getEmployeeRates() async {
    return await _apiClient.dio.get('/business/employee-rates');
  }

  Future<Response> createEmployeeRate(Map<String, dynamic> data) async {
    return await _apiClient.dio.post('/business/employee-rates', data: data);
  }

  Future<Response> updateEmployeeRate(int id, Map<String, dynamic> data) async {
    return await _apiClient.dio.put('/business/employee-rates/$id', data: data);
  }

  Future<Response> deleteEmployeeRate(int id) async {
    return await _apiClient.dio.delete('/business/employee-rates/$id');
  }

  // Price Calculation
  Future<Response> calculateBookingPrice(Map<String, dynamic> bookingData) async {
    return await _apiClient.dio.post('/business/calculate-price', data: bookingData);
  }
} 