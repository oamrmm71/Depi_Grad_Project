import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:massar/custom%20widgets/glass_container.dart';
import 'package:massar/theme/app_colors.dart';

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
          ? AppColors.notifUnreadFill
          : AppColors.notifReadFill,
      borderColor: item.isUnread
          ? AppColors.notifUnreadBorder
          : AppColors.notifReadBorder,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlassContainer(
            width: 46,
            height: 46,
            borderRadius: 50,
            backgroundColor: AppColors.notifIconBg,
            borderColor: AppColors.notifIconBorder,
            child: Icon(item.icon, color: AppColors.white, size: 22),
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
                        color: AppColors.white,
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
                              color: AppColors.unreadDot,
                              shape: BoxShape.circle,
                            ),
                          ),
                        Text(
                          item.time,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w300,
                            color: AppColors.whiteDim,
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
                    color: AppColors.whiteMuted,
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
