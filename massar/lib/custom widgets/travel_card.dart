import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:massar/travel_detail_screen.dart';

class TravelCard extends StatelessWidget {
  final String title;
  final String location;
  final String image;
  final VoidCallback? onTap;

  const TravelCard({
    super.key,
    required this.title,
    required this.location,
    required this.image,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      child: Stack(
        children: [
          ClipPath(
            clipper: TravelCardClipper(),
            child: Transform.scale(
              scale: 1.08,
              child: Transform.translate(
                offset: const Offset(0, -18),
                child: Image.asset(
                  image,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          CustomPaint(
            size: Size.infinite,
            painter: TravelCardBorderPainter(),
          ),

          Positioned(
            top: 38,
            left: 28,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF002B45),
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  location,
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF002B45),
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            top: 22,
            right: 22,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                width: 68,
                height: 68,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF002B45),
                ),
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TravelDetailScreen(),
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.north_east,
                    color: Colors.white,
                    size: 34,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Shared path builder so the painter (border) and clipper (image mask)
/// always use the exact same shape and can never drift out of sync.
Path _buildTravelCardPath(Size size) {
  const radius = 42.0;
  final w = size.width;
  final h = size.height;
  final path = Path();

  path.moveTo(radius, 30);

  // Smooth top-left corner
  path.quadraticBezierTo(0, 30, 0, radius);

  // First swell: rises high on the left
  path.cubicTo(
    w * 0.06, -32,
    w * 0.18, -30,
    w * 0.34, 6,
  );

  // Middle dip — tangent-matched, so it flows continuously from the first curve
  path.cubicTo(
    w * 0.46, 38,
    w * 0.60, 40,
    w * 0.74, 14,
  );

  // Final rise into the top-right corner — lower peak than the left side
  path.cubicTo(
    w * 0.84, -4,
    w * 0.94, 2,
    w, radius,
  );

  // Right side
  path.lineTo(w, h - radius);

  // Bottom-right corner
  path.arcToPoint(
    Offset(w - radius, h),
    radius: const Radius.circular(radius),
  );

  // Bottom
  path.lineTo(radius, h);

  // Bottom-left corner
  path.arcToPoint(
    Offset(0, h - radius),
    radius: const Radius.circular(radius),
  );

  // Left side
  path.lineTo(0, radius);

  path.close();
  return path;
}

class TravelCardBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    canvas.drawPath(_buildTravelCardPath(size), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class TravelCardClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) => _buildTravelCardPath(size);

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}