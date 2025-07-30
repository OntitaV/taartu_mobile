# Taartu Booking Marketplace - Financial & Subscription Features

## Overview

This document outlines the comprehensive financial and subscription features implemented for the Taartu Booking Marketplace Flutter app. These features enable businesses to manage their financial operations, create promotional offers, configure platform fees, and upgrade to premium subscription tiers.

## 🏗️ Architecture

### Project Structure
```
lib/src/features/
├── financial/
│   ├── models/
│   │   ├── offer.dart
│   │   ├── tax_rate.dart
│   │   └── employee_rate.dart
│   ├── providers/
│   │   └── financial_providers.dart
│   ├── utils/
│   │   └── price_calculator.dart
│   ├── widgets/
│   │   └── price_breakdown_widget.dart
│   ├── offers/
│   │   └── presentation/screens/
│   │       ├── offers_screen.dart
│   │       └── create_offer_screen.dart
│   ├── tax/
│   ├── employees/
│   └── platformFee/
│       └── presentation/screens/
│           └── platform_fee_screen.dart
├── subscriptions/
│   ├── models/
│   │   └── subscription_plan.dart
│   ├── providers/
│   │   └── subscription_providers.dart
│   └── presentation/screens/
│       └── subscription_plans_screen.dart
└── core/api/
    └── financial_api.dart
```

## 💰 Financial Features

### 1. Offers & Coupons Management

#### Features
- **CRUD Operations**: Create, read, update, and delete promotional offers
- **Discount Types**: Percentage-based or flat amount discounts
- **Validity Period**: Set start and end dates for offers
- **Usage Limits**: Configure maximum usage count per offer
- **Real-time Validation**: Automatic validation of offer eligibility

#### Models
```dart
class Offer {
  final int? id;
  final String code;
  final String discountType; // 'percentage' or 'flat'
  final double value;
  final DateTime validFrom;
  final DateTime validTo;
  final int usageLimit;
  final int currentUsage;
  final bool isActive;
}
```

#### Screens
- **OffersScreen**: Main dashboard for managing all offers
- **CreateOfferScreen**: Form for creating/editing offers with preview

#### API Endpoints
- `GET /api/business/offers` - List all offers
- `POST /api/business/offers` - Create new offer
- `PUT /api/business/offers/{id}` - Update offer
- `DELETE /api/business/offers/{id}` - Delete offer

### 2. Tax Rates Management

#### Features
- **Multiple Tax Rates**: Support for different tax rates (VAT, service tax, etc.)
- **Percentage-based**: Configure tax as percentage of service price
- **Active/Inactive**: Toggle tax rates on/off

#### Models
```dart
class TaxRate {
  final int? id;
  final String name;
  final double percentage;
  final bool isActive;
  final String? description;
}
```

#### API Endpoints
- `GET /api/business/tax-rates` - List tax rates
- `POST /api/business/tax-rates` - Create tax rate
- `PUT /api/business/tax-rates/{id}` - Update tax rate
- `DELETE /api/business/tax-rates/{id}` - Delete tax rate

### 3. Employee Compensation

#### Features
- **Commission-based**: Percentage of booking value
- **Flat-rate**: Fixed amount per booking
- **Per-employee**: Individual compensation settings
- **Active/Inactive**: Toggle employee rates

#### Models
```dart
class EmployeeRate {
  final int? id;
  final int employeeId;
  final String employeeName;
  final String type; // 'commission' or 'flat'
  final double value;
  final bool isActive;
}
```

#### API Endpoints
- `GET /api/business/employee-rates` - List employee rates
- `POST /api/business/employee-rates` - Create employee rate
- `PUT /api/business/employee-rates/{id}` - Update employee rate
- `DELETE /api/business/employee-rates/{id}` - Delete employee rate

### 4. Platform Fee Management

#### Features
- **Configurable Percentage**: 5% - 15% range
- **Real-time Updates**: Instant fee calculation updates
- **Visual Slider**: Intuitive fee adjustment interface
- **Fee Examples**: Preview calculations for different booking amounts

#### Screens
- **PlatformFeeScreen**: Interactive fee configuration with live examples

#### API Endpoints
- `GET /api/business/platform-fee` - Get current platform fee
- `PUT /api/business/platform-fee` - Update platform fee

## 🚀 Subscription Features

### 1. Subscription Plans

#### Plan Tiers
- **Starter (Free)**: Basic features for new businesses
- **Growth (Monthly)**: Enhanced features for growing businesses
- **Pro (Yearly)**: Premium features with annual billing discount

#### Features
- **Monthly/Yearly Billing**: Toggle between billing cycles
- **Savings Display**: Show yearly savings for annual plans
- **Feature Comparison**: Detailed feature lists per plan
- **Payment Integration**: Support for multiple payment methods

#### Models
```dart
class SubscriptionPlan {
  final String id;
  final String name;
  final String description;
  final double monthlyPrice;
  final double yearlyPrice;
  final List<String> features;
  final bool isPopular;
  final bool isCurrent;
}
```

#### Payment Methods
- Credit/Debit Cards
- M-Pesa (Kenyan mobile money)
- Airtel Money (Kenyan mobile money)

#### API Endpoints
- `GET /api/business/subscriptions/plans` - List available plans
- `POST /api/business/subscriptions/activate` - Activate subscription
- `GET /api/business/subscriptions/current` - Get current subscription
- `POST /api/business/subscriptions/cancel` - Cancel subscription

## 💳 Price Calculation System

