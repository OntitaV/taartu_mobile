<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;
use App\Models\Business;
use App\Services\AnalyticsService;

class BusinessController extends Controller
{
    protected $analyticsService;

    public function __construct(AnalyticsService $analyticsService)
    {
        $this->analyticsService = $analyticsService;
    }

    /**
     * Update business commission rate
     *
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function updateCommissionRate(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'commission_rate' => 'required|numeric|min:10|max:15',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation failed',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            $business = Auth::user()->business;
            
            if (!$business) {
                return response()->json([
                    'success' => false,
                    'message' => 'Business not found'
                ], 404);
            }

            $commissionRate = $request->input('commission_rate');
            
            // Enforce commission-only model constraints
            if ($commissionRate < 10 || $commissionRate > 15) {
                return response()->json([
                    'success' => false,
                    'message' => 'Commission rate must be between 10% and 15%'
                ], 422);
            }

            // Update business commission rate
            $business->update([
                'platform_fee_percentage' => $commissionRate,
                'commission_only_model' => true,
                'subscription_model_enabled' => false,
            ]);

            // Track commission rate confirmation
            $this->analyticsService->track('platform_fee_confirmed', [
                'business_id' => $business->id,
                'commission_rate' => $commissionRate,
                'user_id' => Auth::id(),
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Commission rate updated successfully',
                'data' => [
                    'commission_rate' => $commissionRate,
                    'business_id' => $business->id,
                ]
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to update commission rate',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get business commission rate
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function getCommissionRate()
    {
        try {
            $business = Auth::user()->business;
            
            if (!$business) {
                return response()->json([
                    'success' => false,
                    'message' => 'Business not found'
                ], 404);
            }

            return response()->json([
                'success' => true,
                'data' => [
                    'commission_rate' => $business->platform_fee_percentage ?? 10.00,
                    'commission_only_model' => $business->commission_only_model ?? true,
                    'min_rate' => 10.0,
                    'max_rate' => 15.0,
                    'default_rate' => 10.0,
                ]
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to get commission rate',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get business model information
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function getBusinessModel()
    {
        try {
            $business = Auth::user()->business;
            
            if (!$business) {
                return response()->json([
                    'success' => false,
                    'message' => 'Business not found'
                ], 404);
            }

            return response()->json([
                'success' => true,
                'data' => [
                    'model_type' => 'commission_only',
                    'commission_rate' => $business->platform_fee_percentage ?? 10.00,
                    'commission_only_model' => $business->commission_only_model ?? true,
                    'subscription_model_enabled' => $business->subscription_model_enabled ?? false,
                    'business_model_message' => 'Zero subscription fees—pay only when you earn',
                    'commission_description' => 'Taartu takes a percentage of each booking—no monthly fees',
                    'constraints' => [
                        'min_commission_rate' => 10.0,
                        'max_commission_rate' => 15.0,
                        'default_commission_rate' => 10.0,
                    ]
                ]
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to get business model',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Initialize business with default commission rate (for new businesses)
     *
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function initializeBusiness(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'business_name' => 'required|string|max:255',
            'business_type' => 'required|string|max:100',
            'location' => 'required|string|max:255',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation failed',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            $business = Business::create([
                'user_id' => Auth::id(),
                'name' => $request->input('business_name'),
                'type' => $request->input('business_type'),
                'location' => $request->input('location'),
                'platform_fee_percentage' => 10.00, // Default commission rate
                'commission_only_model' => true,
                'subscription_model_enabled' => false,
                'status' => 'active',
            ]);

            // Track business initialization
            $this->analyticsService->track('business_initialized', [
                'business_id' => $business->id,
                'user_id' => Auth::id(),
                'business_type' => $request->input('business_type'),
                'commission_rate' => 10.00,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Business initialized successfully with commission-only model',
                'data' => [
                    'business_id' => $business->id,
                    'commission_rate' => 10.00,
                    'model_type' => 'commission_only',
                ]
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to initialize business',
                'error' => $e->getMessage()
            ], 500);
        }
    }
} 