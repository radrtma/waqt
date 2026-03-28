import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DateInformation extends StatelessWidget {
  const DateInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Friday, 13 March / 23 Ramadhan 1447 H',
        style: GoogleFonts.inter(
          color: const Color(0xFF2C2C2C).withOpacity(0.6),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
