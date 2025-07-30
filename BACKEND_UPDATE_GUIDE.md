# Laravel Backend Update Guide

This guide outlines the steps to update the Taartu Laravel API from version 8.x to 11.x.

## 🚀 Overview

Laravel 11.x brings significant improvements in performance, security, and developer experience. This update includes:

- **Performance**: Up to 30% faster response times
- **Security**: Latest security patches and improvements
- **PHP 8.2+**: Modern PHP features and optimizations
- **Laravel Sanctum 4.x**: Enhanced authentication
- **API Resources**: Improved data serialization
- **Rate Limiting**: Better API protection
- **Caching**: Redis integration for better performance

## 📋 Prerequisites

- PHP 8.2 or higher
- Composer 2.0 or higher
- MySQL 8.0 or higher / PostgreSQL 13 or higher
- Redis (for caching and sessions)

## 🔄 Update Process

### 1. Backup Your Application

```bash
# Create a backup of your current application
cp -r /path/to/your/app /path/to/backup/app-$(date +%Y%m%d)

# Backup your database
mysqldump -u username -p database_name > backup_$(date +%Y%m%d).sql
```

### 2. Update PHP Version

Ensure you're running PHP 8.2 or higher:

```bash
# Check current PHP version
php -v

# Update PHP (Ubuntu/Debian)
sudo apt update
sudo apt install php8.2 php8.2-fpm php8.2-mysql php8.2-redis php8.2-curl php8.2-mbstring php8.2-xml php8.2-zip

# Update PHP (CentOS/RHEL)
sudo yum install php82 php82-php-fpm php82-php-mysqlnd php82-php-redis php82-php-curl php82-php-mbstring php82-php-xml php82-php-zip
```

### 3. Update Composer

```bash
# Update Composer to latest version
composer self-update
```

### 4. Update Laravel Framework

```bash
# Navigate to your Laravel project
cd /path/to/your/laravel/project

# Update Laravel to version 11
composer require laravel/framework:^11.0

# Update other Laravel packages
composer require laravel/sanctum:^4.0
composer require laravel/telescope:^5.0
composer require laravel/horizon:^6.0
```

### 5. Update Configuration Files

#### Update `config/app.php`:

```php
<?php

return [
    'name' => env('APP_NAME', 'Taartu API'),
    'env' => env('APP_ENV', 'production'),
    'debug' => (bool) env('APP_DEBUG', false),
    'url' => env('APP_URL', 'https://api.taartu.com'),
    'timezone' => 'UTC',
    'locale' => 'en',
    'fallback_locale' => 'en',
    'faker_locale' => 'en_US',
    'key' => env('APP_KEY'),
    'cipher' => 'AES-256-CBC',
    
    // New in Laravel 11
    'maintenance' => [
        'driver' => env('APP_MAINTENANCE_DRIVER', 'file'),
        'store' => env('APP_MAINTENANCE_STORE', 'database'),
    ],
    
    'providers' => [
        // Laravel Framework Service Providers...
        Illuminate\Auth\AuthServiceProvider::class,
        Illuminate\Broadcasting\BroadcastServiceProvider::class,
        Illuminate\Bus\BusServiceProvider::class,
        Illuminate\Cache\CacheServiceProvider::class,
        Illuminate\Foundation\Providers\ConsoleSupportServiceProvider::class,
        Illuminate\Cookie\CookieServiceProvider::class,
        Illuminate\Database\DatabaseServiceProvider::class,
        Illuminate\Encryption\EncryptionServiceProvider::class,
        Illuminate\Filesystem\FilesystemServiceProvider::class,
        Illuminate\Foundation\Providers\FoundationServiceProvider::class,
        Illuminate\Hashing\HashServiceProvider::class,
        Illuminate\Mail\MailServiceProvider::class,
        Illuminate\Notifications\NotificationServiceProvider::class,
        Illuminate\Pagination\PaginationServiceProvider::class,
        Illuminate\Pipeline\PipelineServiceProvider::class,
        Illuminate\Queue\QueueServiceProvider::class,
        Illuminate\Redis\RedisServiceProvider::class,
        Illuminate\Auth\Passwords\PasswordResetServiceProvider::class,
        Illuminate\Session\SessionServiceProvider::class,
        Illuminate\Translation\TranslationServiceProvider::class,
        Illuminate\Validation\ValidationServiceProvider::class,
        Illuminate\View\ViewServiceProvider::class,
        
        // Application Service Providers...
        App\Providers\AppServiceProvider::class,
        App\Providers\AuthServiceProvider::class,
        App\Providers\EventServiceProvider::class,
        App\Providers\RouteServiceProvider::class,
        App\Providers\SanctumServiceProvider::class,
    ],
];
```

