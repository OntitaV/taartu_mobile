<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Response;

class LegalController extends Controller
{
    /**
     * Get Terms of Service (API endpoint for Flutter app)
     */
    public function terms()
    {
        $content = File::get(base_path('docs/TERMS_OF_SERVICE.md'));
        return Response::make($content, 200, [
            'Content-Type' => 'text/markdown',
            'Cache-Control' => 'public, max-age=3600',
            'Access-Control-Allow-Origin' => '*',
        ]);
    }

    /**
     * Get Privacy Policy (API endpoint for Flutter app)
     */
    public function privacy()
    {
        $content = File::get(base_path('docs/PRIVACY_POLICY.md'));
        return Response::make($content, 200, [
            'Content-Type' => 'text/markdown',
            'Cache-Control' => 'public, max-age=3600',
            'Access-Control-Allow-Origin' => '*',
        ]);
    }

    /**
     * Get agreement status for admin
     */
    public function agreementStatus()
    {
        $businesses = \DB::table('businesses')
            ->select('id', 'name', 'paystack_agreement_signed_at', 'paystack_agreement_version')
            ->get();

        $settings = \DB::table('settings')->first();

        return response()->json([
            'businesses' => $businesses,
            'intercompany_license' => [
                'signed_at' => $settings->intercompany_license_signed_at ?? null,
                'version' => $settings->intercompany_license_version ?? null,
            ]
        ]);
    }

    /**
     * Update Paystack agreement status
     */
    public function updatePaystackAgreement(Request $request)
    {
        $request->validate([
            'business_id' => 'required|exists:businesses,id',
            'signed' => 'required|boolean',
            'version' => 'nullable|string',
            'notes' => 'nullable|string',
        ]);

        $data = [
            'paystack_agreement_version' => $request->version,
            'paystack_agreement_notes' => $request->notes,
        ];

        if ($request->signed) {
            $data['paystack_agreement_signed_at'] = now();
        } else {
            $data['paystack_agreement_signed_at'] = null;
        }

        \DB::table('businesses')
            ->where('id', $request->business_id)
            ->update($data);

        return response()->json([
            'success' => true,
            'message' => 'Paystack agreement status updated successfully'
        ]);
    }

    /**
     * Update Intercompany license agreement status
     */
    public function updateIntercompanyAgreement(Request $request)
    {
        $request->validate([
            'signed' => 'required|boolean',
            'version' => 'nullable|string',
            'notes' => 'nullable|string',
        ]);

        $data = [
            'intercompany_license_version' => $request->version,
            'intercompany_license_notes' => $request->notes,
        ];

        if ($request->signed) {
            $data['intercompany_license_signed_at'] = now();
        } else {
            $data['intercompany_license_signed_at'] = null;
        }

        \DB::table('settings')->update($data);

        return response()->json([
            'success' => true,
            'message' => 'Intercompany license agreement status updated successfully'
        ]);
    }
} 