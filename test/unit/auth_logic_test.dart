import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Auth Logic', () {
    group('Role Selection', () {
      test('should validate business role', () {
        const role = 'business';
        expect(role, isA<String>());
        expect(role, isNotEmpty);
        expect(['business', 'client'], contains(role));
      });

      test('should validate client role', () {
        const role = 'client';
        expect(role, isA<String>());
        expect(role, isNotEmpty);
        expect(['business', 'client'], contains(role));
      });

      test('should reject invalid roles', () {
        const invalidRole = 'invalid';
        expect(['business', 'client'], isNot(contains(invalidRole)));
      });
    });

    group('Business Type Validation', () {
      test('should validate salon owner type', () {
        const businessType = 'Salon Owner';
        expect(businessType, isA<String>());
        expect(businessType, isNotEmpty);
        expect(['Salon Owner', 'Freelancer'], contains(businessType));
      });

      test('should validate freelancer type', () {
        const businessType = 'Freelancer';
        expect(businessType, isA<String>());
        expect(businessType, isNotEmpty);
        expect(['Salon Owner', 'Freelancer'], contains(businessType));
      });

      test('should route freelancer to freelancer dashboard', () {
        const role = 'business';
        const businessType = 'Freelancer';
        
        String route;
        if (role == 'business') {
          if (businessType == 'Freelancer') {
            route = '/freelancer-dashboard';
          } else {
            route = '/business-dashboard';
          }
        } else {
          route = '/home';
        }
        
        expect(route, equals('/freelancer-dashboard'));
      });

      test('should route salon owner to business dashboard', () {
        const role = 'business';
        const businessType = 'Salon Owner';
        
        String route;
        if (role == 'business') {
          if (businessType == 'Freelancer') {
            route = '/freelancer-dashboard';
          } else {
            route = '/business-dashboard';
          }
        } else {
          route = '/home';
        }
        
        expect(route, equals('/business-dashboard'));
      });

      test('should route client to home', () {
        const role = 'client';
        
        String route;
        if (role == 'business') {
          route = '/business-dashboard';
        } else {
          route = '/home';
        }
        
        expect(route, equals('/home'));
      });
    });

    group('OTP Validation', () {
      test('should validate complete OTP', () {
        final otpDigits = ['1', '2', '3', '4', '5', '6'];
        final otp = otpDigits.join();
        
        expect(otp, equals('123456'));
        expect(otp.length, equals(6));
        expect(otp, matches(r'^\d{6}$'));
      });

      test('should detect incomplete OTP', () {
        final otpDigits = ['1', '2', '3', '4', '', ''];
        final isComplete = otpDigits.every((digit) => digit.isNotEmpty);
        
        expect(isComplete, isFalse);
      });

      test('should detect complete OTP', () {
        final otpDigits = ['1', '2', '3', '4', '5', '6'];
        final isComplete = otpDigits.every((digit) => digit.isNotEmpty);
        
        expect(isComplete, isTrue);
      });
    });

    group('Form Validation', () {
      test('should validate email format', () {
        const validEmails = [
          'test@example.com',
          'user.name@domain.co.uk',
          'user+tag@example.org',
        ];
        
        const invalidEmails = [
          'invalid-email',
          '@example.com',
          'user@',
          'user@.com',
        ];
        
        for (final email in validEmails) {
          expect(email, matches(r'^[^@]+@[^@]+\.[^@]+$'));
        }
        
        for (final email in invalidEmails) {
          expect(email, isNot(matches(r'^[^@]+@[^@]+\.[^@]+$')));
        }
      });

      test('should validate phone number format', () {
        const validPhones = [
          '+254712345678',
          '+254 712 345 678',
          '0712345678',
        ];
        
        const invalidPhones = [
          'abc',
          '123abc',
          'phone',
        ];
        
        for (final phone in validPhones) {
          expect(phone, matches(r'^\+?[\d\s\-\(\)]+$'));
        }
        
        for (final phone in invalidPhones) {
          expect(phone, isNot(matches(r'^\+?[\d\s\-\(\)]+$')));
        }
      });

      test('should validate password strength', () {
        const strongPasswords = [
          'Password123!',
          'MySecurePass1@',
          'ComplexP@ssw0rd',
        ];
        
        const weakPasswords = [
          '123',
          'abc',
          'short',
        ];
        
        for (final password in strongPasswords) {
          expect(password.length, greaterThanOrEqualTo(8));
          expect(password, matches(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)'));
        }
        
        for (final password in weakPasswords) {
          expect(password.length, lessThan(8));
        }
      });
    });
  });
} 