<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Agreement Management - Taartu Admin</title>
    
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    
    <!-- Alpine.js -->
    <script defer src="https://unpkg.com/alpinejs@3.x.x/dist/cdn.min.js"></script>
</head>
<body class="bg-gray-50">
    <div class="min-h-screen">
        <!-- Header -->
        <header class="bg-white shadow-sm border-b">
            <div class="max-w-7xl mx-auto px-4 py-4">
                <div class="flex items-center justify-between">
                    <h1 class="text-2xl font-bold text-gray-900">Agreement Management</h1>
                    <nav class="flex space-x-6">
                        <a href="/admin" class="text-gray-600 hover:text-gray-900">Dashboard</a>
                        <a href="/admin/businesses" class="text-gray-600 hover:text-gray-900">Businesses</a>
                        <a href="/admin/settings" class="text-gray-600 hover:text-gray-900">Settings</a>
                    </nav>
                </div>
            </div>
        </header>

        <!-- Main Content -->
        <main class="max-w-7xl mx-auto px-4 py-8">
            <!-- Paystack Merchant Agreements -->
            <div class="bg-white rounded-lg shadow-sm border p-6 mb-8">
                <div class="flex items-center justify-between mb-6">
                    <h2 class="text-xl font-semibold text-gray-900">Paystack Merchant Agreements</h2>
                    <a href="{{ route('admin.agreements.download', 'paystack') }}" 
                       class="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700">
                        Download Template
                    </a>
                </div>

                <div class="overflow-x-auto">
                    <table class="min-w-full divide-y divide-gray-200">
                        <thead class="bg-gray-50">
                            <tr>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                    Business
                                </th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                    Agreement Status
                                </th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                    Version
                                </th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                    Signed Date
                                </th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                    Actions
                                </th>
                            </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200">
                            @foreach($businesses as $business)
                            <tr>
                                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                                    {{ $business->name }}
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    @if($business->paystack_agreement_signed_at)
                                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                                            Signed
                                        </span>
                                    @else
                                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800">
                                            Not Signed
                                        </span>
                                    @endif
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                    {{ $business->paystack_agreement_version ?? 'N/A' }}
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                    {{ $business->paystack_agreement_signed_at ? $business->paystack_agreement_signed_at->format('M d, Y') : 'N/A' }}
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                    <button onclick="updatePaystackAgreement({{ $business->id }}, {{ $business->paystack_agreement_signed_at ? 'true' : 'false' }})"
                                            class="text-blue-600 hover:text-blue-900">
                                        {{ $business->paystack_agreement_signed_at ? 'Mark Unsigned' : 'Mark Signed' }}
                                    </button>
                                </td>
                            </tr>
                            @endforeach
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Intercompany License Agreement -->
            <div class="bg-white rounded-lg shadow-sm border p-6">
                <div class="flex items-center justify-between mb-6">
                    <h2 class="text-xl font-semibold text-gray-900">Intercompany License Agreement</h2>
                    <a href="{{ route('admin.agreements.download', 'intercompany') }}" 
                       class="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700">
                        Download Template
                    </a>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                    <div class="bg-gray-50 p-4 rounded-lg">
                        <h3 class="text-sm font-medium text-gray-900 mb-2">Status</h3>
                        @if($settings->intercompany_license_signed_at)
                            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                                Signed
                            </span>
                        @else
                            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800">
                                Not Signed
                            </span>
                        @endif
                    </div>

                    <div class="bg-gray-50 p-4 rounded-lg">
                        <h3 class="text-sm font-medium text-gray-900 mb-2">Version</h3>
                        <p class="text-sm text-gray-600">{{ $settings->intercompany_license_version ?? 'N/A' }}</p>
                    </div>

                    <div class="bg-gray-50 p-4 rounded-lg">
                        <h3 class="text-sm font-medium text-gray-900 mb-2">Signed Date</h3>
                        <p class="text-sm text-gray-600">
                            {{ $settings->intercompany_license_signed_at ? $settings->intercompany_license_signed_at->format('M d, Y') : 'N/A' }}
                        </p>
                    </div>
                </div>

                <div class="mt-6">
                    <button onclick="updateIntercompanyAgreement({{ $settings->intercompany_license_signed_at ? 'true' : 'false' }})"
                            class="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700">
                        {{ $settings->intercompany_license_signed_at ? 'Mark Unsigned' : 'Mark Signed' }}
                    </button>
                </div>
            </div>
        </main>
    </div>

    <script>
        function updatePaystackAgreement(businessId, currentStatus) {
            const newStatus = !currentStatus;
            
            fetch('{{ route("admin.agreements.paystack") }}', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
                },
                body: JSON.stringify({
                    business_id: businessId,
                    signed: newStatus,
                    version: '1.0',
                    notes: newStatus ? 'Agreement signed via admin panel' : 'Agreement unsigned via admin panel'
                })
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    location.reload();
                } else {
                    alert('Error updating agreement status');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error updating agreement status');
            });
        }

        function updateIntercompanyAgreement(currentStatus) {
            const newStatus = !currentStatus;
            
            fetch('{{ route("admin.agreements.intercompany") }}', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
                },
                body: JSON.stringify({
                    signed: newStatus,
                    version: '1.0',
                    notes: newStatus ? 'Agreement signed via admin panel' : 'Agreement unsigned via admin panel'
                })
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    location.reload();
                } else {
                    alert('Error updating agreement status');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error updating agreement status');
            });
        }
    </script>
</body>
</html> 