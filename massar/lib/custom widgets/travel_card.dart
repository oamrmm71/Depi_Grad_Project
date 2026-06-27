import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  location,
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF002B45),
                    fontSize: 18,
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
                child: const Icon(
                  Icons.north_east,
                  color: Colors.white,
                  size: 34,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TravelCardBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.55)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.4;

    final path = _buildPath(size);

    canvas.drawPath(path, paint);
  }

  Path _buildPath(Size size) {
    const radius = 42.0;
    final path = Path();

    path.moveTo(radius, 35);

    // Smooth top-left corner
    path.quadraticBezierTo(
      0,
      35,
      0,
      radius,
    );

    // Left wave rise
    path.quadraticBezierTo(
  size.width * 0.08,
  -8,   // higher on left
  size.width * 0.26,
  8,
);

path.quadraticBezierTo(
  size.width * 0.46,
  44,
  size.width * 0.70,
  18,
);

path.quadraticBezierTo(
  size.width * 0.88,
  12,   // lower on right
  size.width,
  radius,
);

    // Right side
    path.lineTo(size.width, size.height - radius);

    // Bottom-right
    path.arcToPoint(
      Offset(size.width - radius, size.height),
      radius: const Radius.circular(radius),
    );

    // Bottom
    path.lineTo(radius, size.height);

    // Bottom-left
    path.arcToPoint(
      Offset(0, size.height - radius),
      radius: const Radius.circular(radius),
    );

    // Left side
    path.lineTo(0, radius);

    path.close();

    return path;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class TravelCardClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const radius = 42.0;
    final path = Path();

    path.moveTo(radius, 35);

    // Smooth top-left corner
    path.quadraticBezierTo(
      0,
      35,
      0,
      radius,
    );

    // EXACT same left wave rise
    path.quadraticBezierTo(
      size.width * 0.08,
      -8,
      size.width * 0.26,
      8,
    );

    // EXACT same center wave
    path.quadraticBezierTo(
      size.width * 0.46,
      44,
      size.width * 0.70,
      18,
    );

    // EXACT same right wave
    path.quadraticBezierTo(
      size.width * 0.88,
      12,
      size.width,
      radius,
    );

    // Right side
    path.lineTo(size.width, size.height - radius);

    // Bottom-right
    path.arcToPoint(
      Offset(size.width - radius, size.height),
      radius: const Radius.circular(radius),
    );

    // Bottom
    path.lineTo(radius, size.height);

    // Bottom-left
    path.arcToPoint(
      Offset(0, size.height - radius),
      radius: const Radius.circular(radius),
    );

    // Left side
    path.lineTo(0, radius);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}