#### Update `config/sanctum.php`:

```php
<?php

return [
    'stateful' => explode(',', env('SANCTUM_STATEFUL_DOMAINS', sprintf(
        '%s%s',
        'localhost,localhost:3000,127.0.0.1,127.0.0.1:8000,::1',
        env('APP_URL') ? ','.parse_url(env('APP_URL'), PHP_URL_HOST) : ''
    ))),
    
    'guard' => ['web'],
    
    'expiration' => null,
    
    'middleware' => [
        'verify_csrf_token' => App\Http\Middleware\VerifyCsrfToken::class,
        'encrypt_cookies' => App\Http\Middleware\EncryptCookies::class,
    ],
    
    // New in Sanctum 4.x
    'prefix' => 'sanctum',
];
```

### 6. Update Database Migrations

Create new migrations for any breaking changes:

```bash
# Create migration for new features
php artisan make:migration add_new_features_to_users_table

# Run migrations
php artisan migrate
```

### 7. Update API Routes

Update `routes/api.php` to use new Laravel 11 features:

```php
<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\MarketplaceController;
use App\Http\Controllers\Api\BookingController;
use App\Http\Controllers\Api\PaymentController;
use App\Http\Controllers\Api\ProfileController;
use App\Http\Controllers\Api\NotificationController;

// Public routes
Route::prefix('auth')->group(function () {
    Route::post('login', [AuthController::class, 'login']);
    Route::post('register', [AuthController::class, 'register']);
    Route::post('send-otp', [AuthController::class, 'sendOtp']);
    Route::post('verify-otp', [AuthController::class, 'verifyOtp']);
});

Route::prefix('marketplace')->group(function () {
    Route::get('salons', [MarketplaceController::class, 'index']);
    Route::get('salons/{salon}', [MarketplaceController::class, 'show']);
    Route::get('salons/{salon}/services', [MarketplaceController::class, 'services']);
    Route::get('salons/{salon}/staff', [MarketplaceController::class, 'staff']);
});

// Protected routes
Route::middleware('auth:sanctum')->group(function () {
    Route::post('auth/logout', [AuthController::class, 'logout']);
    
    Route::prefix('customer')->group(function () {
        Route::apiResource('bookings', BookingController::class);
    });
    
    Route::prefix('business')->group(function () {
        Route::get('bookings', [BookingController::class, 'businessBookings']);
    });
    
    Route::prefix('payments')->group(function () {
        Route::post('paystack', [PaymentController::class, 'paystack']);
        Route::post('mpesa-initiate', [PaymentController::class, 'mpesaInitiate']);
        Route::get('verify/{reference}', [PaymentController::class, 'verify']);
    });
    
    Route::prefix('user')->group(function () {
        Route::get('profile', [ProfileController::class, 'show']);
        Route::put('profile', [ProfileController::class, 'update']);
        Route::post('profile/image', [ProfileController::class, 'uploadImage']);
    });
    
    Route::prefix('notifications')->group(function () {
        Route::get('/', [NotificationController::class, 'index']);
        Route::put('{notification}/read', [NotificationController::class, 'markAsRead']);
        Route::post('push-token', [NotificationController::class, 'updatePushToken']);
    });
});
```

### 8. Update Controllers

Example of updated controller with Laravel 11 features:

```php
<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\SalonResource;
use App\Models\Salon;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class MarketplaceController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $salons = Salon::query()
            ->when($request->category, function ($query, $category) {
                return $query->whereHas('services', function ($q) use ($category) {
                    $q->where('name', 'like', "%{$category}%");
                });
            })
            ->when($request->location, function ($query, $location) {
                return $query->where('location', 'like', "%{$location}%");
            })
            ->with(['services', 'reviews'])
            ->paginate(15);
        
        return response()->json([
            'data' => SalonResource::collection($salons),
            'meta' => [
                'current_page' => $salons->currentPage(),
                'last_page' => $salons->lastPage(),
                'per_page' => $salons->perPage(),
                'total' => $salons->total(),
            ],
        ]);
    }
    
    public function show(Salon $salon): JsonResponse
    {
        $salon->load(['services', 'staff', 'reviews.user']);
        
        return response()->json([
            'data' => new SalonResource($salon),
        ]);
    }
}
```

### 9. Update Models

Example of updated model with Laravel 11 features:

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;

class Salon extends Model
{
    use HasFactory;
    
    protected $fillable = [
        'name',
        'description',
        'address',
        'location',
        'phone',
        'email',
        'website',
        'rating',
        'price_range',
        'is_active',
    ];
    
    protected $casts = [
        'rating' => 'float',
        'is_active' => 'boolean',
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];
    
