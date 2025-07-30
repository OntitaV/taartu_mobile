import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;
import '../../../../core/theme/app_theme.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  String _privacyContent = '';
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPrivacy();
  }

  Future<void> _loadPrivacy() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.taartu.com/api/legal/privacy'),
        headers: {'Accept': 'text/markdown'},
      );

      if (response.statusCode == 200) {
        setState(() {
          _privacyContent = response.body;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load privacy policy';
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
        title: const Text('Privacy Policy'),
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
                        onPressed: _loadPrivacy,
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
                  data: _privacyContent,
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