# 📊 Monitoring & Analytics Setup

## 🎯 **Overview**

Comprehensive monitoring setup for Taartu app covering crash reporting, APM, analytics, and alerting.

---

## 🚨 **Crash Reporting (Sentry)**

### **Setup Configuration**
```yaml
# pubspec.yaml
dependencies:
  sentry_flutter: ^7.15.0

# lib/main.dart
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn = 'https://your-sentry-dsn@your-instance.ingest.sentry.io/project-id';
      options.tracesSampleRate = 1.0;
      options.enableAutoSessionTracking = true;
      options.attachStacktrace = true;
    },
    appRunner: () => runApp(MyApp()),
  );
}
```

### **Error Tracking**
- **Unhandled Exceptions**: Automatic capture
- **Custom Events**: User actions, business logic
- **Performance Monitoring**: App startup, navigation
- **Release Tracking**: Version-based error grouping

### **Alert Configuration**
- **Critical**: App crashes, payment failures
- **High**: API errors, authentication issues
- **Medium**: Performance degradation
- **Low**: UI glitches, minor bugs

---

## 📈 **Application Performance Monitoring (APM)**

### **Flutter Performance**
```dart
// Performance monitoring
Sentry.addBreadcrumb(
  Breadcrumb(
    message: 'User completed booking',
    category: 'user_action',
    data: {'booking_id': bookingId},
  ),
);

// Custom performance spans
final transaction = Sentry.startTransaction(
  'booking_flow',
  'user_interaction',
);
```

### **Laravel Performance**
```php
// Laravel Telescope (for development)
composer require laravel/telescope --dev

// Production monitoring
// New Relic or DataDog integration
```

### **Key Metrics**
- **App Startup**: < 3 seconds
- **Navigation**: < 500ms per screen
- **API Response**: < 150ms p95
- **Payment Processing**: < 2 seconds
- **Image Loading**: < 1 second

---

## 📊 **Analytics (Mixpanel)**

### **Event Tracking**
```dart
// User registration
Mixpanel.track('signup_success', {
  'role': 'business', // or 'client'
  'method': 'email',
  'source': 'welcome_screen',
});

// Booking completion
Mixpanel.track('booking_success', {
  'booking_id': bookingId,
  'service_type': serviceType,
  'amount': amount,
  'payment_method': 'paystack',
});

// Business dashboard usage
Mixpanel.track('business_dashboard_view', {
  'business_id': businessId,
  'section': 'overview', // or 'bookings', 'analytics'
});
```

### **User Properties**
```dart
// Set user properties
Mixpanel.setPeople({
  'User Type': 'business', // or 'client'
  'Registration Date': DateTime.now().toIso8601String(),
  'Location': 'Nairobi, Kenya',
  'Device Type': 'iOS', // or 'Android', 'Web'
});
```

### **Funnel Tracking**
1. **App Install** → **Welcome Screen**
2. **Role Selection** → **Registration**
3. **Registration** → **Onboarding**
4. **Browse Services** → **Service Selection**
5. **Service Selection** → **Booking**
6. **Booking** → **Payment**
7. **Payment** → **Confirmation**

---

## 🔍 **Business Intelligence**

### **Key Performance Indicators (KPIs)**

#### **User Metrics**
- **Daily Active Users (DAU)**: Target 500+ by month 3
- **Monthly Active Users (MAU)**: Target 2,000+ by month 3
- **User Retention**: 7-day > 40%, 30-day > 20%
- **Session Duration**: Average > 5 minutes

#### **Business Metrics**
- **Business Registration**: 50+ businesses by month 2
- **Client Registration**: 500+ clients by month 2
- **Booking Conversion**: > 15% browse-to-book
- **Payment Success Rate**: > 95%

#### **Revenue Metrics**
- **Commission Revenue**: Track per booking
- **Average Booking Value**: Target $25+
- **Monthly Recurring Revenue**: Track growth
- **Customer Lifetime Value**: Calculate per user type