### Price Breakdown Components
1. **Service Price**: Base price of the service
2. **Discount**: Applied offer/coupon reduction
3. **Subtotal**: Price after discount
4. **Tax**: Applicable tax amount
5. **Platform Fee**: Taartu platform fee
6. **Employee Commission**: Employee compensation (business view)
7. **Grand Total**: Final amount to be paid

### Price Calculator Utility
```dart
class PriceCalculator {
  static PriceBreakdown calculateBookingPrice({
    required double servicePrice,
    Offer? offer,
    TaxRate? taxRate,
    EmployeeRate? employeeRate,
    double platformFeePercentage = 10.0,
  });
}
```

### Price Breakdown Widget
- **Visual Breakdown**: Clear line-item display
- **Color Coding**: Different colors for different components
- **Savings Highlight**: Prominent display of discount savings
- **Coupon Application**: Easy coupon code application interface

## 🎨 UI/UX Design

### Design System Compliance
- **Taartu Design System v1.0**: Consistent colors, typography, spacing
- **Inter Font**: Modern, readable typography
- **8px Border Radius**: Consistent rounded corners
- **Spacing Scale**: Systematic spacing using AppTheme constants

### Accessibility Features
- **High Contrast**: Minimum 4.5:1 contrast ratio
- **Touch Targets**: Minimum 44px touch targets
- **Screen Reader Support**: Proper semantic labels
- **Motion Guidelines**: Smooth animations with tap scale effects

### Modern UX Patterns
- **Card-based Layout**: Clean, organized information hierarchy
- **Interactive Elements**: Hover states, loading states, feedback
- **Progressive Disclosure**: Information revealed as needed
- **Error Handling**: Clear error messages and recovery options

## 🔧 State Management

### Riverpod Providers
```dart
// Financial Providers
final offersProvider = StateNotifierProvider<OffersNotifier, AsyncValue<List<Offer>>>
final taxRatesProvider = StateNotifierProvider<TaxRatesNotifier, AsyncValue<List<TaxRate>>>
final employeeRatesProvider = StateNotifierProvider<EmployeeRatesNotifier, AsyncValue<List<EmployeeRate>>>
final platformFeeProvider = StateNotifierProvider<PlatformFeeNotifier, AsyncValue<double>>

// Subscription Providers
final subscriptionPlansProvider = StateNotifierProvider<SubscriptionPlansNotifier, AsyncValue<List<SubscriptionPlan>>>
final currentSubscriptionProvider = StateNotifierProvider<CurrentSubscriptionNotifier, AsyncValue<SubscriptionPlan?>>
```

### API Integration
- **Dio HTTP Client**: Robust HTTP requests with interceptors
- **Laravel Sanctum**: Secure cookie-based authentication
- **Error Handling**: Comprehensive error handling and user feedback
- **Loading States**: Proper loading indicators throughout the app

## 📊 Analytics Integration

### Mixpanel Events
- `offer_created` - When a new offer is created
- `tax_rate_updated` - When tax rates are modified
- `employee_rate_set` - When employee compensation is configured
- `platform_fee_changed` - When platform fee is updated
- `subscription_upgraded` - When user upgrades subscription

## 🧪 Testing Strategy

### Unit Tests
- Price calculation logic
- Model serialization/deserialization
- Provider state management
- Utility functions

### Integration Tests
- API endpoint integration
- State management flows
- Navigation between screens

### E2E Tests
- Complete financial settings flows
- Subscription upgrade process
- Offer creation and application
- Price breakdown accuracy

## 🚀 Getting Started

### Prerequisites
- Flutter 3.x
- Dart 3.x
- Riverpod for state management
- Dio for HTTP requests

### Installation
1. Clone the repository
2. Install dependencies: `flutter pub get`
3. Configure API endpoints in `lib/src/core/api/financial_api.dart`
4. Set up Mixpanel analytics
5. Run the app: `flutter run`

### Configuration
1. **API Base URL**: Update in `lib/src/core/api/api_client.dart`
2. **Analytics**: Configure Mixpanel in `main.dart`
3. **Payment Methods**: Set up payment gateway integrations
4. **Platform Fee Range**: Adjust min/max values in `PlatformFeeScreen`

## 📱 Business Dashboard Integration

The financial features are seamlessly integrated into the business dashboard:

### Quick Actions
- **Offers & Coupons**: Direct access to offer management
- **Platform Fee**: Quick fee configuration
- **Upgrade to Premium**: Subscription plan selection
- **Employee Rates**: Compensation management

### Navigation
All financial features are accessible through the business dashboard, providing a centralized management interface for business owners.

## 🔒 Security Considerations

- **Authentication**: All API calls require valid Laravel Sanctum tokens
- **Authorization**: Business-specific data access controls
- **Input Validation**: Comprehensive form validation
- **Data Encryption**: Sensitive data encrypted in transit and at rest

## 📈 Future Enhancements

### Planned Features
- **Bulk Operations**: Mass offer creation and management
- **Advanced Analytics**: Detailed financial reporting
- **Automated Tax Calculation**: Integration with tax APIs
- **Multi-currency Support**: Support for different currencies
- **Advanced Payment Methods**: Additional payment gateways

### Performance Optimizations
- **Caching**: Implement caching for frequently accessed data
- **Lazy Loading**: Optimize list rendering for large datasets
- **Image Optimization**: Compress and cache offer images
- **Background Sync**: Offline support with background synchronization

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Implement your changes
4. Add tests for new functionality
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📞 Support

For support and questions:
- Email: support@taartu.com
- Documentation: https://docs.taartu.com
- Community: https://community.taartu.com

---

**Built with ❤️ for the Kenyan business community** 