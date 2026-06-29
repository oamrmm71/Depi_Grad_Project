import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:massar/custom%20widgets/glass_container.dart';

class NotificationItem {
  final IconData icon;
  final String title;
  final String message;
  final String time;
  final bool isUnread;

  const NotificationItem({
    required this.icon,
    required this.title,
    required this.message,
    required this.time,
    required this.isUnread,
  });
}

class NotificationCard extends StatelessWidget {
  final NotificationItem item;

  const NotificationCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: 24,
      padding: const EdgeInsets.all(18),
      backgroundColor: item.isUnread
          ? Colors.white.withValues(alpha: 0.16)
          : Colors.white.withValues(alpha: 0.08),
      borderColor: item.isUnread
          ? Colors.white.withValues(alpha: 0.30)
          : Colors.white.withValues(alpha: 0.12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlassContainer(
            width: 46,
            height: 46,
            borderRadius: 50,
            backgroundColor: Colors.white.withValues(alpha: 0.15),
            borderColor: Colors.white.withValues(alpha: 0.25),
            child: Icon(item.icon, color: Colors.white, size: 22),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.title,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: item.isUnread
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      children: [
                        if (item.isUnread)
                          Container(
                            width: 7,
                            height: 7,
                            margin: const EdgeInsets.only(right: 6, top: 1),
                            decoration: const BoxDecoration(
                              color: Color(0xFF7EB3FF),
                              shape: BoxShape.circle,
                            ),
                          ),
                        Text(
                          item.time,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w300,
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.message,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    color: Colors.white.withValues(alpha: 0.75),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
