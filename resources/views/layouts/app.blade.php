<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Taartu Booking Marketplace - Connect with the best salons and stylists in Kenya">
    <meta name="keywords" content="salon, booking, beauty, hair, makeup, kenya">
    <meta name="author" content="Taartu">
    
    <!-- Favicon -->
    <link rel="icon" type="image/x-icon" href="{{ asset('favicon.ico') }}">
    <link rel="shortcut icon" type="image/x-icon" href="{{ asset('favicon.ico') }}">
    
    <title>@yield('title', 'Taartu - Booking Marketplace')</title>
    
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    
    <!-- Alpine.js -->
    <script defer src="https://unpkg.com/alpinejs@3.x.x/dist/cdn.min.js"></script>
    
    <style>
        [x-cloak] { display: none !important; }
    </style>
</head>
<body class="bg-gray-50">
    <!-- Header -->
    <header class="bg-white shadow-sm border-b border-gray-200">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between items-center h-16">
                <!-- Logo -->
                <div class="flex items-center">
                    <a href="{{ url('/') }}" class="flex items-center">
                        <img src="{{ asset('assets/logos/logo_primary.png') }}" 
                             alt="Taartu" 
                             class="h-8 w-auto">
                    </a>
                </div>
                
                <!-- Navigation -->
                <nav class="hidden md:flex space-x-8">
                    <a href="{{ url('/') }}" class="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium">Home</a>
                    <a href="{{ url('/services') }}" class="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium">Services</a>
                    <a href="{{ url('/about') }}" class="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium">About</a>
                    <a href="{{ url('/contact') }}" class="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium">Contact</a>
                </nav>
                
                <!-- User Menu -->
                <div class="flex items-center space-x-4">
                    <a href="{{ url('/login') }}" class="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium">Login</a>
                    <a href="{{ url('/register') }}" class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-md text-sm font-medium">Sign Up</a>
                </div>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        @yield('content')
    </main>

    <!-- Footer -->
    <footer class="bg-gray-900 text-white">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
            <div class="grid grid-cols-1 md:grid-cols-4 gap-8">
                <!-- Logo and Description -->
                <div class="col-span-1 md:col-span-2">
                    <div class="flex items-center mb-4">
                        <img src="{{ asset('assets/logos/logo_secondary.png') }}" 
                             alt="Taartu" 
                             class="h-6 w-auto mr-3">
                        <span class="text-lg font-semibold">Taartu</span>
                    </div>
                    <p class="text-gray-300 mb-4">
                        Connect with the best salons and stylists in Kenya. 
                        Book appointments, discover great services, and manage your beauty business.
                    </p>
                </div>
                
                <!-- Quick Links -->
                <div>
                    <h3 class="text-lg font-semibold mb-4">Quick Links</h3>
                    <ul class="space-y-2">
                        <li><a href="{{ url('/services') }}" class="text-gray-300 hover:text-white">Services</a></li>
                        <li><a href="{{ url('/salons') }}" class="text-gray-300 hover:text-white">Salons</a></li>
                        <li><a href="{{ url('/bookings') }}" class="text-gray-300 hover:text-white">Bookings</a></li>
                        <li><a href="{{ url('/business') }}" class="text-gray-300 hover:text-white">Business</a></li>
                    </ul>
                </div>
                
                <!-- Support -->
                <div>
                    <h3 class="text-lg font-semibold mb-4">Support</h3>
                    <ul class="space-y-2">
                        <li><a href="{{ url('/help') }}" class="text-gray-300 hover:text-white">Help Center</a></li>
                        <li><a href="{{ url('/contact') }}" class="text-gray-300 hover:text-white">Contact Us</a></li>
                        <li><a href="{{ url('/legal/terms') }}" class="text-gray-300 hover:text-white">Terms of Service</a></li>
                        <li><a href="{{ url('/legal/privacy') }}" class="text-gray-300 hover:text-white">Privacy Policy</a></li>
                    </ul>
                </div>
            </div>
            
            <!-- Copyright -->
            <div class="border-t border-gray-800 mt-8 pt-8 flex flex-col md:flex-row justify-between items-center">
                <p class="text-gray-300 text-sm">
                    © {{ date('Y') }} Taartu. All rights reserved.
                </p>
                <div class="flex items-center mt-4 md:mt-0">
                    <img src="{{ asset('assets/logos/logo_secondary.png') }}" 
                         alt="Taartu" 
                         class="h-4 w-auto mr-2">
                    <span class="text-gray-300 text-sm">Powered by Taartu</span>
                </div>
            </div>
        </div>
    </footer>
</body>
</html> 