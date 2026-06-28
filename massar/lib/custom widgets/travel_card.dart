import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:massar/home%20screen/screens/travel_detail_screen.dart';

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
        fit: StackFit.expand,
        children: [
          ClipPath(
            clipper: TravelCardClipper(),
            child: Image.network(
              image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;

                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey,
                  child: const Center(
                    child: Icon(
                      Icons.broken_image,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ),

          CustomPaint(
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

  // Convex corner humps + concave center dip (mirrored saddle shape).
  const leftHumpY = -38.0;
  const rightHumpY = -32.0;
  const centerDipY = 40.0;

  path.moveTo(radius, h);

  path.arcToPoint(
    Offset(0, h - radius),
    radius: const Radius.circular(radius),
  );

  path.lineTo(0, radius);

  // Left corner hump — rounds off the left edge into the top wave
  path.cubicTo(
    0, 4,
    w * 0.16, leftHumpY,
    w * 0.34, 14,
  );

  // Wide concave dip across the centre
  path.cubicTo(
    w * 0.44, centerDipY,
    w * 0.56, centerDipY,
    w * 0.66, 14,
  );

  // Right corner hump — mirrors the left, blends into the right edge
  path.cubicTo(
    w * 0.84, rightHumpY,
    w, 4,
    w, radius,
  );

  path.lineTo(w, h - radius);

  // Bottom-right corner
  path.arcToPoint(
    Offset(w - radius, h),
    radius: const Radius.circular(radius),
  );

  // Bottom
  path.lineTo(radius, h);

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
  bool shouldReclip(TravelCardClipper oldClipper) => false;
}