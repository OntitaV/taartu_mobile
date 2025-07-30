<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\BusinessController;
use App\Http\Controllers\Api\BookingController;
use App\Http\Controllers\Api\ServiceController;
use App\Http\Controllers\Api\PaymentController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

// Public routes
Route::post('/auth/login', [AuthController::class, 'login']);
Route::post('/auth/register', [AuthController::class, 'register']);
Route::post('/auth/verify-otp', [AuthController::class, 'verifyOtp']);
Route::post('/auth/forgot-password', [AuthController::class, 'forgotPassword']);
Route::post('/auth/reset-password', [AuthController::class, 'resetPassword']);

// Protected routes
Route::middleware('auth:sanctum')->group(function () {
    // User profile
    Route::get('/user/profile', [AuthController::class, 'profile']);
    Route::put('/user/profile', [AuthController::class, 'updateProfile']);
    Route::post('/auth/logout', [AuthController::class, 'logout']);

    // Business management (commission-only model)
    Route::prefix('business')->group(function () {
        Route::post('/initialize', [BusinessController::class, 'initializeBusiness']);
        Route::get('/commission-rate', [BusinessController::class, 'getCommissionRate']);
        Route::put('/commission-rate', [BusinessController::class, 'updateCommissionRate']);
        Route::get('/model', [BusinessController::class, 'getBusinessModel']);
    });

    // Booking management (commission-only model)
    Route::prefix('bookings')->group(function () {
        Route::post('/calculate-price', [BookingController::class, 'calculatePrice']);
        Route::post('/', [BookingController::class, 'createBooking']);
        Route::get('/{bookingId}/summary', [BookingController::class, 'getBookingSummary']);
        Route::get('/business/earnings', [BookingController::class, 'getBusinessEarnings']);
    });

    // Services
    Route::apiResource('services', ServiceController::class);

    // Payments
    Route::prefix('payments')->group(function () {
        Route::post('/process', [PaymentController::class, 'processPayment']);
        Route::get('/{paymentId}/status', [PaymentController::class, 'getPaymentStatus']);
    });

    // Feature flag controlled routes (subscription features disabled)
    if (config('features.enable_subscriptions', false)) {
        // Subscription routes (disabled by default)
        Route::prefix('subscriptions')->group(function () {
            Route::get('/plans', [SubscriptionController::class, 'getPlans']);
            Route::post('/subscribe', [SubscriptionController::class, 'subscribe']);
            Route::post('/cancel', [SubscriptionController::class, 'cancel']);
        });
    }
});

// Health check
Route::get('/health', function () {
    return response()->json([
        'status' => 'healthy',
        'timestamp' => now(),
        'version' => '1.0.0',
        'business_model' => 'commission_only',
    ]);
}); 