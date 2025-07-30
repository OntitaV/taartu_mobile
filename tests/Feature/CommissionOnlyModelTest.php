<?php

namespace Tests\Feature;

use Tests\TestCase;
use App\Models\User;
use App\Models\Business;
use App\Models\Service;
use App\Models\Booking;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;

class CommissionOnlyModelTest extends TestCase
{
    use RefreshDatabase, WithFaker;

    protected $user;
    protected $business;
    protected $service;

    protected function setUp(): void
    {
        parent::setUp();
        
        $this->user = User::factory()->create();
        $this->business = Business::factory()->create([
            'user_id' => $this->user->id,
            'platform_fee_percentage' => 10.00,
            'commission_only_model' => true,
            'subscription_model_enabled' => false,
        ]);
        $this->service = Service::factory()->create([
            'business_id' => $this->business->id,
            'price' => 1000.00,
        ]);
    }

    /** @test */
    public function it_enforces_commission_only_model_for_new_businesses()
    {
        $response = $this->actingAs($this->user)
            ->postJson('/api/business/initialize', [
                'business_name' => 'Test Salon',
                'business_type' => 'Salon',
                'location' => 'Nairobi, Kenya',
            ]);

        $response->assertStatus(200)
            ->assertJson([
                'success' => true,
                'data' => [
                    'commission_rate' => 10.00,
                    'model_type' => 'commission_only',
                ]
            ]);

        $business = Business::where('name', 'Test Salon')->first();
        $this->assertEquals(10.00, $business->platform_fee_percentage);
        $this->assertTrue($business->commission_only_model);
        $this->assertFalse($business->subscription_model_enabled);
    }

    /** @test */
    public function it_validates_commission_rate_range()
    {
        // Test minimum rate
        $response = $this->actingAs($this->user)
            ->putJson('/api/business/commission-rate', [
                'commission_rate' => 9.0,
            ]);

        $response->assertStatus(422)
            ->assertJsonValidationErrors(['commission_rate']);

        // Test maximum rate
        $response = $this->actingAs($this->user)
            ->putJson('/api/business/commission-rate', [
                'commission_rate' => 16.0,
            ]);

        $response->assertStatus(422)
            ->assertJsonValidationErrors(['commission_rate']);

        // Test valid rate
        $response = $this->actingAs($this->user)
            ->putJson('/api/business/commission-rate', [
                'commission_rate' => 12.5,
            ]);

        $response->assertStatus(200)
            ->assertJson([
                'success' => true,
                'data' => [
                    'commission_rate' => 12.5,
                ]
            ]);
    }

    /** @test */
    public function it_calculates_booking_price_with_commission_only_model()
    {
        $response = $this->actingAs($this->user)
            ->postJson('/api/bookings/calculate-price', [
                'service_id' => $this->service->id,
                'business_id' => $this->business->id,
                'quantity' => 1,
            ]);

        $response->assertStatus(200)
            ->assertJson([
                'success' => true,
                'data' => [
                    'business_model' => 'commission_only',
                    'commission_rate' => 10.00,
                ]
            ]);

        $priceBreakdown = $response->json('data.price_breakdown');
        $this->assertEquals(1000.00, $priceBreakdown['service_price']);
        $this->assertEquals(100.00, $priceBreakdown['taartu_commission']); // 10% of 1000
        $this->assertEquals(1100.00, $priceBreakdown['grand_total']); // 1000 + 100
    }

    /** @test */
    public function it_creates_booking_with_commission_breakdown()
    {
        $response = $this->actingAs($this->user)
            ->postJson('/api/bookings', [
                'service_id' => $this->service->id,
                'business_id' => $this->business->id,
                'scheduled_date' => now()->addDays(1)->format('Y-m-d'),
                'scheduled_time' => '14:00',
            ]);

        $response->assertStatus(200)
            ->assertJson([
                'success' => true,
                'data' => [
                    'business_model' => 'commission_only',
                    'commission_rate' => 10.00,
                ]
            ]);

        $booking = Booking::latest()->first();
        $this->assertEquals(1000.00, $booking->service_price);
        $this->assertEquals(100.00, $booking->taartu_commission);
        $this->assertEquals(1100.00, $booking->grand_total);
        $this->assertEquals(10.00, $booking->commission_rate);
    }

