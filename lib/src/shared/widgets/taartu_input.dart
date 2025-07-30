import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taartu_mobile/src/core/theme/app_theme.dart';

enum TaartuInputType {
  text,
  email,
  password,
  phone,
  number,
  multiline,
}

class TaartuInput extends StatefulWidget {
  final String label;
  final String? hint;
  final String? errorText;
  final TaartuInputType type;
  final TextEditingController? controller;
  final String? initialValue;
  final bool isRequired;
  final bool isEnabled;
  final bool isReadOnly;
  final int? maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;

  const TaartuInput({
    super.key,
    required this.label,
    this.hint,
    this.errorText,
    this.type = TaartuInputType.text,
    this.controller,
    this.initialValue,
    this.isRequired = false,
    this.isEnabled = true,
    this.isReadOnly = false,
    this.maxLines,
    this.maxLength,
    this.inputFormatters,
    this.textInputAction,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.focusNode,
  });

  @override
  State<TaartuInput> createState() => _TaartuInputState();
}

class _TaartuInputState extends State<TaartuInput> {
  bool _obscureText = true;
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: widget.initialValue);
    _focusNode = widget.focusNode ?? FocusNode();
    
    if (widget.type == TaartuInputType.password) {
      _obscureText = true;
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Row(
          children: [
            Text(
              widget.label,
              style: theme.textTheme.labelLarge!.copyWith(
                color: hasError ? AppTheme.error : AppTheme.gray700,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (widget.isRequired)
              Text(
                ' *',
                style: theme.textTheme.labelLarge!.copyWith(
                  color: AppTheme.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
        SizedBox(height: AppTheme.spacing8),
        
        // Input Field
        TextFormField(
          controller: _controller,
          focusNode: _focusNode,
          enabled: widget.isEnabled,
          readOnly: widget.isReadOnly,
          obscureText: widget.type == TaartuInputType.password && _obscureText,
          maxLines: widget.type == TaartuInputType.multiline ? (widget.maxLines ?? 4) : 1,
          maxLength: widget.maxLength,
          inputFormatters: _getInputFormatters(),
          textInputAction: widget.textInputAction ?? _getTextInputAction(),
          keyboardType: widget.keyboardType ?? _getKeyboardType(),
          onTap: widget.onTap,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          validator: widget.validator ?? _getDefaultValidator(),
          style: theme.textTheme.bodyLarge!.copyWith(
            color: widget.isEnabled ? AppTheme.gray900 : AppTheme.gray500,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: widget.prefixIcon,
            suffixIcon: _buildSuffixIcon(),
            errorText: widget.errorText,
            errorMaxLines: 2,
            counterText: '', // Hide character counter
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacing16,
              vertical: AppTheme.spacing12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radius8),
              borderSide: BorderSide(
                color: hasError ? AppTheme.error : AppTheme.gray200,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radius8),
              borderSide: BorderSide(
                color: hasError ? AppTheme.error : AppTheme.gray200,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radius8),
              borderSide: const BorderSide(
                color: AppTheme.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radius8),
              borderSide: const BorderSide(
                color: AppTheme.error,
                width: 2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radius8),
              borderSide: const BorderSide(
                color: AppTheme.error,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: widget.isEnabled ? AppTheme.gray50 : AppTheme.gray100,
          ),
        ),
      ],
    );
  }

  List<TextInputFormatter> _getInputFormatters() {
    final formatters = <TextInputFormatter>[];
    
    if (widget.inputFormatters != null) {
      formatters.addAll(widget.inputFormatters!);
    }
    
    switch (widget.type) {
      case TaartuInputType.number:
        formatters.add(FilteringTextInputFormatter.digitsOnly);
        break;
      case TaartuInputType.phone:
        formatters.add(FilteringTextInputFormatter.digitsOnly);
        break;
      case TaartuInputType.email:
        formatters.add(FilteringTextInputFormatter.deny(RegExp(r'\s')));
        break;
      default:
        break;
    }
    
    return formatters;
  }

  TextInputAction _getTextInputAction() {
    switch (widget.type) {
      case TaartuInputType.multiline:
        return TextInputAction.newline;
      case TaartuInputType.email:
        return TextInputAction.next;
      case TaartuInputType.password:
        return TextInputAction.done;
      default:
        return TextInputAction.next;
    }
  }

  TextInputType _getKeyboardType() {
    switch (widget.type) {
      case TaartuInputType.email:
        return TextInputType.emailAddress;
      case TaartuInputType.password:
        return TextInputType.visiblePassword;
      case TaartuInputType.phone:
        return TextInputType.phone;
      case TaartuInputType.number:
        return TextInputType.number;
      case TaartuInputType.multiline:
        return TextInputType.multiline;
      default:
        return TextInputType.text;
    }
  }

  String? Function(String?)? _getDefaultValidator() {
    if (!widget.isRequired) return null;
    
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return '${widget.label} is required';
      }
      
      switch (widget.type) {
        case TaartuInputType.email:
          final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
          if (!emailRegex.hasMatch(value)) {
            return 'Please enter a valid email address';
          }
          break;
        case TaartuInputType.phone:
          if (value.length < 10) {
            return 'Please enter a valid phone number';
          }
          break;
        case TaartuInputType.password:
          if (value.length < 8) {
            return 'Password must be at least 8 characters';
          }
          break;
        default:
          break;
      }
      
      return null;
    };
  }

  Widget? _buildSuffixIcon() {
    if (widget.suffixIcon != null) {
      return widget.suffixIcon;
    }
    
    if (widget.type == TaartuInputType.password) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility : Icons.visibility_off,
          color: AppTheme.gray500,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }
    
    return null;
  }
} 