    public function services(): BelongsToMany
    {
        return $this->belongsToMany(Service::class);
    }
    
    public function staff(): HasMany
    {
        return $this->hasMany(Staff::class);
    }
    
    public function reviews(): HasMany
    {
        return $this->hasMany(Review::class);
    }
    
    public function bookings(): HasMany
    {
        return $this->hasMany(Booking::class);
    }
}
```

### 10. Update Environment Variables

Update your `.env` file:

```env
APP_NAME="Taartu API"
APP_ENV=production
APP_KEY=your-app-key
APP_DEBUG=false
APP_URL=https://api.taartu.com

LOG_CHANNEL=stack
LOG_DEPRECATIONS_CHANNEL=null
LOG_LEVEL=debug

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=taartu_api
DB_USERNAME=your_username
DB_PASSWORD=your_password

BROADCAST_DRIVER=log
CACHE_DRIVER=redis
FILESYSTEM_DISK=local
QUEUE_CONNECTION=redis
SESSION_DRIVER=redis
SESSION_LIFETIME=120

REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379

MAIL_MAILER=smtp
MAIL_HOST=mailpit
MAIL_PORT=1025
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
MAIL_FROM_ADDRESS="hello@taartu.com"
MAIL_FROM_NAME="${APP_NAME}"

AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_DEFAULT_REGION=us-east-1
AWS_BUCKET=
AWS_USE_PATH_STYLE_ENDPOINT=false

PUSHER_APP_ID=
PUSHER_APP_KEY=
PUSHER_APP_SECRET=
PUSHER_HOST=
PUSHER_PORT=443
PUSHER_SCHEME=https
PUSHER_APP_CLUSTER=mt1

VITE_APP_NAME="${APP_NAME}"
VITE_PUSHER_APP_KEY="${PUSHER_APP_KEY}"
VITE_PUSHER_HOST="${PUSHER_HOST}"
VITE_PUSHER_PORT="${PUSHER_PORT}"
VITE_PUSHER_SCHEME="${PUSHER_SCHEME}"
VITE_PUSHER_APP_CLUSTER="${PUSHER_APP_CLUSTER}"

# Payment Gateway Keys
PAYSTACK_SECRET_KEY=your_paystack_secret_key
PAYSTACK_PUBLIC_KEY=your_paystack_public_key
MPESA_CONSUMER_KEY=your_mpesa_consumer_key
MPESA_CONSUMER_SECRET=your_mpesa_consumer_secret
MPESA_PASSKEY=your_mpesa_passkey
MPESA_ENVIRONMENT=sandbox

# SMS Gateway
SMS_API_KEY=your_sms_api_key
SMS_SENDER_ID=Taartu

# Push Notifications
FIREBASE_CREDENTIALS=path/to/firebase-credentials.json
```

### 11. Update Dependencies

Update `composer.json`:

```json
{
    "name": "taartu/api",
    "type": "project",
    "description": "Taartu Booking Marketplace API",
    "keywords": ["laravel", "api", "booking", "marketplace"],
    "license": "MIT",
    "require": {
        "php": "^8.2",
        "laravel/framework": "^11.0",
        "laravel/sanctum": "^4.0",
        "laravel/telescope": "^5.0",
        "laravel/horizon": "^6.0",
        "guzzlehttp/guzzle": "^7.8",
        "predis/predis": "^2.2",
        "spatie/laravel-permission": "^6.0",
        "spatie/laravel-backup": "^8.0",
        "barryvdh/laravel-cors": "^4.0"
    },
    "require-dev": {
        "fakerphp/faker": "^1.23",
        "laravel/pint": "^1.13",
        "laravel/sail": "^1.26",
        "mockery/mockery": "^1.6",
        "nunomaduro/collision": "^8.0",
        "phpunit/phpunit": "^10.5",
        "spatie/laravel-ignition": "^2.4"
    },
    "autoload": {
        "psr-4": {
            "App\\": "app/",
            "Database\\Factories\\": "database/factories/",
            "Database\\Seeders\\": "database/seeders/"
        }
    },
    "autoload-dev": {
        "psr-4": {
            "Tests\\": "tests/"
        }
    },
    "scripts": {
        "post-autoload-dump": [
            "Illuminate\\Foundation\\ComposerScripts::postAutoloadDump",
            "@php artisan package:discover --ansi"
        ],
        "post-update-cmd": [
            "@php artisan vendor:publish --tag=laravel-assets --ansi --force"
        ],
        "post-root-package-install": [
            "@php -r \"file_exists('.env') || copy('.env.example', '.env');\""
        ],
        "post-create-project-cmd": [
            "@php artisan key:generate --ansi"
        ]
    },
    "extra": {
        "laravel": {
            "dont-discover": []
        }
    },
    "config": {
        "optimize-autoloader": true,
        "preferred-install": "dist",
        "sort-packages": true,
        "allow-plugins": {
            "pestphp/pest-plugin": true,
            "php-http/discovery": true
        }
    },
    "minimum-stability": "stable",
    "prefer-stable": true
}
```

### 12. Performance Optimizations

#### Enable Redis Caching:

```bash
# Install Redis
sudo apt install redis-server  # Ubuntu/Debian
sudo yum install redis         # CentOS/RHEL

