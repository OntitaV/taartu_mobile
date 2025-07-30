import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/financial_api.dart';
import '../../../core/providers/api_providers.dart';
import '../models/offer.dart';
import '../models/tax_rate.dart';
import '../models/employee_rate.dart';

// API Provider
final financialApiProvider = Provider<FinancialApi>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return FinancialApi(apiClient);
});

// Offers Providers
final offersProvider = StateNotifierProvider<OffersNotifier, AsyncValue<List<Offer>>>((ref) {
  final api = ref.watch(financialApiProvider);
  return OffersNotifier(api);
});

class OffersNotifier extends StateNotifier<AsyncValue<List<Offer>>> {
  final FinancialApi _api;

  OffersNotifier(this._api) : super(const AsyncValue.loading()) {
    loadOffers();
  }

  Future<void> loadOffers() async {
    try {
      state = const AsyncValue.loading();
      final response = await _api.getOffers();
      final offers = (response.data['data'] as List)
          .map((json) => Offer.fromJson(json))
          .toList();
      state = AsyncValue.data(offers);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> createOffer(Offer offer) async {
    try {
      await _api.createOffer(offer.toJson());
      await loadOffers();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateOffer(Offer offer) async {
    try {
      await _api.updateOffer(offer.id!, offer.toJson());
      await loadOffers();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteOffer(int id) async {
    try {
      await _api.deleteOffer(id);
      await loadOffers();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

// Tax Rates Providers
final taxRatesProvider = StateNotifierProvider<TaxRatesNotifier, AsyncValue<List<TaxRate>>>((ref) {
  final api = ref.watch(financialApiProvider);
  return TaxRatesNotifier(api);
});

class TaxRatesNotifier extends StateNotifier<AsyncValue<List<TaxRate>>> {
  final FinancialApi _api;

  TaxRatesNotifier(this._api) : super(const AsyncValue.loading()) {
    loadTaxRates();
  }

  Future<void> loadTaxRates() async {
    try {
      state = const AsyncValue.loading();
      final response = await _api.getTaxRates();
      final taxRates = (response.data['data'] as List)
          .map((json) => TaxRate.fromJson(json))
          .toList();
      state = AsyncValue.data(taxRates);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> createTaxRate(TaxRate taxRate) async {
    try {
      await _api.createTaxRate(taxRate.toJson());
      await loadTaxRates();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateTaxRate(TaxRate taxRate) async {
    try {
      await _api.updateTaxRate(taxRate.id!, taxRate.toJson());
      await loadTaxRates();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteTaxRate(int id) async {
    try {
      await _api.deleteTaxRate(id);
      await loadTaxRates();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

// Employee Rates Providers
final employeeRatesProvider = StateNotifierProvider<EmployeeRatesNotifier, AsyncValue<List<EmployeeRate>>>((ref) {
  final api = ref.watch(financialApiProvider);
  return EmployeeRatesNotifier(api);
});

class EmployeeRatesNotifier extends StateNotifier<AsyncValue<List<EmployeeRate>>> {
  final FinancialApi _api;

  EmployeeRatesNotifier(this._api) : super(const AsyncValue.loading()) {
    loadEmployeeRates();
  }

  Future<void> loadEmployeeRates() async {
    try {
      state = const AsyncValue.loading();
      final response = await _api.getEmployeeRates();
      final employeeRates = (response.data['data'] as List)
          .map((json) => EmployeeRate.fromJson(json))
          .toList();
      state = AsyncValue.data(employeeRates);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> createEmployeeRate(Map<String, dynamic> data) async {
    try {
      await _api.createEmployeeRate(data);
      await loadEmployeeRates();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateEmployeeRate(EmployeeRate employeeRate) async {
    try {
      await _api.updateEmployeeRate(employeeRate.id!, employeeRate.toJson());
      await loadEmployeeRates();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteEmployeeRate(int id) async {
    try {
      await _api.deleteEmployeeRate(id);
      await loadEmployeeRates();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

// Platform Fee Provider
final platformFeeProvider = StateNotifierProvider<PlatformFeeNotifier, AsyncValue<double>>((ref) {
  final api = ref.watch(financialApiProvider);
  return PlatformFeeNotifier(api);
});

class PlatformFeeNotifier extends StateNotifier<AsyncValue<double>> {
  final FinancialApi _api;

  PlatformFeeNotifier(this._api) : super(const AsyncValue.loading()) {
    loadPlatformFee();
  }

  Future<void> loadPlatformFee() async {
    try {
      state = const AsyncValue.loading();
      final response = await _api.getCommissionRate();
      final fee = response.data['platform_fee_percentage'].toDouble();
      state = AsyncValue.data(fee);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updatePlatformFee(double feePercentage) async {
    try {
      await _api.updateCommissionRate(feePercentage);
      state = AsyncValue.data(feePercentage);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
} 