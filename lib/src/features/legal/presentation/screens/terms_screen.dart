import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;
import '../../../../core/theme/app_theme.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({super.key});

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  String _termsContent = '';
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTerms();
  }

  Future<void> _loadTerms() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.taartu.com/api/legal/terms'),
        headers: {'Accept': 'text/markdown'},
      );

      if (response.statusCode == 200) {
        setState(() {
          _termsContent = response.body;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load terms of service';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Network error: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Service'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primary,
              ),
            )
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: AppTheme.gray400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _error!,
                        style: TextStyle(
                          color: AppTheme.gray600,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadTerms,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : Markdown(
                  data: _termsContent,
                  styleSheet: MarkdownStyleSheet(
                    h1: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.gray900,
                    ),
                    h2: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.gray900,
                    ),
                    h3: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.gray900,
                    ),
                    p: TextStyle(
                      fontSize: 16,
                      color: AppTheme.gray700,
                      height: 1.5,
                    ),
                    listBullet: TextStyle(
                      color: AppTheme.primary,
                    ),
                    strong: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.gray900,
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                ),
    );
  }
} 