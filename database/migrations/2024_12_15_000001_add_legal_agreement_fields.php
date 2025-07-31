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
        // Add agreement fields to businesses table
        Schema::table('businesses', function (Blueprint $table) {
            $table->timestamp('paystack_agreement_signed_at')->nullable();
            $table->string('paystack_agreement_version')->nullable();
            $table->text('paystack_agreement_notes')->nullable();
            $table->string('paystack_agreement_file_path')->nullable();
        });

        // Add agreement fields to settings table
        Schema::table('settings', function (Blueprint $table) {
            $table->timestamp('intercompany_license_signed_at')->nullable();
            $table->string('intercompany_license_version')->nullable();
            $table->text('intercompany_license_notes')->nullable();
            $table->string('intercompany_license_file_path')->nullable();
        });

        // Create legal_documents table for tracking
        Schema::create('legal_documents', function (Blueprint $table) {
            $table->id();
            $table->string('type'); // 'terms', 'privacy', 'paystack', 'intercompany'
            $table->string('version');
            $table->text('content');
            $table->boolean('is_active')->default(true);
            $table->timestamp('published_at')->nullable();
            $table->timestamps();
            
            $table->index(['type', 'is_active']);
        });

        // Create agreement_signatures table for audit trail
        Schema::create('agreement_signatures', function (Blueprint $table) {
            $table->id();
            $table->string('agreement_type'); // 'paystack', 'intercompany'
            $table->unsignedBigInteger('business_id')->nullable();
            $table->string('signed_by');
            $table->string('signature_method'); // 'admin_panel', 'api', 'manual'
            $table->json('metadata')->nullable(); // Store additional data
            $table->timestamps();
            
            $table->foreign('business_id')->references('id')->on('businesses')->onDelete('cascade');
            $table->index(['agreement_type', 'business_id']);
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
                'paystack_agreement_notes',
                'paystack_agreement_file_path'
            ]);
        });

        Schema::table('settings', function (Blueprint $table) {
            $table->dropColumn([
                'intercompany_license_signed_at',
                'intercompany_license_version',
                'intercompany_license_notes',
                'intercompany_license_file_path'
            ]);
        });

        Schema::dropIfExists('legal_documents');
        Schema::dropIfExists('agreement_signatures');
    }
}; 