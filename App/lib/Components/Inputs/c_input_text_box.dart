import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:taqreeb/core/utils/color.dart';

class MyTextBox extends StatefulWidget {
  final String hint;
  final String value;
  final bool isPassword;
  final Function(String)? onFieldSubmitted;
  final FocusNode? focusNode;
  final bool isNum;
  final bool isPrice;
  final TextEditingController valueController;
  final String? errorText;
  final Function(String)? onChanged;
  final IconData? prefixIcon; // New parameter for prefix icon
  final Color? prefixIconColor; // Color for prefix icon
  final double? prefixIconSize; // Size for prefix icon
  final EdgeInsetsGeometry? contentPadding; // Custom padding
  final Color? backgroundColor; // Background color
  final double? borderRadius; // Border radius
  final Color? borderColor; // Border color
  final Color? focusedBorderColor; // Focused border color
  final Color? errorBorderColor; // Error border color
  final Color? textColor; // Text color
  final Color? hintColor; // Hint text color
  final TextStyle? textStyle; // Custom text style
  final TextStyle? hintStyle; // Custom hint style
  final TextStyle? errorStyle; // Custom error style
  final BoxShadow? boxShadow; // Custom shadow

  const MyTextBox({
    super.key,
    this.isPrice = false,
    this.isNum = false,
    this.isPassword = false,
    required this.hint,
    this.onFieldSubmitted,
    this.focusNode,
    this.value = '',
    required this.valueController,
    this.errorText,
    this.onChanged,
    this.prefixIcon,
    this.prefixIconColor,
    this.prefixIconSize,
    this.contentPadding,
    this.backgroundColor,
    this.borderRadius,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.textColor,
    this.hintColor,
    this.textStyle,
    this.hintStyle,
    this.errorStyle,
    this.boxShadow,
  });

  @override
  State<MyTextBox> createState() => _MyTextBoxState();
}

class _MyTextBoxState extends State<MyTextBox> {
  bool _isObscured = true;
  late FocusNode _focusNode;
  bool _isFocused = false;
  late TextEditingController _controller;
  String _previousText = '';

  @override
  void initState() {
    super.initState();
    _isObscured = widget.isPassword;
    _focusNode = widget.focusNode ?? FocusNode();
    _controller = widget.valueController;
    _previousText = _controller.text;

    _focusNode.addListener(() {
      if (mounted) {
        setState(() {
          _isFocused = _focusNode.hasFocus;
        });
      }
    });

    if (widget.isPrice) {
      _controller.addListener(_formatPrice);
    }
  }

  @override
  void dispose() {
    if (widget.isPrice) {
      _controller.removeListener(_formatPrice);
    }
    _focusNode.dispose();
    super.dispose();
  }

  void _formatPrice() {
    if (!widget.isPrice) return;

    String text = _controller.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (text == _previousText) return;

    _previousText = text;

    if (text.isEmpty) {
      _controller.text = '';
      _controller.selection = TextSelection.collapsed(offset: 0);
      return;
    }

    int num = int.tryParse(text) ?? 0;
    String formatted = _formatNumberWithCommas(num);

    if (formatted != _controller.text) {
      _controller.text = formatted;
      _controller.selection = TextSelection.collapsed(
        offset: formatted.length,
      );
    }
  }

  String _formatNumberWithCommas(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  @override
  Widget build(BuildContext context) {
    final defaultBorderColor = widget.borderColor ?? Colors.transparent;
    final focusedBorderColor = widget.focusedBorderColor ?? MyColors.red;
    final errorBorderColor = widget.errorBorderColor ?? MyColors.red;
    final currentBorderColor = _isFocused
        ? focusedBorderColor
        : (widget.errorText != null && widget.errorText!.isNotEmpty
            ? errorBorderColor
            : defaultBorderColor);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: Screen.max(context) * 0.01),
          height: Screen.height(context) * 0.06,
          width: Screen.width(context) * 0.9,
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? MyColors.darkLighter,
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 10),
            border: Border.all(
              color: currentBorderColor,
              width: 2,
            ),
            boxShadow: [
              widget.boxShadow ??
                  BoxShadow(
                    color: Colors.black.withAlpha(102),
                    blurRadius: 4,
                    spreadRadius: 1,
                    offset: const Offset(2, 2),
                  ),
            ],
          ),
          child: Padding(
            padding: widget.contentPadding ??
                EdgeInsets.symmetric(horizontal: Screen.width(context) * 0.05),
            child: Row(
              children: [
                // Prefix icon
                if (widget.prefixIcon != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Icon(
                      widget.prefixIcon,
                      color: widget.prefixIconColor ??
                          MyColors.white.withAlpha(153),
                      size:
                          widget.prefixIconSize ?? Screen.max(context) * 0.025,
                    ),
                  ),

                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    onSubmitted: widget.onFieldSubmitted,
                    onChanged: (value) {
                      if (widget.onChanged != null) {
                        String rawValue =
                            value.replaceAll(RegExp(r'[^0-9]'), '');
                        widget.onChanged!(rawValue);
                      }
                    },
                    obscureText: widget.isPassword ? _isObscured : false,
                    keyboardType: widget.isNum
                        ? TextInputType.number
                        : widget.isPrice
                            ? TextInputType.numberWithOptions(decimal: true)
                            : TextInputType.text,
                    inputFormatters: widget.isNum
                        ? [FilteringTextInputFormatter.digitsOnly]
                        : widget.isPrice
                            ? [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9,]')),
                              ]
                            : null,
                    style: widget.textStyle ??
                        GoogleFonts.roboto(
                          fontSize: Screen.max(context) * 0.018,
                          fontWeight: FontWeight.w400,
                          color: widget.textColor ?? MyColors.white,
                        ),
                    decoration: InputDecoration(
                      hintText: widget.hint,
                      hintStyle: widget.hintStyle ??
                          GoogleFonts.roboto(
                            color: widget.hintColor ??
                                MyColors.white.withAlpha(153),
                            fontSize: Screen.max(context) * 0.015,
                          ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                if (widget.isPassword)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isObscured = !_isObscured;
                      });
                    },
                    child: Icon(
                      _isObscured ? Icons.visibility_off : Icons.visibility,
                      color: MyColors.white.withAlpha(153),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (widget.errorText != null && widget.errorText!.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(left: Screen.width(context) * 0.05),
            child: Text(
              widget.errorText!,
              style: widget.errorStyle ??
                  GoogleFonts.roboto(
                    color: errorBorderColor,
                    fontSize: Screen.max(context) * 0.015,
                  ),
            ),
          ),
      ],
    );
  }
}
