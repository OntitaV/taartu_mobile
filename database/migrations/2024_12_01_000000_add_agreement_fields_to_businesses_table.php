<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('businesses', function (Blueprint $table) {
            $table->timestamp('paystack_agreement_signed_at')->nullable();
            $table->string('paystack_agreement_version')->nullable();
            $table->text('paystack_agreement_notes')->nullable();
        });

        Schema::table('settings', function (Blueprint $table) {
            $table->timestamp('intercompany_license_signed_at')->nullable();
            $table->string('intercompany_license_version')->nullable();
            $table->text('intercompany_license_notes')->nullable();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('businesses', function (Blueprint $table) {
            $table->dropColumn([
                'paystack_agreement_signed_at',
                'paystack_agreement_version',
                'paystack_agreement_notes'
            ]);
        });

        Schema::table('settings', function (Blueprint $table) {
            $table->dropColumn([
                'intercompany_license_signed_at',
                'intercompany_license_version',
                'intercompany_license_notes'
            ]);
        });
    }
}; 