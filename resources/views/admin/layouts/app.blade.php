<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Taartu Admin Panel - Manage your booking marketplace">
    <meta name="keywords" content="admin, dashboard, booking, management">
    <meta name="author" content="Taartu">
    
    <!-- Favicon -->
    <link rel="icon" type="image/x-icon" href="{{ asset('favicon.ico') }}">
    <link rel="shortcut icon" type="image/x-icon" href="{{ asset('favicon.ico') }}">
    
    <title>@yield('title', 'Taartu Admin')</title>
    
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    
    <!-- Alpine.js -->
    <script defer src="https://unpkg.com/alpinejs@3.x.x/dist/cdn.min.js"></script>
    
    <style>
        [x-cloak] { display: none !important; }
    </style>
</head>
<body class="bg-gray-100">
    <!-- Admin Header -->
    <header class="bg-white shadow-sm border-b border-gray-200">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between items-center h-16">
                <!-- Logo -->
                <div class="flex items-center">
                    <a href="{{ url('/admin') }}" class="flex items-center">
                        <img src="{{ asset('assets/logos/logo_secondary.png') }}" 
                             alt="Taartu Admin" 
                             class="h-8 w-auto">
                        <span class="ml-3 text-lg font-semibold text-gray-900">Admin</span>
                    </a>
                </div>
                
                <!-- Admin Navigation -->
                <nav class="hidden md:flex space-x-8">
                    <a href="{{ url('/admin/dashboard') }}" class="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium">Dashboard</a>
                    <a href="{{ url('/admin/users') }}" class="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium">Users</a>
                    <a href="{{ url('/admin/businesses') }}" class="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium">Businesses</a>
                    <a href="{{ url('/admin/bookings') }}" class="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium">Bookings</a>
                    <a href="{{ url('/admin/settings') }}" class="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium">Settings</a>
                </nav>
                
                <!-- Admin User Menu -->
                <div class="flex items-center space-x-4">
                    <span class="text-gray-700 text-sm">Admin User</span>
                    <a href="{{ url('/admin/logout') }}" class="text-red-600 hover:text-red-700 px-3 py-2 rounded-md text-sm font-medium">Logout</a>
                </div>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        @yield('content')
    </main>

    <!-- Admin Footer -->
    <footer class="bg-gray-900 text-white mt-auto">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
            <div class="flex justify-between items-center">
                <div class="flex items-center">
                    <img src="{{ asset('assets/logos/logo_secondary.png') }}" 
                         alt="Taartu" 
                         class="h-6 w-auto mr-3">
                    <span class="text-sm">Taartu Admin Panel</span>
                </div>
                <p class="text-gray-300 text-sm">
                    © {{ date('Y') }} Taartu. All rights reserved.
                </p>
            </div>
        </div>
    </footer>
</body>
</html> 