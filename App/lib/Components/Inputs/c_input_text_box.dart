import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  final IconData? prefixIcon;
  final Color? prefixIconColor;
  final double? prefixIconSize;
  final EdgeInsetsGeometry? contentPadding;
  final Color? backgroundColor;
  final double? borderRadius;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final Color? textColor;
  final Color? hintColor;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final TextStyle? errorStyle;
  final BoxShadow? boxShadow;
  final int? maxLength;
  final bool phone; // New parameter for phone formatting
  final bool cnic; // New parameter for CNIC formatting

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
    this.maxLength,
    this.phone = false,
    this.cnic = false,
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
  late TextEditingController
      _displayController; // Controller for displayed text

  @override
  void initState() {
    super.initState();
    _isObscured = widget.isPassword;
    _focusNode = widget.focusNode ?? FocusNode();
    _controller = widget.valueController;
    _displayController =
        TextEditingController(); // Initialize display controller
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

    // Initialize display text
    _updateDisplayText();
    _controller.addListener(_updateDisplayText);
  }

  @override
  void dispose() {
    if (widget.isPrice) {
      _controller.removeListener(_formatPrice);
    }
    _controller.removeListener(_updateDisplayText);
    _displayController.dispose();
    super.dispose();
  }

  void _updateDisplayText() {
    String text = _controller.text;
    if (widget.phone) {
      // Format phone number: xxxx-xxxxxxx
      if (text.length > 4) {
        _displayController.text =
            '${text.substring(0, 4)}-${text.substring(4)}';
      } else {
        _displayController.text = text;
      }
    } else if (widget.cnic) {
      // Format CNIC: xxxxx-xxxxxxx-x
      if (text.length > 12) {
        _displayController.text =
            '${text.substring(0, 5)}-${text.substring(5, 12)}-${text.substring(12)}';
      } else if (text.length > 5) {
        _displayController.text =
            '${text.substring(0, 5)}-${text.substring(5)}';
      } else {
        _displayController.text = text;
      }
    } else {
      _displayController.text = text;
    }

    // Update cursor position
    if (_focusNode.hasFocus) {
      int cursorPosition = _displayController.text.length;
      _displayController.selection =
          TextSelection.collapsed(offset: cursorPosition);
    }
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

  String _removeFormatting(String text) {
    return text.replaceAll(RegExp(r'[^0-9]'), '');
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors(context);

    final defaultBorderColor = widget.borderColor ?? Colors.transparent;
    final focusedBorderColor = widget.focusedBorderColor ?? colors.red;
    final errorBorderColor = widget.errorBorderColor ?? colors.red;
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
            color: widget.backgroundColor ?? colors.lightDark,
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
                if (widget.prefixIcon != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Icon(
                      widget.prefixIcon,
                      color: _isFocused
                          ? colors.red
                          : widget.prefixIconColor ??
                              colors.white.withAlpha(153),
                      size:
                          widget.prefixIconSize ?? Screen.max(context) * 0.025,
                    ),
                  ),
                Expanded(
                  child: TextField(
                    controller: _displayController, // Use display controller
                    focusNode: _focusNode,
                    onSubmitted: widget.onFieldSubmitted,
                    onChanged: (value) {
                      // Remove formatting to get raw value
                      String rawValue = _removeFormatting(value);

                      // Enforce max length if specified
                      if (widget.maxLength != null &&
                          rawValue.length > widget.maxLength!) {
                        rawValue = rawValue.substring(0, widget.maxLength);
                      }

                      // Update the actual controller with raw value
                      _controller.value = _controller.value.copyWith(
                        text: rawValue,
                        selection:
                            TextSelection.collapsed(offset: rawValue.length),
                        composing: TextRange.empty,
                      );

                      if (widget.onChanged != null) {
                        widget.onChanged!(rawValue);
                      }
                    },
                    obscureText: widget.isPassword ? _isObscured : false,
                    keyboardType: widget.isNum || widget.phone || widget.cnic
                        ? TextInputType.number
                        : widget.isPrice
                            ? TextInputType.numberWithOptions(decimal: true)
                            : TextInputType.text,
                    inputFormatters: [
                      if (widget.isNum || widget.phone || widget.cnic)
                        FilteringTextInputFormatter.digitsOnly,
                      if (widget.isPrice)
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
                      if (widget.maxLength != null)
                        LengthLimitingTextInputFormatter(widget.maxLength! +
                            (widget.phone ? 1 : 0) +
                            (widget.cnic
                                ? 2
                                : 0)), // Account for formatting characters
                    ],
                    style: GoogleFonts.roboto(
                      fontSize: Screen.max(context) * 0.018,
                      fontWeight: FontWeight.w400,
                      color: colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: widget.hint,
                      hintStyle: widget.hintStyle ??
                          GoogleFonts.roboto(
                            color:
                                widget.hintColor ?? colors.white.withAlpha(153),
                            fontSize: Screen.max(context) * 0.015,
                          ),
                      border: InputBorder.none,
                      counterText: '',
                    ),
                    maxLength: widget.maxLength != null
                        ? widget.maxLength! +
                            (widget.phone ? 1 : 0) +
                            (widget.cnic
                                ? 2
                                : 0) // Account for formatting characters
                        : null,
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
                      _isObscured
                          ? FontAwesomeIcons.eyeSlash
                          : FontAwesomeIcons.eyeSlash,
                      color: colors.white.withAlpha(153),
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
        if (widget.maxLength != null)
          Padding(
            padding: EdgeInsets.only(left: Screen.width(context) * 0.05),
            child: Text(
              '${_controller.text.length}/${widget.maxLength}',
              style: GoogleFonts.roboto(
                color: colors.white.withAlpha(153),
                fontSize: Screen.max(context) * 0.012,
              ),
            ),
          ),
      ],
    );
  }
}
