<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\LegalController as ApiLegalController;

// API Routes for Flutter App
Route::prefix('v1')->group(function () {
    // Legal Documentation API
    Route::get('/legal/terms', [ApiLegalController::class, 'terms']);
    Route::get('/legal/privacy', [ApiLegalController::class, 'privacy']);
    
    // Agreement Management API (protected)
    Route::middleware(['auth:sanctum', 'admin'])->group(function () {
        Route::get('/agreements/status', [ApiLegalController::class, 'agreementStatus']);
        Route::post('/agreements/paystack', [ApiLegalController::class, 'updatePaystackAgreement']);
        Route::post('/agreements/intercompany', [ApiLegalController::class, 'updateIntercompanyAgreement']);
    });
}); 