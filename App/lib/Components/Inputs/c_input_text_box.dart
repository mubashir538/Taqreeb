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
  final int? maxLength; // New parameter for max length

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
    this.maxLength, // Added maxLength parameter
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

    // Add listener to controller for price formatting
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

    // Don't format if the text hasn't changed (to prevent infinite loops)
    if (text == _previousText) return;

    _previousText = text;

    if (text.isEmpty) {
      _controller.text = '';
      _controller.selection = TextSelection.collapsed(offset: 0);
      return;
    }

    // Parse the number
    int num = int.tryParse(text) ?? 0;

    // Format with commas
    String formatted = _formatNumberWithCommas(num);

    // Only update if the formatted text is different from the current text
    if (formatted != _controller.text) {
      _controller.text = formatted;

      // Move cursor to the end
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: Screen.max(context) * 0.01),
          height: Screen.height(context) * 0.06,
          width: Screen.width(context) * 0.9,
          decoration: BoxDecoration(
            color: MyColors.DarkLighter,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _isFocused
                  ? MyColors.red
                  : (widget.errorText != null && widget.errorText!.isNotEmpty
                      ? MyColors.red
                      : Colors.transparent),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(102),
                blurRadius: 4,
                spreadRadius: 1,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: Screen.width(context) * 0.05),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    onSubmitted: widget.onFieldSubmitted,
                    onChanged: (value) {
                      // Enforce max length if specified
                      if (widget.maxLength != null &&
                          value.length > widget.maxLength!) {
                        _controller.text = _previousText;
                        _controller.selection = TextSelection.collapsed(
                          offset: _previousText.length,
                        );
                        return;
                      }

                      _previousText = value;

                      if (widget.onChanged != null) {
                        // Pass the raw number without commas to the callback
                        String rawValue = widget.isPrice
                            ? value.replaceAll(RegExp(r'[^0-9]'), '')
                            : value;
                        widget.onChanged!(rawValue);
                      }
                    },
                    obscureText: widget.isPassword ? _isObscured : false,
                    keyboardType: widget.isNum
                        ? TextInputType.number
                        : widget.isPrice
                            ? TextInputType.numberWithOptions(decimal: true)
                            : TextInputType.text,
                    inputFormatters: [
                      if (widget.isNum) FilteringTextInputFormatter.digitsOnly,
                      if (widget.isPrice)
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
                      if (widget.maxLength != null)
                        LengthLimitingTextInputFormatter(widget.maxLength),
                    ],
                    style: GoogleFonts.montserrat(
                      fontSize: Screen.max(context) * 0.018,
                      fontWeight: FontWeight.w400,
                      color: MyColors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: widget.hint,
                      hintStyle: GoogleFonts.montserrat(
                        color: MyColors.white.withAlpha(153),
                        fontSize: Screen.max(context) * 0.015,
                      ),
                      border: InputBorder.none,
                      counterText: '', // Remove default counter
                    ),
                    maxLength: widget.maxLength, // Set max length
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
              style: GoogleFonts.montserrat(
                color: MyColors.red,
                fontSize: Screen.max(context) * 0.015,
              ),
            ),
          ),
        // Show remaining characters counter if maxLength is specified
        if (widget.maxLength != null)
          Padding(
            padding: EdgeInsets.only(left: Screen.width(context) * 0.05),
            child: Text(
              '${_controller.text.length}/${widget.maxLength}',
              style: GoogleFonts.montserrat(
                color: MyColors.white.withAlpha(153),
                fontSize: Screen.max(context) * 0.012,
              ),
            ),
          ),
      ],
    );
  }
}
