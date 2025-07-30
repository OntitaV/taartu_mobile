<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\LegalController;
use App\Http\Controllers\AdminController;

// Legal Pages Routes
Route::get('/legal/terms', [LegalController::class, 'terms'])->name('legal.terms');
Route::get('/legal/privacy', [LegalController::class, 'privacy'])->name('legal.privacy');

// Admin Routes for Agreement Management
Route::middleware(['auth', 'admin'])->group(function () {
    Route::get('/admin/agreements', [AdminController::class, 'agreements'])->name('admin.agreements');
    Route::post('/admin/agreements/paystack', [AdminController::class, 'updatePaystackAgreement'])->name('admin.agreements.paystack');
    Route::post('/admin/agreements/intercompany', [AdminController::class, 'updateIntercompanyAgreement'])->name('admin.agreements.intercompany');
    Route::get('/admin/agreements/download/{type}', [AdminController::class, 'downloadAgreement'])->name('admin.agreements.download');
});

// API Routes for Flutter App
Route::prefix('api')->group(function () {
    Route::get('/legal/terms', [LegalController::class, 'apiTerms']);
    Route::get('/legal/privacy', [LegalController::class, 'apiPrivacy']);
}); 