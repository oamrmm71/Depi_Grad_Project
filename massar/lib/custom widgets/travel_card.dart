import 'dart:ui' as ui;

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
          _TravelCardImage(imageUrl: image),

          CustomPaint(
            painter: TravelCardBorderPainter(),
          ),

          Positioned(
            top: 77,
            left: 22,
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
                if (location.trim().isNotEmpty)
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
            top: 60,
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

const kTopExtension = 44.0;


Path _buildTravelCardPath(Size layoutSize) {
  const radius = 42.0;
  const topInset = kTopExtension;
  final w = layoutSize.width;
  final h = layoutSize.height - topInset;

  double ty(double y) => y + topInset;

  const leftHumpY = -38.0;
  const rightHumpY = -32.0;
  const centerDipY = 40.0;

  final path = Path();

  path.moveTo(radius, ty(h));

  path.arcToPoint(
    Offset(0, ty(h - radius)),
    radius: const Radius.circular(radius),
  );

  path.lineTo(0, ty(radius));

  path.cubicTo(
    0, ty(4),
    w * 0.16, ty(leftHumpY),
    w * 0.34, ty(14),
  );

  path.cubicTo(
    w * 0.44, ty(centerDipY),
    w * 0.56, ty(centerDipY),
    w * 0.66, ty(14),
  );

  path.cubicTo(
    w * 0.84, ty(rightHumpY),
    w, ty(4),
    w, ty(radius),
  );

  path.lineTo(w, ty(h - radius));

  path.arcToPoint(
    Offset(w - radius, ty(h)),
    radius: const Radius.circular(radius),
  );

  path.lineTo(radius, ty(h));

  path.close();
  return path;
}

class _TravelCardImage extends StatefulWidget {
  final String imageUrl;

  const _TravelCardImage({required this.imageUrl});

  @override
  State<_TravelCardImage> createState() => _TravelCardImageState();
}

class _TravelCardImageState extends State<_TravelCardImage> {
  ui.Image? _image;
  bool _failed = false;
  ImageStream? _stream;
  ImageStreamListener? _listener;
  String? _resolvedUrl;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_resolvedUrl != widget.imageUrl) {
      _removeListener();
      _failed = false;
      _image = null;
      _resolvedUrl = widget.imageUrl;
      _resolveImage();
    }
  }

  @override
  void didUpdateWidget(_TravelCardImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      _removeListener();
      _failed = false;
      _image = null;
      _resolvedUrl = widget.imageUrl;
      _resolveImage();
    }
  }

  void _resolveImage() {
    final provider = NetworkImage(widget.imageUrl);
    final stream = provider.resolve(createLocalImageConfiguration(context));
    _listener = ImageStreamListener(
      (info, _) {
        if (mounted) setState(() => _image = info.image);
      },
      onError: (Object error, StackTrace? stackTrace) {
        if (mounted) setState(() => _failed = true);
      },
    );
    stream.addListener(_listener!);
    _stream = stream;
  }

  void _removeListener() {
    if (_stream != null && _listener != null) {
      _stream!.removeListener(_listener!);
    }
  }

  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _TravelCardImagePainter(
        image: _image,
        failed: _failed,
      ),
      child: const SizedBox.expand(),
    );
  }
}

class _TravelCardImagePainter extends CustomPainter {
  final ui.Image? image;
  final bool failed;

  const _TravelCardImagePainter({this.image, this.failed = false});

  @override
  void paint(Canvas canvas, Size size) {
    final path = _buildTravelCardPath(size);
    final bounds = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.save();
    canvas.clipPath(path);

    if (image != null) {
      paintImage(
        canvas: canvas,
        rect: bounds,
        image: image!,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.medium,
      );
    } else if (failed) {
      canvas.drawRect(bounds, Paint()..color = Colors.grey.shade600);
    } else {
      canvas.drawRect(bounds, Paint()..color = Colors.grey.shade700);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(_TravelCardImagePainter oldDelegate) {
    return oldDelegate.image != image || oldDelegate.failed != failed;
  }
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
  bool shouldRepaint(TravelCardBorderPainter oldDelegate) => false;
}