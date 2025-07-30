<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Response;

class LegalController extends Controller
{
    /**
     * Display Terms of Service page
     */
    public function terms()
    {
        $content = File::get(base_path('docs/TERMS_OF_SERVICE.md'));
        return view('legal.terms', compact('content'));
    }

    /**
     * Display Privacy Policy page
     */
    public function privacy()
    {
        $content = File::get(base_path('docs/PRIVACY_POLICY.md'));
        return view('legal.privacy', compact('content'));
    }

    /**
     * API endpoint for Terms of Service (for Flutter app)
     */
    public function apiTerms()
    {
        $content = File::get(base_path('docs/TERMS_OF_SERVICE.md'));
        return Response::make($content, 200, [
            'Content-Type' => 'text/markdown',
            'Cache-Control' => 'public, max-age=3600',
        ]);
    }

    /**
     * API endpoint for Privacy Policy (for Flutter app)
     */
    public function apiPrivacy()
    {
        $content = File::get(base_path('docs/PRIVACY_POLICY.md'));
        return Response::make($content, 200, [
            'Content-Type' => 'text/markdown',
            'Cache-Control' => 'public, max-age=3600',
        ]);
    }
} 