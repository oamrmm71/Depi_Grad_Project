import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  static const List<_NotificationItem> _notifications = [
    _NotificationItem(
      icon: Icons.flight_takeoff,
      title: 'Flight Confirmed',
      message: 'Your flight MS703 to Dubai is confirmed. Departure on 02/07/2026 at 09:45.',
      time: '2m ago',
      isUnread: true,
    ),
    _NotificationItem(
      icon: Icons.local_offer_outlined,
      title: 'Exclusive Deal',
      message: '30% off on Paris packages this week. Budget-friendly options available from 5,000 EGP.',
      time: '1h ago',
      isUnread: true,
    ),
    _NotificationItem(
      icon: Icons.notifications_active_outlined,
      title: 'Trip Reminder',
      message: 'Your Istanbul trip is in 3 days. Don\'t forget to check in online 24 hours before.',
      time: '3h ago',
      isUnread: true,
    ),
    _NotificationItem(
      icon: Icons.hotel_outlined,
      title: 'Booking Updated',
      message: 'Your room at Rotana Yas Island has been upgraded to a Deluxe Suite at no extra cost.',
      time: '1d ago',
      isUnread: false,
    ),
    _NotificationItem(
      icon: Icons.beach_access_outlined,
      title: 'New Destination',
      message: 'Maldives packages are now available within your budget. Explore 4-night deals.',
      time: '2d ago',
      isUnread: false,
    ),
    _NotificationItem(
      icon: Icons.star_outline,
      title: 'Rate Your Trip',
      message: 'How was your Tokyo experience? Share your feedback and help other travelers.',
      time: '3d ago',
      isUnread: false,
    ),
    _NotificationItem(
      icon: Icons.attach_money,
      title: 'Price Drop Alert',
      message: 'Flights to Singapore dropped by 15%. Book now before prices go back up.',
      time: '5d ago',
      isUnread: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xFF00287C),
                  Color(0xFF01253D),
                  Color(0xFF00133F),
                ],
                stops: [0.0, 0.45, 1.0],
              ),
            ),
          ),

          // Bottom-left glow
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(-0.9, 0.9),
                radius: 1.15,
                colors: [
                  const Color(0xFFBAD1FF).withValues(alpha: 0.28),
                  const Color(0xFFBAD1FF).withValues(alpha: 0.08),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.55, 1.0],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: _GlassIcon(icon: Icons.arrow_back_ios_new, size: 20),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'YOUR',
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.w200,
                              fontStyle: FontStyle.italic,
                              color: Colors.white,
                              height: 0.9,
                            ),
                          ),
                          Text(
                            'NOTIFICATIONS',
                            style: GoogleFonts.poppins(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Notification list
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                    itemCount: _notifications.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) =>
                        _NotificationCard(item: _notifications[index]),
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

class _NotificationCard extends StatelessWidget {
  final _NotificationItem item;

  const _NotificationCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: item.isUnread
                ? Colors.white.withValues(alpha: 0.16)
                : Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: item.isUnread
                  ? Colors.white.withValues(alpha: 0.30)
                  : Colors.white.withValues(alpha: 0.12),
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon bubble
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.25),
                    width: 1,
                  ),
                ),
                child: Icon(
                  item.icon,
                  color: Colors.white,
                  size: 22,
                ),
              ),

              const SizedBox(width: 14),

              // Text content
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
        ),
      ),
    );
  }
}

class _GlassIcon extends StatelessWidget {
  final IconData icon;
  final double size;

  const _GlassIcon({required this.icon, required this.size});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.18),
              width: 1,
            ),
          ),
          child: Icon(icon, color: Colors.white, size: size),
        ),
      ),
    );
  }
}

class _NotificationItem {
  final IconData icon;
  final String title;
  final String message;
  final String time;
  final bool isUnread;

  const _NotificationItem({
    required this.icon,
    required this.title,
    required this.message,
    required this.time,
    required this.isUnread,
  });
}
