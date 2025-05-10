import 'dart:async';

import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/utils/color.dart';

class SearchBox extends StatefulWidget {
  final TextEditingController controller;
  final double width;
  final VoidCallback? onclick;
  final bool isHome;
  final String hint;
  final FocusNode focusNode;
  final Function(String) onChanged;
  final Duration debounceDuration;

  const SearchBox({
    super.key,
    this.isHome = false,
    required this.onChanged,
    required this.hint,
    required this.controller,
    required this.focusNode,
    this.width = 0,
    this.onclick,
    this.debounceDuration = const Duration(seconds: 1),
  });

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    // Cancel any previous debounce timer
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    // Start a new debounce timer
    _debounce = Timer(widget.debounceDuration, () {
      widget.onChanged(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onclick,
      child: Container(
        height: Screen.height(context) * 0.07,
        width: widget.width == 0 ? Screen.width(context) * 0.8 : widget.width,
        decoration: BoxDecoration(
          color: MyColors.darkLighter,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: Screen.max(context) * 0.02),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.search, color: MyColors.white),
              Container(
                margin: EdgeInsets.only(left: Screen.max(context) * 0.02),
                width: Screen.width(context) * 0.5,
                child: GestureDetector(
                  onTap: widget.onclick,
                  child: TextField(
                    readOnly: widget.isHome ? true : false,
                    focusNode: widget.focusNode,
                    onTap: widget.onclick,
                    controller: widget.controller,
                    onChanged: _onSearchChanged,
                    onSubmitted: (value) {
                      // Cancel debounce timer if user presses enter/submit
                      _debounce?.cancel();
                      widget.onChanged(value);
                    },
                    style: GoogleFonts.roboto(
                      fontSize: Screen.max(context) * 0.015,
                      fontWeight: FontWeight.w400,
                      color: MyColors.white,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: widget.hint,
                      hintStyle: GoogleFonts.roboto(
                        fontSize: Screen.max(context) * 0.015,
                        color: MyColors.whiteDarker,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
