// ignore_for_file: deprecated_member_use, must_be_immutable

import 'package:flutter/material.dart';

import '../theme.dart';

// PERFORMANCE OPTIMIZED: Made stateful to avoid rebuilding decoration
class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.width,
    required this.controller,
    required this.height,
    this.keyboardType,
  });

  final double width;
  final double height;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  // Cache the decoration to prevent rebuilding
  late final BoxDecoration _cachedDecoration;

  @override
  void initState() {
    super.initState();
    _cachedDecoration = BoxDecoration(
      border: Border.all(
        color: AppColors.metalLight.withOpacity(0.3),
        width: 1,
      ),
      borderRadius: BorderRadius.circular(12),
      image: DecorationImage(
        image: AssetImage('assets/img/bg3.jpg'),
        fit: BoxFit.cover,
      ),
      boxShadow: const [
        BoxShadow(
          color: Colors.black87,
          blurRadius: 10,
          offset: Offset(0, 5),
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Colors.black54,
          blurRadius: 15,
          offset: Offset(0, 8),
          spreadRadius: -3,
        ),
        BoxShadow(
          color: Colors.white10,
          blurRadius: 6,
          offset: Offset(0, -3),
          spreadRadius: 0,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Cached decoration container
        Container(
          width: widget.width,
          height: widget.height,
          decoration: _cachedDecoration,
        ),

        // Overlay container
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.black.withOpacity(0.3),
            ),
          ),
        ),

        // TextField - extracted as const to prevent rebuilds
        Positioned(
          child: _OptimizedTextField(
            keyboardType: widget.keyboardType,
            controller: widget.controller,
          ),
        ),
      ],
    );
  }
}

// Extracted TextField widget to isolate rebuilds
class _OptimizedTextField extends StatelessWidget {
  final TextInputType? keyboardType;
  final TextEditingController controller;

  const _OptimizedTextField({
    required this.keyboardType,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboardType,
      style: const TextStyle(color: AppColors.textPrimary),
      cursorColor: AppColors.textPrimary,
      controller: controller,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.only(left: 15, bottom: 3),
        border: InputBorder.none,
      ),
    );
  }
}
