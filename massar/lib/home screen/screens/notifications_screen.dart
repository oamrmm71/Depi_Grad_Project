import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:massar/custom%20widgets/glass_button.dart';
import 'package:massar/custom%20widgets/notification_card.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  static const List<NotificationItem> _notifications = [
    NotificationItem(
      icon: Icons.flight_takeoff,
      title: 'Flight Confirmed',
      message: 'Your flight MS703 to Dubai is confirmed. Departure on 02/07/2026 at 09:45.',
      time: '2m ago',
      isUnread: true,
    ),
    NotificationItem(
      icon: Icons.local_offer_outlined,
      title: 'Exclusive Deal',
      message: '30% off on Paris packages this week. Budget-friendly options available from 5,000 EGP.',
      time: '1h ago',
      isUnread: true,
    ),
    NotificationItem(
      icon: Icons.notifications_active_outlined,
      title: 'Trip Reminder',
      message: 'Your Istanbul trip is in 3 days. Don\'t forget to check in online 24 hours before.',
      time: '3h ago',
      isUnread: true,
    ),
    NotificationItem(
      icon: Icons.hotel_outlined,
      title: 'Booking Updated',
      message: 'Your room at Rotana Yas Island has been upgraded to a Deluxe Suite at no extra cost.',
      time: '1d ago',
      isUnread: false,
    ),
    NotificationItem(
      icon: Icons.beach_access_outlined,
      title: 'New Destination',
      message: 'Maldives packages are now available within your budget. Explore 4-night deals.',
      time: '2d ago',
      isUnread: false,
    ),
    NotificationItem(
      icon: Icons.star_outline,
      title: 'Rate Your Trip',
      message: 'How was your Tokyo experience? Share your feedback and help other travelers.',
      time: '3d ago',
      isUnread: false,
    ),
    NotificationItem(
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
                      GlassButton(
                        width: 46,
                        height: 46,
                        borderRadius: 50,
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 20,
                        ),
                        onTap: () => Navigator.pop(context),
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
                        NotificationCard(item: _notifications[index]),
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
