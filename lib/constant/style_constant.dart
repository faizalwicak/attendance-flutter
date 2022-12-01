import 'package:attendance_flutter/constant/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle labelTextStyle = GoogleFonts.inter(
  color: inputTextColor,
  fontWeight: FontWeight.w400,
  fontSize: 12,
);

TextStyle inputTextStyle = GoogleFonts.inter(
  color: inputTextColor,
  fontWeight: FontWeight.w400,
  fontSize: 16,
);

InputDecoration inputDecoration = const InputDecoration(
  isDense: true,
  hintStyle: TextStyle(color: inputPlaceholderTextColor),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(6)),
    borderSide: BorderSide(
      color: Color(0xffe2e5e8),
      width: 2,
    ),
  ),
  contentPadding: EdgeInsets.symmetric(
    horizontal: 15,
    vertical: 10,
  ),
);

Widget roundElevatedButton({
  required String title,
  required bool isLoading,
  Function? onClick,
}) =>
    ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(40),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(6),
          ),
        ),
      ),
      onPressed: isLoading
          ? null
          : () {
              onClick?.call();
            },
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(),
            )
          : Text(
              'Masuk',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
    );
