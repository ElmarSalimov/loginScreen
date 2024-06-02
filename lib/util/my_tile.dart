import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTile extends StatelessWidget {
  final String tileText;
  final bool? isDone;
  void Function(bool?)? onChanged;

  MyTile(
      {super.key,
      required this.tileText,
      required this.isDone,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.yellow.shade200,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Checkbox(
                value: isDone, onChanged: onChanged, activeColor: Colors.black),
            const SizedBox(
              width: 10,
            ),
            Text(
              tileText,
              style: GoogleFonts.montserrat(
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500)),
            )
          ],
        ),
      ),
    );
  }
}
