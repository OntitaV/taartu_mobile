<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Terms of Service - Taartu</title>
    <meta name="description" content="Terms of Service for Taartu booking marketplace">
    
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    
    <!-- Markdown Styling -->
    <style>
        .markdown-content {
            @apply prose prose-lg max-w-none;
        }
        .markdown-content h1 {
            @apply text-3xl font-bold text-gray-900 mb-6;
        }
        .markdown-content h2 {
            @apply text-2xl font-bold text-gray-900 mb-4 mt-8;
        }
        .markdown-content h3 {
            @apply text-xl font-semibold text-gray-900 mb-3 mt-6;
        }
        .markdown-content p {
            @apply text-gray-700 mb-4 leading-relaxed;
        }
        .markdown-content ul {
            @apply list-disc list-inside mb-4;
        }
        .markdown-content li {
            @apply text-gray-700 mb-1;
        }
        .markdown-content strong {
            @apply font-semibold text-gray-900;
        }
        .markdown-content a {
            @apply text-blue-600 hover:text-blue-800 underline;
        }
    </style>
</head>
<body class="bg-gray-50">
    <!-- Header -->
    <header class="bg-white shadow-sm border-b">
        <div class="max-w-4xl mx-auto px-4 py-4">
            <div class="flex items-center justify-between">
                <div class="flex items-center space-x-3">
                    <div class="w-8 h-8 bg-blue-600 rounded-lg flex items-center justify-center">
                        <svg class="w-5 h-5 text-white" fill="currentColor" viewBox="0 0 20 20">
                            <path d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                        </svg>
                    </div>
                    <h1 class="text-xl font-bold text-gray-900">Taartu</h1>
                </div>
                <nav class="flex space-x-6">
                    <a href="{{ route('legal.terms') }}" class="text-blue-600 font-medium">Terms</a>
                    <a href="{{ route('legal.privacy') }}" class="text-gray-600 hover:text-gray-900">Privacy</a>
                </nav>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <main class="max-w-4xl mx-auto px-4 py-8">
        <div class="bg-white rounded-lg shadow-sm border p-8">
            <div class="markdown-content">
                {!! Str::markdown($content) !!}
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer class="bg-white border-t mt-12">
        <div class="max-w-4xl mx-auto px-4 py-6">
            <div class="text-center text-gray-600">
                <p>&copy; {{ date('Y') }} Taartustreets Technologies Ltd. All rights reserved.</p>
                <div class="mt-2 space-x-4">
                    <a href="{{ route('legal.terms') }}" class="text-blue-600 hover:text-blue-800">Terms of Service</a>
                    <a href="{{ route('legal.privacy') }}" class="text-blue-600 hover:text-blue-800">Privacy Policy</a>
                </div>
            </div>
        </div>
    </footer>
</body>
</html> 