    /** @test */
    public function it_prevents_subscription_model_bookings()
    {
        // Create a business with subscription model
        $subscriptionBusiness = Business::factory()->create([
            'user_id' => $this->user->id,
            'commission_only_model' => false,
            'subscription_model_enabled' => true,
        ]);

        $response = $this->actingAs($this->user)
            ->postJson('/api/bookings', [
                'service_id' => $this->service->id,
                'business_id' => $subscriptionBusiness->id,
                'scheduled_date' => now()->addDays(1)->format('Y-m-d'),
                'scheduled_time' => '14:00',
            ]);

        $response->assertStatus(422)
            ->assertJson([
                'success' => false,
                'message' => 'Business must use commission-only model'
            ]);
    }

    /** @test */
    public function it_provides_business_earnings_breakdown()
    {
        // Create completed bookings
        Booking::factory()->count(5)->create([
            'business_id' => $this->business->id,
            'service_price' => 1000.00,
            'taartu_commission' => 100.00,
            'grand_total' => 1100.00,
            'commission_rate' => 10.00,
            'status' => 'completed',
        ]);

        $response = $this->actingAs($this->user)
            ->getJson('/api/bookings/business/earnings');

        $response->assertStatus(200)
            ->assertJson([
                'success' => true,
                'data' => [
                    'total_bookings' => 5,
                    'total_revenue' => 5500.00, // 5 * 1100
                    'taartu_commission' => 500.00, // 5 * 100
                    'business_earnings' => 5000.00, // 5500 - 500
                    'average_commission_rate' => 10.00,
                    'business_model' => 'commission_only',
                ]
            ]);
    }

    /** @test */
    public function it_tracks_commission_rate_confirmation()
    {
        $response = $this->actingAs($this->user)
            ->putJson('/api/business/commission-rate', [
                'commission_rate' => 12.5,
            ]);

        $response->assertStatus(200);

        // Verify analytics tracking (mock implementation)
        // In a real test, you would verify that the analytics service was called
        // with the correct event and data
    }

    /** @test */
    public function it_returns_business_model_information()
    {
        $response = $this->actingAs($this->user)
            ->getJson('/api/business/model');

        $response->assertStatus(200)
            ->assertJson([
                'success' => true,
                'data' => [
                    'model_type' => 'commission_only',
                    'commission_rate' => 10.00,
                    'commission_only_model' => true,
                    'subscription_model_enabled' => false,
                    'business_model_message' => 'Zero subscription fees—pay only when you earn',
                    'commission_description' => 'Taartu takes a percentage of each booking—no monthly fees',
                    'constraints' => [
                        'min_commission_rate' => 10.0,
                        'max_commission_rate' => 15.0,
                        'default_commission_rate' => 10.0,
                    ]
                ]
            ]);
    }

    /** @test */
    public function it_handles_booking_summary_with_commission_breakdown()
    {
        $booking = Booking::factory()->create([
            'customer_id' => $this->user->id,
            'business_id' => $this->business->id,
            'service_price' => 1000.00,
            'taartu_commission' => 100.00,
            'grand_total' => 1100.00,
            'commission_rate' => 10.00,
        ]);

        $response = $this->actingAs($this->user)
            ->getJson("/api/bookings/{$booking->id}/summary");

        $response->assertStatus(200)
            ->assertJson([
                'success' => true,
                'data' => [
                    'price_breakdown' => [
                        'service_price' => 1000.00,
                        'taartu_commission' => 100.00,
                        'grand_total' => 1100.00,
                        'commission_rate' => 10.00,
                    ],
                    'business_model' => 'commission_only',
                    'commission_description' => 'Taartu takes a percentage of each booking—no monthly fees',
                ]
            ]);
    }

    /** @test */
    public function it_enforces_commission_constraints_in_price_calculation()
    {
        // Test with different commission rates
        $this->business->update(['platform_fee_percentage' => 15.00]);

        $response = $this->actingAs($this->user)
            ->postJson('/api/bookings/calculate-price', [
                'service_id' => $this->service->id,
                'business_id' => $this->business->id,
                'quantity' => 1,
            ]);

        $response->assertStatus(200);

        $priceBreakdown = $response->json('data.price_breakdown');
        $this->assertEquals(150.00, $priceBreakdown['taartu_commission']); // 15% of 1000
        $this->assertEquals(1150.00, $priceBreakdown['grand_total']); // 1000 + 150
    }

    /** @test */
    public function it_handles_zero_subscription_messaging()
    {
        $response = $this->actingAs($this->user)
            ->getJson('/api/business/model');

        $response->assertStatus(200)
            ->assertJson([
                'data' => [
                    'business_model_message' => 'Zero subscription fees—pay only when you earn',
                    'commission_description' => 'Taartu takes a percentage of each booking—no monthly fees',
                ]
            ]);
    }
} 