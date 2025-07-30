class FeatureFlags {
  // Commission-only model - enabled by default
  static const bool enableCommissionOnly = true;
  static const bool enablePlatformFee = true;
  
  // Commission range constraints (5% - 15%)
  static const double minCommissionRate = 5.0;
  static const double maxCommissionRate = 15.0;
  static const double defaultCommissionRate = 10.0;
  
  // Analytics events
  static const bool trackCommissionEvents = true;
  
  // UI/UX features
  static const bool showCommissionTab = true;
  
  // Payment features
  static const bool enableCommissionPayments = true;
  
  // Business model messaging
  static const String businessModelMessage = 'Zero subscription fees—pay only when you earn';
  static const String commissionDescription = 'Taartu takes a percentage of each booking—no monthly fees';
} 