# Start Redis
sudo systemctl start redis
sudo systemctl enable redis
```

#### Configure Queue Workers:

```bash
# Start Horizon
php artisan horizon

# Or use regular queue workers
php artisan queue:work --queue=high,default,low
```

#### Optimize Application:

```bash
# Cache configuration
php artisan config:cache

# Cache routes
php artisan route:cache

# Cache views
php artisan view:cache

# Optimize autoloader
composer install --optimize-autoloader --no-dev
```

### 13. Security Updates

#### Update CORS Configuration:

```php
// config/cors.php
return [
    'paths' => ['api/*', 'sanctum/csrf-cookie'],
    'allowed_methods' => ['*'],
    'allowed_origins' => ['https://taartu.com', 'https://app.taartu.com'],
    'allowed_origins_patterns' => [],
    'allowed_headers' => ['*'],
    'exposed_headers' => [],
    'max_age' => 0,
    'supports_credentials' => true,
];
```

#### Rate Limiting:

```php
// app/Http/Kernel.php
protected $middlewareGroups = [
    'api' => [
        \Laravel\Sanctum\Http\Middleware\EnsureFrontendRequestsAreStateful::class,
        \Illuminate\Routing\Middleware\ThrottleRequests::class.':api',
        \Illuminate\Routing\Middleware\SubstituteBindings::class,
    ],
];

// config/sanctum.php
'rate_limit' => [
    'requests' => 60,
    'decay_minutes' => 1,
],
```

### 14. Testing

```bash
# Run tests
php artisan test

# Run tests with coverage
php artisan test --coverage

# Run specific test suite
php artisan test --testsuite=Feature
```

### 15. Deployment

#### Using Docker:

```dockerfile
FROM php:8.2-fpm

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www

# Copy application
COPY . .

# Install dependencies
RUN composer install --optimize-autoloader --no-dev

# Set permissions
RUN chown -R www-data:www-data /var/www

# Expose port
EXPOSE 9000

CMD ["php-fpm"]
```

#### Using DigitalOcean App Platform:

1. Connect your GitHub repository
2. Configure build settings:
   - Build Command: `composer install --optimize-autoloader --no-dev && php artisan config:cache && php artisan route:cache && php artisan view:cache`
   - Run Command: `php artisan serve --host=0.0.0.0 --port=$PORT`
3. Set environment variables
4. Deploy

## 🔍 Monitoring

### Set up Laravel Telescope:

```bash
# Install Telescope
composer require laravel/telescope --dev

# Publish configuration
php artisan telescope:install

# Run migrations
php artisan migrate
```

### Set up Laravel Horizon:

```bash
# Install Horizon
composer require laravel/horizon

# Publish configuration
php artisan horizon:install

# Start Horizon
php artisan horizon
```

## 🚨 Breaking Changes

### Notable Changes in Laravel 11:

1. **PHP 8.2+ Required**: Minimum PHP version is now 8.2
2. **New Maintenance Mode**: Improved maintenance mode with database storage
3. **Enhanced Rate Limiting**: Better API rate limiting with Sanctum
4. **Improved Caching**: Better Redis integration
5. **New Validation Rules**: Additional validation rules and improvements
6. **Enhanced Security**: Better CSRF protection and security features

## 📞 Support

If you encounter any issues during the update process:

1. Check the [Laravel 11.x upgrade guide](https://laravel.com/docs/11.x/upgrade)
2. Review the [Laravel Sanctum 4.x documentation](https://laravel.com/docs/11.x/sanctum)
3. Contact the development team at dev@taartu.com

## ✅ Post-Update Checklist

- [ ] All tests passing
- [ ] API endpoints responding correctly
- [ ] Authentication working
- [ ] Database migrations completed
- [ ] Cache cleared and rebuilt
- [ ] Queue workers running
- [ ] Monitoring tools configured
- [ ] Performance benchmarks met
- [ ] Security scan completed
- [ ] Backup strategy verified

---

**Note**: This update significantly improves performance and security. Make sure to test thoroughly in a staging environment before deploying to production. 