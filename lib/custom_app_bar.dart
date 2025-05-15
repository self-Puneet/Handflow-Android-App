import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(8.0), // Add some padding if needed
        child: Image.asset('assets/app_icon.png'), // Path to the logo image
      ),
      elevation: 10,
      shadowColor: Colors.black.withOpacity(0.3),
      title: const Text(
        'HandFlow',
        style: TextStyle(
          fontSize: 24, // Increase the font size as desired
          fontWeight: FontWeight.bold, // Optional: Make the text bold
          color: Colors.white, // Optional: Set the color for better contrast
        ),
      ),
      backgroundColor: Color(0xFF14151A),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