### **Dashboard Configuration**
```yaml
# Grafana Dashboard
panels:
  - title: "User Growth"
    type: "line"
    metrics: ["daily_active_users", "monthly_active_users"]
  
  - title: "Booking Funnel"
    type: "funnel"
    steps: ["browse", "select", "book", "pay", "confirm"]
  
  - title: "Revenue Tracking"
    type: "bar"
    metrics: ["daily_revenue", "commission_earned"]
  
  - title: "Performance"
    type: "line"
    metrics: ["api_response_time", "app_crash_rate"]
```

---

## 🚨 **Alerting & Notifications**

### **Critical Alerts**
```yaml
alerts:
  - name: "App Crash Rate > 1%"
    condition: "crash_rate > 0.01"
    action: "slack #alerts, email team"
    
  - name: "Payment Failure > 5%"
    condition: "payment_failure_rate > 0.05"
    action: "slack #payments, email finance"
    
  - name: "API Response Time > 500ms"
    condition: "api_p95_response_time > 500"
    action: "slack #devops, email tech"
```

### **Business Alerts**
```yaml
alerts:
  - name: "No New Bookings (24h)"
    condition: "bookings_last_24h == 0"
    action: "slack #business, email product"
    
  - name: "Low User Registration"
    condition: "new_users_today < 10"
    action: "slack #growth, email marketing"
```

### **Performance Alerts**
```yaml
alerts:
  - name: "High Memory Usage"
    condition: "memory_usage > 80%"
    action: "slack #devops"
    
  - name: "Database Connection Issues"
    condition: "db_connection_errors > 10"
    action: "slack #devops, email tech"
```

---

## 📱 **Real-time Monitoring**

### **Live Dashboard**
- **Active Users**: Real-time user count
- **Current Bookings**: Live booking activity
- **Revenue**: Real-time commission tracking
- **Errors**: Live error feed
- **Performance**: Real-time metrics

### **Webhook Integrations**
```yaml
webhooks:
  - name: "Slack Notifications"
    url: "https://hooks.slack.com/services/..."
    events: ["critical_errors", "payment_failures"]
    
  - name: "Email Alerts"
    url: "https://api.sendgrid.com/v3/mail/send"
    events: ["business_alerts", "performance_issues"]
```

---

## 🔧 **Setup Instructions**

### **1. Sentry Setup**
```bash
# Install Sentry CLI
npm install -g @sentry/cli

# Configure project
sentry-cli init

# Add to CI/CD
sentry-cli releases new $VERSION
sentry-cli releases uploads $VERSION build/
```

### **2. Mixpanel Setup**
```bash
# Add to pubspec.yaml
flutter pub add mixpanel_flutter

# Initialize in main.dart
Mixpanel.init('YOUR_MIXPANEL_TOKEN');
```

### **3. Grafana Setup**
```bash
# Install Grafana
docker run -d -p 3000:3000 grafana/grafana

# Configure data sources
# Add Prometheus, MySQL, etc.
```

### **4. Alert Configuration**
```bash
# Set up Slack webhooks
# Configure email notifications
# Set up PagerDuty for critical alerts
```

---

## 📊 **Reporting Schedule**

### **Daily Reports**
- **User Activity**: DAU, new registrations
- **Business Metrics**: Bookings, revenue
- **Technical Health**: Error rates, performance

### **Weekly Reports**
- **Growth Metrics**: User acquisition, retention
- **Business Performance**: Revenue trends, booking patterns
- **Technical Performance**: App stability, API health

### **Monthly Reports**
- **Strategic Review**: Overall business health
- **Feature Usage**: Most/least used features
- **User Feedback**: Sentiment analysis
- **Competitive Analysis**: Market positioning

---

## 🎯 **Success Metrics**

### **Technical Success**
- **Uptime**: > 99.9%
- **Error Rate**: < 1%
- **Performance**: < 3s load times
- **Security**: Zero data breaches

### **Business Success**
- **User Growth**: 20% month-over-month
- **Revenue Growth**: 30% month-over-month
- **User Satisfaction**: > 4.5/5.0
- **Market Penetration**: 5% of target market 