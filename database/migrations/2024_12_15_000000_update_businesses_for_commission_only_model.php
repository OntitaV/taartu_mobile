<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class UpdateBusinessesForCommissionOnlyModel extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('businesses', function (Blueprint $table) {
            // Add commission rate column if it doesn't exist
            if (!Schema::hasColumn('businesses', 'platform_fee_percentage')) {
                $table->decimal('platform_fee_percentage', 5, 2)->default(10.00)->after('status');
            }
            
            // Add commission model flag
            if (!Schema::hasColumn('businesses', 'commission_only_model')) {
                $table->boolean('commission_only_model')->default(true)->after('platform_fee_percentage');
            }
            
            // Add subscription model flag (for future reactivation)
            if (!Schema::hasColumn('businesses', 'subscription_model_enabled')) {
                $table->boolean('subscription_model_enabled')->default(false)->after('commission_only_model');
            }
        });

        // Update existing businesses to have default commission rate
        DB::table('businesses')->whereNull('platform_fee_percentage')->update([
            'platform_fee_percentage' => 10.00,
            'commission_only_model' => true,
            'subscription_model_enabled' => false,
        ]);
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('businesses', function (Blueprint $table) {
            $table->dropColumn([
                'platform_fee_percentage',
                'commission_only_model',
                'subscription_model_enabled'
            ]);
        });
    }
} 