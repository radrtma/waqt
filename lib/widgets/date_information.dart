import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DateInformation extends StatelessWidget {
  final String gDate;
  final String hDate;

  const DateInformation({
    super.key,
    required this.gDate,
    required this.hDate,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$gDate / $hDate',
        style: GoogleFonts.inter(
          color: const Color(0xFF2C2C2C).withOpacity(0.6),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
