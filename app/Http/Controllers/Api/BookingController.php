<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;
use App\Models\Booking;
use App\Models\Business;
use App\Models\Service;
use App\Services\PriceCalculationService;
use App\Services\AnalyticsService;

class BookingController extends Controller
{
    protected $priceCalculationService;
    protected $analyticsService;

    public function __construct(PriceCalculationService $priceCalculationService, AnalyticsService $analyticsService)
    {
        $this->priceCalculationService = $priceCalculationService;
        $this->analyticsService = $analyticsService;
    }

    /**
     * Calculate booking price with commission-only model
     *
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function calculatePrice(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'service_id' => 'required|exists:services,id',
            'business_id' => 'required|exists:businesses,id',
            'quantity' => 'integer|min:1',
            'offer_code' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation failed',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            $service = Service::findOrFail($request->input('service_id'));
            $business = Business::findOrFail($request->input('business_id'));
            
            // Ensure business is using commission-only model
            if (!$business->commission_only_model) {
                return response()->json([
                    'success' => false,
                    'message' => 'Business must use commission-only model'
                ], 422);
            }

            $quantity = $request->input('quantity', 1);
            $offerCode = $request->input('offer_code');

            // Calculate price breakdown with commission-only model
            $priceBreakdown = $this->priceCalculationService->calculateBookingPrice(
                servicePrice: $service->price * $quantity,
                businessId: $business->id,
                offerCode: $offerCode,
                commissionRate: $business->platform_fee_percentage ?? 10.00
            );

            return response()->json([
                'success' => true,
                'data' => [
                    'price_breakdown' => $priceBreakdown,
                    'business_model' => 'commission_only',
                    'commission_rate' => $business->platform_fee_percentage ?? 10.00,
                ]
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to calculate price',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Create booking with commission-only model
     *
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function createBooking(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'service_id' => 'required|exists:services,id',
            'business_id' => 'required|exists:businesses,id',
            'employee_id' => 'nullable|exists:employees,id',
            'scheduled_date' => 'required|date|after:now',
            'scheduled_time' => 'required|date_format:H:i',
            'customer_notes' => 'nullable|string|max:500',
            'offer_code' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation failed',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            $service = Service::findOrFail($request->input('service_id'));
            $business = Business::findOrFail($request->input('business_id'));
            
            // Ensure business is using commission-only model
            if (!$business->commission_only_model) {
                return response()->json([
                    'success' => false,
                    'message' => 'Business must use commission-only model'
                ], 422);
            }

            // Calculate price breakdown
            $priceBreakdown = $this->priceCalculationService->calculateBookingPrice(
                servicePrice: $service->price,
                businessId: $business->id,
                offerCode: $request->input('offer_code'),
                commissionRate: $business->platform_fee_percentage ?? 10.00
            );

            // Create booking
            $booking = Booking::create([
                'customer_id' => Auth::id(),
                'business_id' => $business->id,
                'service_id' => $service->id,
                'employee_id' => $request->input('employee_id'),
                'scheduled_date' => $request->input('scheduled_date'),
                'scheduled_time' => $request->input('scheduled_time'),
                'customer_notes' => $request->input('customer_notes'),
                'service_price' => $priceBreakdown['service_price'],
                'discount_amount' => $priceBreakdown['discount_amount'],
                'subtotal' => $priceBreakdown['subtotal'],
                'tax_amount' => $priceBreakdown['tax_amount'],
                'taartu_commission' => $priceBreakdown['taartu_commission'],
                'grand_total' => $priceBreakdown['grand_total'],
                'commission_rate' => $business->platform_fee_percentage ?? 10.00,
                'status' => 'pending',
                'payment_status' => 'pending',
            ]);

            // Track booking creation
            $this->analyticsService->track('booking_created', [
                'booking_id' => $booking->id,
                'business_id' => $business->id,
                'service_id' => $service->id,
                'customer_id' => Auth::id(),
                'commission_rate' => $business->platform_fee_percentage ?? 10.00,
                'total_amount' => $priceBreakdown['grand_total'],
                'commission_amount' => $priceBreakdown['taartu_commission'],
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Booking created successfully',
                'data' => [
                    'booking_id' => $booking->id,
                    'price_breakdown' => $priceBreakdown,
                    'business_model' => 'commission_only',
                    'commission_rate' => $business->platform_fee_percentage ?? 10.00,
                ]
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to create booking',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get booking summary with commission breakdown
     *
     * @param int $bookingId
     * @return \Illuminate\Http\JsonResponse
     */
    public function getBookingSummary($bookingId)
    {
        try {
            $booking = Booking::with(['service', 'business', 'employee'])
                ->where('customer_id', Auth::id())
                ->findOrFail($bookingId);

            $priceBreakdown = [
                'service_price' => $booking->service_price,
                'discount_amount' => $booking->discount_amount,
                'subtotal' => $booking->subtotal,
                'tax_amount' => $booking->tax_amount,
                'taartu_commission' => $booking->taartu_commission,
                'grand_total' => $booking->grand_total,
                'commission_rate' => $booking->commission_rate,
            ];

            return response()->json([
                'success' => true,
                'data' => [
                    'booking' => $booking,
                    'price_breakdown' => $priceBreakdown,
                    'business_model' => 'commission_only',
                    'commission_description' => 'Taartu takes a percentage of each booking—no monthly fees',
                ]
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to get booking summary',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get business earnings breakdown (for business owners)
     *
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function getBusinessEarnings(Request $request)
    {
        try {
            $business = Auth::user()->business;
            
            if (!$business) {
                return response()->json([
                    'success' => false,
                    'message' => 'Business not found'
                ], 404);
            }

            $period = $request->input('period', 'month');
            $startDate = $request->input('start_date');
            $endDate = $request->input('end_date');

            // Get bookings for the period
            $bookings = Booking::where('business_id', $business->id)
                ->where('status', 'completed')
                ->when($startDate && $endDate, function ($query) use ($startDate, $endDate) {
                    return $query->whereBetween('scheduled_date', [$startDate, $endDate]);
                })
                ->when($period === 'month', function ($query) {
                    return $query->whereMonth('scheduled_date', now()->month);
                })
                ->when($period === 'week', function ($query) {
                    return $query->whereBetween('scheduled_date', [now()->startOfWeek(), now()->endOfWeek()]);
                })
                ->get();

            $totalRevenue = $bookings->sum('grand_total');
            $totalCommission = $bookings->sum('taartu_commission');
            $businessEarnings = $totalRevenue - $totalCommission;
            $averageCommissionRate = $bookings->avg('commission_rate') ?? 10.00;

            return response()->json([
                'success' => true,
                'data' => [
                    'period' => $period,
                    'total_bookings' => $bookings->count(),
                    'total_revenue' => $totalRevenue,
                    'taartu_commission' => $totalCommission,
                    'business_earnings' => $businessEarnings,
                    'average_commission_rate' => $averageCommissionRate,
                    'business_model' => 'commission_only',
                    'commission_description' => 'Zero subscription fees—pay only when you earn',
                ]
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to get business earnings',
                'error' => $e->getMessage()
            ], 500);
        }
    }
} 