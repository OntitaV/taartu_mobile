<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;

class AdminController extends Controller
{
    /**
     * Display agreements management page
     */
    public function agreements()
    {
        $businesses = DB::table('businesses')
            ->select('id', 'name', 'paystack_agreement_signed_at', 'paystack_agreement_version')
            ->get();

        $settings = DB::table('settings')->first();
        
        return view('admin.agreements', compact('businesses', 'settings'));
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

        DB::table('businesses')
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

        DB::table('settings')->update($data);

        return response()->json([
            'success' => true,
            'message' => 'Intercompany license agreement status updated successfully'
        ]);
    }

    /**
     * Download agreement template
     */
    public function downloadAgreement($type)
    {
        $validTypes = ['paystack', 'intercompany'];
        
        if (!in_array($type, $validTypes)) {
            abort(404);
        }

        $filename = strtoupper($type) . '_AGREEMENT.md';
        $filepath = base_path("docs/{$filename}");

        if (!File::exists($filepath)) {
            abort(404, 'Agreement template not found');
        }

        return response()->download($filepath, "Taartu_{$type}_agreement.md", [
            'Content-Type' => 'text/markdown',
        ]);
    }
} 